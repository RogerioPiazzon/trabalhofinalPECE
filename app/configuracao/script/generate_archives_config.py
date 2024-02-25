import pandas as pd
import sqlite3
import re
import json
import os
import os.path as path



class generate_files_config():
    root_path = str
    def __init__(self,root) -> None:
        self.root_path = root
        pass
    

    def get_info_column(self,file,sheet):
        output = dict()
        df_table = pd.read_excel(file,sheet_name=sheet[:31])
        for i,row in df_table.iterrows():
            output.update({row['Campo']:{"Descrição":row['Descrição']}})

        return output


    def create_dict_terms(self):

        if not os.path.exists(path.join(self.root_path ,r"dados\ddl\create_tables.sql")) or \
            not os.path.exists(path.join(self.root_path ,r"configuracao\rawfiles\Metadados_preenchido.xlsx")) or \
            not os.path.exists(path.join(self.root_path ,r"dados\db\dbo2.db")): 
            print("Não foi possivel criar o arquivo solicitado")
            return None
    
        sql_file = open(path.join(self.root_path ,r"dados\ddl\create_tables.sql"),encoding="ISO-8859-1")
        sql_as_string = sql_file.read()
        sql_file.close()
        ddl_tables = dict()
        relation_tables = dict()

        regex_create_table = r"\bCREATE\s+TABLE\s+\[\w+\]\.\[\w+\]\s*\(\s*([^;]+)\s*\);"
        regex_name_table = r"\bCREATE\s+TABLE\s+\[(\w+)\]\.\[(\w+)\]"
        regex_relations = r'FOREIGN KEY\((\w+)\)\s+REFERENCES\s+(\w+)\((\w+)\)'

        matches = re.finditer(regex_create_table, sql_as_string)

        regex_name_table = r"\bCREATE\s+TABLE\s+\[(\w+)\]\.\[(\w+)\]"

        for matche in matches:
            list_relations = list()

            name_table = re.search(regex_name_table, matche.group())
            relations = re.finditer(regex_relations, matche.group())
            for relation in relations:
                list_relations.append([{name_table.group(2):relation.group(1)},{relation.group(2):relation.group(3)}])

            
            ddl_tables[name_table.group(2)]  = matche.group()
            relation_tables[name_table.group(2)] = list_relations

        df = pd.read_excel(path.join(self.root_path ,r"configuracao\rawfiles\Metadados_preenchido.xlsx"),sheet_name="Resumo das tabelas")

        conn = sqlite3.connect(path.join(self.root_path ,r"dados\db\dbo2.db"))
        metadata_json = dict()
        for i,row in df.iterrows():
            metadata_json.update({row["Nome"]:{nm:vl if vl else "" for nm,vl in row.items() if nm != "Nome"} })
            metadata_json[row["Nome"]].update({"Colunas":self.get_info_column(path.join(self.root_path ,r"configuracao\rawfiles\Metadados_preenchido.xlsx"),row["Nome"])})
            metadata_json[row["Nome"]].update({"DDL":ddl_tables.get(row["Nome"],'')})
            metadata_json[row["Nome"]].update({"Relações":relation_tables.get(row["Nome"],'')})
            sql_query = f"""SELECT * FROM {row['Nome']};"""
            df_by_sql = pd.read_sql(sql_query,conn)
            desc = df_by_sql.describe(include='all')
            only_unique = desc.loc[desc.index.isin(["unique"])].T.reset_index()
            lista_unique = only_unique.loc[only_unique['unique']<=5,'index'].values.tolist()
            if len(lista_unique)>1:
                for coluna in lista_unique:
                    unique_by_col_sql = pd.read_sql(f"""SELECT DISTINCT {coluna} FROM {row["Nome"]}""",conn)
                    metadata_json[row["Nome"]]['Colunas'][coluna].update({"Valores Possíveis":unique_by_col_sql[coluna].values.tolist()}) 
        path.join(self.root_path ,r"dados\db\dbo2.db")
        with open(path.join(self.root_path ,r"configuracao\files\dicionario_dados.json"), "w") as outfile: 
            json.dump(metadata_json, outfile)

    def create_aventureqi(self):
        if not os.path.exists(path.join(self.root_path ,r"configuracao\rawfiles\querys.xlsx")):
            print("Não foi possivel criar o arquivo solicitado")
            return None

        file = path.join(self.root_path ,r"configuracao\rawfiles\querys.xlsx")
        df = pd.read_excel(file,sheet_name='Planilha1')
        df_to_use = df.loc[:,["Question","NEW INTENT","SQL"]].dropna()
        data=df_to_use.rename(columns = {'NEW INTENT': 'INTENT', 'Question': 'QUESTION','SQL':'QUERY'}, inplace = False)
        dict_output = dict()
        for i,row in data.drop_duplicates().iterrows():
            dict_output.update({row['QUESTION']:{'INTENT':row['INTENT'],'QUERY':row['QUERY']}})
        with open(path.join(self.root_path ,r"configuracao\files\AdventureQI.json"), "w") as outfile: 
            json.dump(dict_output, outfile)

    def create_intent_table(self):
        if not os.path.exists(path.join(self.root_path ,r"configuracao\rawfiles\querys.xlsx")):
            print("Não foi possivel criar o arquivo solicitado")
            return None
        dict_output = dict()
        file = path.join(self.root_path ,r"configuracao\rawfiles\querys.xlsx")
        df = pd.read_excel(file,sheet_name='Planilha1')
        for i,row in df[["NEW INTENT","TABLE"]].drop_duplicates().dropna().iterrows():
            dict_output.update({row['NEW INTENT']:[table.replace(' ','') for table in row['TABLE'].split(",")]})
        
        with open(path.join(self.root_path ,r"configuracao\files\intent_table.json"), "w") as outfile: 
            json.dump(dict_output, outfile)

if __name__ == "__main__":
    root_path =  path.abspath(path.join(__file__ ,"../../.."))
    generate = generate_files_config(root_path)
    generate.create_dict_terms()
    generate.create_aventureqi()
    generate.create_intent_table()