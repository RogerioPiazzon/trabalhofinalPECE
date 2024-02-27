import json
import pickle

class UtilsData():
  def __init__(self):
    with open('/content/drive/MyDrive/PECE/models/dataset_train_test/dataset_dict.pickle', 'rb') as file:
        dataset_dict = pickle.load(file)

    self.num_classes = dataset_dict['n_class']
    self.dict_classes = {str(k):v for k,v in enumerate(dataset_dict['labels'])}

    self.describe_tables = self.load_json(r"/content/drive/MyDrive/PECE/resoucers/dicionario_dados.json")
    self.intents_table = self.load_json(r"/content/drive/MyDrive/PECE/resoucers/AdventureQI.json")
    super().__init__()

  def load_json(self,file):
      f = open(file)
      dict = json.load(f)
      f.close()
      return dict