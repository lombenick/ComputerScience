import numpy as np
import sys
import fr_utils
from nets.vggface_block import preprocess_image
import os


class Apps:
    def __init__(self, model=None, model_option='Inception V2', database=None):
        self.model = model
        self.model_option = model_option
        self.database = database

    def verify(self, img_pairs_list: list):
        encoding1, encoding2 = 0, 1
        if self.model_option == 'Inception V2':
            encoding1 = fr_utils.img_to_encoding(img_pairs_list[0], self.model)
            encoding2 = fr_utils.img_to_encoding(img_pairs_list[1], self.model)
        elif self.model_option == 'VGG':
            encoding1 = self.model.predict(preprocess_image(img_pairs_list[0]))[0, :]
            encoding2 = self.model.predict(preprocess_image(img_pairs_list[1]))[0, :]
        elif self.model_option == 'Mobilenet' or self.model_option == 'Resnet':
            encoding1 = self.model.predict(preprocess_image(img_pairs_list[0], target_size=(160, 160)))[0, :]
            encoding2 = self.model.predict(preprocess_image(img_pairs_list[1], target_size=(160, 160)))[0, :]
        dist = np.linalg.norm(encoding1 - encoding2)
        distance = dist

        if dist < 0.7:
            is_same = True
        else:
            is_same = False

        return is_same, distance

    def who_is_it(self, img_path: str):
        encoding = 0
        if self.model_option == 'Inception V2':
            encoding = fr_utils.img_to_encoding(img_path, self.model)
        elif self.model_option == 'VGG':
            encoding = self.model.predict(preprocess_image(img_path))[0, :]
        elif self.model_option == 'Resnet' or self.model_option == 'Mobilenet':
            encoding = self.model.predict(preprocess_image(img_path, target_size=(160, 160)))[0, :]

        min_dist, identity = sys.maxsize, ''

        # 遍历数据库找到最相近的编码
        for (name, db_enc) in self.database.items():
            dist = np.linalg.norm(encoding - db_enc)

            if dist < min_dist:
                min_dist = dist
                identity = name

        return min_dist, identity

    def generate_database(self, sourcePath: str, distPath: str) -> None:
        newDatabase = {}

        if self.model_option == 'Inception V2':
            for file in os.listdir(sourcePath):
                if 'png' in file:
                    continue
                filename = file.split('.')[0]
                newDatabase[filename] = fr_utils.img_to_encoding(sourcePath + '/' + file, self.model)

        elif self.model_option == 'VGG':
            for file in os.listdir(sourcePath):
                if 'png' in file:
                    continue
                filename = file.split('.')[0]
                newDatabase[filename] = self.model.predict(preprocess_image(sourcePath + '/' + file))[0, :]

        elif self.model_option == 'Resnet' or self.model_option == 'Mobilenet':
            for file in os.listdir(sourcePath):
                if 'png' in file:
                    continue
                filename = file.split('.')[0]
                newDatabase[filename] = self.model.predict(preprocess_image(sourcePath + '/' + file,
                                                                            target_size=(160, 160)))[0, :]

        np.save(os.path.join(distPath, 'newDatabase.npy'), newDatabase, allow_pickle=True)

