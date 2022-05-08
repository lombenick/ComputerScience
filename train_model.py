from mimetypes import init
import os
import re
import numpy as np
from keras.callbacks import EarlyStopping, ModelCheckpoint, TensorBoard
from tensorflow.keras.optimizers import Adam
from nets.facenet import facenet
from nets.facenet_training import FacenetDataset, triplet_loss
from utils.callbacks import ExponentDecayScheduler, LossHistory
import keras.backend as k
k.set_image_data_format('channels_last')


class Train:
    def __init__(self, datasets_path='', annotation_path='cls_train.txt', input_shape: list = None, backbone='Mobilenet',
                 model_path='', log_dir='logs/', is_freeze_train=True, nb_workers=1, batch_size=32, learning_rate=1e-4, epoch=15):
        self.input_shape = input_shape
        self.datasets_path = datasets_path
        self.annotation_path = annotation_path
        self.nb_classes = 0
        self.backbone = backbone
        self.model_path = model_path
        self.log_dir = log_dir
        self.is_freeze_train = is_freeze_train
        self.nb_workers = nb_workers
        self.batch_size = batch_size
        self.learning_rate = learning_rate
        self.epoch = epoch

    def write_dataset_txt(self) -> None:
        """
        convert the dataset that will be trained into a txt file
        the format:label;absolute path
        Args:
            self
        Returns:
            none
        """
        types_name = os.listdir(self.datasets_path)
        types_name = sorted(types_name)

        list_file = open(self.annotation_path, 'w', encoding='utf-8')
        for _id, type_name in enumerate(types_name):
            photos_path = os.path.join(self.datasets_path, type_name)
            if not os.path.isdir(photos_path):
                continue
            photos_name = os.listdir(photos_path)

            for photo_name in photos_name:
                list_file.write(str(_id) + ";" + '%s' %
                                (os.path.join(os.path.abspath(self.datasets_path), type_name, photo_name)))
                list_file.write('\n')
        list_file.close()

    def get_num_classes(self) -> int:
        """
        Gets the total number of dataset categories
        Args:
            self
        Returns:
            nb_class: the number of total classes in dataset
        """
        with open(self.annotation_path, encoding='utf-8') as f:
            dataset_path = f.readlines()
        labels = []
        for path in dataset_path:
            path_split = path.split(";")
            labels.append(int(path_split[0]))
        num_classes = np.max(labels) + 1
        return num_classes

    def train(self) -> None:
        #   是否进行冻结训练，默认先冻结主干训练后解冻训练
        #   用于设置是否使用多线程读取数据，1代表关闭多线程
        #   开启后会加快数据读取速度，但是会占用更多内存
        #   在IO为瓶颈的时候再开启多线程，即GPU运算速度远大于读取图片的速度。
        nb_classes = self.get_num_classes()
        # 载入模型并加载预训练权重
        model = facenet(nb_classes, backbone=self.backbone, mode="train")
        if self.model_path != '':
            #   载入预训练权重
            model.load_weights(self.model_path, by_name=True, skip_mismatch=True)

        """
            训练参数的设置
            logging表示tensorboard的保存地址
            checkpoint用于设置权值保存的细节，period用于修改多少epoch保存一次
            reduce_lr用于设置学习率下降的方式
            early_stopping用于设定早停，val_loss多次不下降自动结束训练，表示模型基本收敛
        """
        checkPointPath = self.log_dir + self.backbone + 'ep{epoch:03d}-loss{loss:.3f}-val_loss{val_loss:.3f}.h5'
        checkpoint_period = ModelCheckpoint(checkPointPath, monitor='val_loss', save_weights_only=True, 
                                            save_best_only=False, save_freq='epoch')
        reduce_lr = ExponentDecayScheduler(decay_rate=0.94, verbose=1)
        early_stopping = EarlyStopping(monitor='val_loss', min_delta=0, patience=10, verbose=1)
        tensorboard = TensorBoard(log_dir=self.log_dir)
        loss_history = LossHistory(self.log_dir)

        # 读取数据集 0.05用于验证，0.95用于训练
        val_split = 0.05
        with open(self.annotation_path, encoding='utf-8') as f:
            lines = f.readlines()
        np.random.seed(10101)
        np.random.shuffle(lines)
        np.random.seed(None)
        nb_val = int(len(lines) * val_split)
        nb_train = len(lines) - nb_val
        if self.is_freeze_train:
            if self.backbone == "Mobilenet":
                freeze_layer = 81
            elif self.backbone == "Resnet":
                freeze_layer = 440
            else:
                raise ValueError('Unsupported backbone - `{}`.'.format(self.backbone))

            freeze_epoch = self.epoch // 3
            for i in range(freeze_layer):
                model.layers[i].trainable = False
        else:
            freeze_epoch = 0
        """
            训练分为两个阶段，分别是冻结阶段(模型的主干被冻结了，占用GPU资源小)和解冻阶段（模型主干解冻，占用GPU资源大）
            显存不足与数据集大小无关，提示显存不足请调小batch_size
            受到BatchNorm层影响，batch_size最小为2，不能为1。
            
            Init_Epoch为起始迭代
            Freeze_Epoch为冻结训练迭代
            Epoch总训练迭代
            提示OOM或者显存不足请调小Batch_size
        """
        batch_size = 64
        learning_rate = 1e-3
        init_epoch = 0

        epoch_step = nb_train // batch_size
        epoch_step_val = nb_val // batch_size

        if epoch_step == 0 or epoch_step_val == 0:
            raise ValueError('数据集过小，无法进行训练，请扩充数据集。')

        model.compile(
            loss={'Embedding': triplet_loss(batch_size=batch_size), 'Softmax': 'categorical_crossentropy'},
            optimizer=Adam(learning_rate=learning_rate), metrics={'Softmax': 'categorical_accuracy'}
        )
        print('Freeze stage:batch size is {}.'.format(batch_size))

        train_dataset = FacenetDataset(self.input_shape, lines[:nb_train], nb_train, nb_classes, batch_size, backbone=self.backbone)
        val_dataset = FacenetDataset(self.input_shape, lines[nb_train:nb_train + nb_val + 1], nb_val, nb_classes, batch_size, backbone=self.backbone)
        callback = [checkpoint_period, reduce_lr, early_stopping, tensorboard, loss_history]
        print(self.backbone)

        for file in os.listdir(self.log_dir):      # 恢复断点
            if self.backbone in file and '.h5' in file:
                init_epoch = int(re.findall(r'ep\d+', file)[0][2:])
                model.load_weights(self.log_dir + file)

        model.fit(
            train_dataset,
            steps_per_epoch=epoch_step,
            validation_data=val_dataset,
            validation_steps=epoch_step_val,
            epochs=freeze_epoch,
            initial_epoch=init_epoch,
            use_multiprocessing=True if self.nb_workers > 1 else False,
            workers=self.nb_workers,
            callbacks=callback
        )
        print('Freeze stage is finished!')

        # 解冻阶段
        if self.is_freeze_train:
            for i in range(freeze_layer):
                model.layers[i].trainable = True

        # 解冻阶段训练参数
        # 此时模型的主干不被冻结了，特征提取网络会发生改变
        # 占用的显存较大，网络所有的参数都会发生改变
        epoch = self.epoch

        epoch_step = nb_train // self.batch_size
        epoch_step_val = nb_val // self.batch_size

        if epoch_step == 0 or epoch_step_val == 0:
            raise ValueError('datasets too small, couldnot train model!')

        model.compile(
            loss={'Embedding': triplet_loss(batch_size=self.batch_size), 'Softmax': 'categorical_crossentropy'},
            optimizer=Adam(learning_rate=self.learning_rate), metrics={'Softmax': 'categorical_accuracy'}
        )
        print('Unfreeze stage: batch size is {}.'.format(self.batch_size))

        train_dataset = FacenetDataset(self.input_shape, lines[:nb_train], nb_train, nb_classes, self.batch_size, backbone=self.backbone)
        val_dataset = FacenetDataset(self.input_shape, lines[nb_train:nb_train + nb_val + 1], nb_val, nb_classes, self.batch_size, backbone=self.backbone)
        callback = [checkpoint_period, reduce_lr, early_stopping, tensorboard, loss_history]

        if init_epoch < freeze_epoch:
            init_epoch = freeze_epoch
        model.fit(
            train_dataset,
            steps_per_epoch=epoch_step,
            validation_data=val_dataset,
            validation_steps=epoch_step_val,
            epochs=epoch,
            initial_epoch=init_epoch,
            use_multiprocessing=True if self.nb_workers > 1 else False,
            workers=self.nb_workers,
            callbacks=callback
        )

        print('Model training is complete!\n')
        model.save_weights('model_data/FaceNet_{}.h5'.format(self.backbone))
        print('model weights have been saved!')
