import sqlite3
import pd
from singleton import SingletonMeta

class UtilsDB(metaclass = SingletonMeta):
  def __init__(self):
    self.path_scripts = r"/content/drive/MyDrive/PECE/scripts"
    self.path_data = r"/content/drive/MyDrive/PECE/dados"
    self.conn = sqlite3.connect(r"/content/drive/MyDrive/PECE/db/dbo.db")

    super().__init__()
    pass

  def consulta_db(self,sql):
    try:
      df = pd.read_sql(sql,self.conn)
      resposta = df.to_dict("records")
    except:
      resposta = f"ERRO SQL: {sql}"
    return resposta