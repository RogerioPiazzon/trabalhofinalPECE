import pandas as pd
import sqlite3
import os
import glob
from datetime import datetime
import urllib.request
import zipfile
import os.path as path

class replicate_adventureworksdw():
    root_path=str
    def __init__(self,root) -> None:
        self.root_path = root
        pass

    def app_log(self,nv,msg):
        print(" "*nv + "[{}] INFO - {}".format(datetime.now().strftime("%d/%m/%Y %H:%M:%S"),msg))
    
    def download_files(self):
        url = r"https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW-data-warehouse-install-script.zip"
        filename, headers = urllib.request.urlretrieve(url, filename=path.join(self.root_path ,r"dados\rawfiles\AdventureWorksDW.zip"))
        with open(filename, 'rb') as fileobj:
            z = zipfile.ZipFile(fileobj)
            z.extractall(path.join(self.root_path ,r"dados\rawfiles"))
            z.close
        os.remove(filename)
        
    def create_database(self):
        
        self.app_log(0,"Limpando ambiente")

        if not os.path.exists(path.join(self.root_path ,r"dados\db")):
            os.makedirs(path.join(self.root_path ,r"dados\db"))

        if os.path.exists(path.join(self.root_path ,r"dados\db\dbo.db")):
            os.remove(path.join(self.root_path ,r"dados\db\dbo.db"))

        self.app_log(0,"Criando banco de dados")
        conn = sqlite3.connect(path.join(self.root_path ,r"dados\db\dbo.db"))
        conn.execute("ATTACH DATABASE '{}' AS 'dbo';".format(path.join(self.root_path ,r"dados\db\dbo.db")))
        cur  = conn.cursor()

        self.app_log(0,"Criando tabelas no banco de dados")
        sql_file = open(path.join(self.root_path ,r"dados\ddl\create_tables.sql"),encoding="ISO-8859-1")
        sql_as_string = sql_file.read()
        sql_file.close()
        cur.executescript(sql_as_string)

        conn.commit()
        conn.close()
        total_rows = 0
        conn = sqlite3.connect(path.join(self.root_path ,r"dados\db\dbo.db"))
        dir_list = glob.glob("{}/*.csv".format(path.join(self.root_path ,r"dados\rawfiles")))
        self.app_log(0,"Carga de dados no banco de dados")
        self.app_log(1,"Tabelas Dimensao ")
        dir_list = list(map(lambda file: file.split("\\")[-1], dir_list))

        for arq in filter(lambda file: "Dim" in file,dir_list):
            cursor = conn.execute("select * from {}".format(arq[:-4]))
            colunas = [description[0] for description in cursor.description]
            # columnsQuery = cursor.execute(f"pragma table_info('{arq[5:-4]}')")
            columnInfos = cursor.fetchall()
            columnsNotNull = [item[1] for item in columnInfos if item[3] == 1]

            df = pd.read_csv(path.join(self.root_path ,r"dados\rawfiles",arq),sep="|",
                            encoding="utf16",header=None,names=colunas,lineterminator ='\n')
            for col in columnsNotNull:
                df.dropna(subset=[col], inplace=True)
                
            df = df.replace(r'\r','', regex=True) 
            df_obj = df.select_dtypes('object')
            df[df_obj.columns] = df_obj.apply(lambda x: x.str.strip())
            self.app_log(2,"Carregando {} - {} linhas".format(arq[:-4],df.shape[0]))
            total_rows += df.shape[0]
            df.to_sql(arq[5:-4],conn,if_exists='append',index=False)

        self.app_log(1,"Tabelas Fato")
        for arq in filter(lambda file: "Fact" in file,dir_list):
            cursor = conn.execute("select * from {}".format(arq[:-4]))
            colunas = [description[0] for description in cursor.description]
            columnInfos = cursor.fetchall()
            columnsNotNull = [item[1] for item in columnInfos if item[3] == 1]

            df = pd.read_csv(path.join(self.root_path ,r"dados\rawfiles",arq),sep="|",
                            encoding="utf16",header=None,names=colunas,lineterminator ='\n')
            for col in columnsNotNull:
                df.dropna(subset=[col], inplace=True)
            df = df.replace(r'\r','', regex=True) 
            df_obj = df.select_dtypes('object')
            df[df_obj.columns] = df_obj.apply(lambda x: x.str.strip())

            self.app_log(2,"Carregando {} - {} linhas".format(arq[:-4],df.shape[0]))
            total_rows += df.shape[0]
            df.to_sql(arq[5:-4],conn,if_exists='append',index=False)

        self.app_log(1,"Demais Tabelas ")
        for arq in filter(lambda file: "Fact" not in file and "Dim" not in file ,dir_list):
            try:
                cursor = conn.execute("select * from {}".format(arq[:-4]))
                colunas = [description[0] for description in cursor.description]
                columnInfos = cursor.fetchall()
                columnsNotNull = [item[1] for item in columnInfos if item[3] == 1]

                df = pd.read_csv(path.join(self.root_path ,r"dados\rawfiles",arq),sep="|",
                                encoding="utf16",header=None,names=colunas,lineterminator ='\n')
                for col in columnsNotNull:
                    df.dropna(subset=[col], inplace=True)
                df = df.replace(r'\r','', regex=True) 
                df_obj = df.select_dtypes('object')
                df[df_obj.columns] = df_obj.apply(lambda x: x.str.strip())
            
                df = df.replace(r'\r','', regex=True) 
                df_obj = df.select_dtypes('object')
                df = df.apply(lambda x: x.str.strip(),axis=1)
                self.app_log(2,"Carregando {} - {} linhas".format(arq[:-4],df.shape[0]))
                total_rows += df.shape[0]
                df.to_sql(arq[5:-4],conn,if_exists='append',index=False)
            except:
                df = pd.read_csv(path.join(self.root_path ,r"dados\rawfiles",arq),sep="|",
                                encoding="utf16",header=None,lineterminator ='\n',
                                keep_default_na=False)
                df = df.replace(r'\r','', regex=True) 
                df_obj = df.select_dtypes('object')
                df[df_obj.columns] = df_obj.apply(lambda x: x.str.strip())
                self.app_log(2,"Carregando {} - {} linhas".format(arq[:-4],df.shape[0]))
                total_rows += df.shape[0]
                df.to_sql(arq[5:-4],conn,if_exists='append',index=False)

        conn.close()
        print(total_rows)

if __name__ == "__main__":
    root_path =  path.abspath(path.join(__file__ ,"../../.."))
    replicate = replicate_adventureworksdw(root_path)
    replicate.download_files()
    replicate.create_database()