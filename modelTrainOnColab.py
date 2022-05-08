import train_model
import multiprocessing as mp
import os


if __name__ == '__main__':
    mp.set_start_method('spawn')
    # MobileNet
    model_option, model_weights, dataset_path = 'Mobilenet', '', 'D:/毕设/人脸识别/datasets/CASIA-WebFace/'
    is_freeze_train, nb_workers, learning_rate, log_dir = False, 5, 0.001, 'logs/'
    _model = train_model.Train(backbone=model_option, model_path=model_weights, datasets_path=dataset_path, log_dir=log_dir,
                                input_shape=[160, 160, 3], is_freeze_train=False, nb_workers=nb_workers, learning_rate=learning_rate)
    if not os.path.exists('cls_train.txt'):
        _model.write_dataset_txt()
    _model.train()

    # Inception ResNet V1
    model_option = 'Resnet'
    _model = train_model.Train(backbone=model_option, model_path=model_weights, datasets_path=dataset_path, log_dir=log_dir,
                                input_shape=[160, 160, 3], is_freeze_train=False, nb_workers=nb_workers, learning_rate=learning_rate)
    _model.train()

    # Inception V2
    model_option = 'Inception V2'
    _model = train_model.Train(backbone=model_option, model_path=model_weights, datasets_path=dataset_path, log_dir=log_dir,
                                input_shape=[96, 96, 3], is_freeze_train=False, nb_workers=nb_workers, learning_rate=learning_rate)
    _model.train()

    # VGG16
    model_option = 'VGG'
    _model = train_model.Train(backbone=model_option, model_path=model_weights, datasets_path=dataset_path, log_dir=log_dir, 
                                input_shape=[224, 224, 3], is_freeze_train=False, nb_workers=nb_workers, learning_rate=learning_rate)
    _model.train()