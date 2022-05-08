import main_ui
import sys
import train_model
from nets.facenet import *
from nets.vggface_block import *
from apps import apps_for_recognition

np.set_printoptions(threshold=sys.maxsize)

def main(*optional, model_option='inception', func='predict') -> None:
    _window = optional[0]
    main_ui.parentWindow.output_printer(_window, 'Start now!')
    if func == 'predict' or func == 'verify' or func == 'generate database':
        FRmodel = facenet(backbone=model_option, mode="predict")
        main_ui.parentWindow.output_printer(_window, 'This model total number of parameter is:{}\n'
                                            .format(FRmodel.count_params()))

        if func == 'predict':
            model_weights_path, database_path, image_path = optional[1], optional[2], optional[3]
            main_ui.parentWindow.output_printer(_window, 'Loading weights...')
            FRmodel.load_weights(model_weights_path, by_name=True)
            main_ui.parentWindow.output_printer(_window, 'Loading database...')
            _database = np.load(database_path, allow_pickle=True).item()
            app = apps_for_recognition.Apps(model=FRmodel, model_option=model_option, database=_database)
            main_ui.parentWindow.output_printer(_window, 'recognizing...\n')
            dist, name = app.who_is_it(image_path)  # recognize
            if dist > 0.7:
                main_ui.parentWindow.output_printer(_window, 'Sorry,the image information is not in the database!')
            else:
                main_ui.parentWindow.output_printer(_window, 'Result:\nThe name is:{}\ndistance:{}'.format(name, dist))

        elif func == 'verify':
            model_weights_path, img1_path, img2_path = optional[1], optional[2], optional[3]
            main_ui.parentWindow.output_printer(_window, 'loading weights...')
            FRmodel.load_weights(model_weights_path, by_name=True)
            app = apps_for_recognition.Apps(model=FRmodel, model_option=model_option)
            main_ui.parentWindow.output_printer(_window, 'verifying...\n')
            is_same, dist = app.verify([img1_path, img2_path])
            if is_same:
                main_ui.parentWindow.output_printer(_window, 'Result:\nThe two pictures are same!\nThe distance is {}'
                                                    .format(dist))
                print('The two images are same!\nThe distance is {}'.format(dist))
            else:
                main_ui.parentWindow.output_printer(_window, 'Result:\nThe two pictures are different'
                                                             '!\nThe distance is {}'.format(dist))
                print('The two images are different!\nThe distance is {}'.format(dist))
        else:
            model_weights_path, sourcePath, databasePath = optional[1], optional[2], optional[3]
            main_ui.parentWindow.output_printer(_window, 'loading weights...')
            FRmodel.load_weights(model_weights_path, by_name=True)
            app = apps_for_recognition.Apps(model=FRmodel, model_option=model_option)
            main_ui.parentWindow.output_printer(_window, 'generating...\n')
            app.generate_database(sourcePath=sourcePath, distPath=databasePath)
            main_ui.parentWindow.output_printer(_window, 'generate successfully!')

    else:
        model_option, model_weights, dataset_path, log_path, num_worker, learning_rate, batch_size, \
            freeze_flag = optional[1], optional[2], optional[3], optional[4], optional[5], optional[6], optional[7], optional[8]
        if model_option == 'Mobilenet' or model_option == 'Resnet':
            input_shape = [160, 160, 3]
        elif model_option == 'Inception V2':
            input_shape = [96, 96, 3]
        elif model_option == 'VGG':
            input_shape = [224, 224, 3]
        else:
            input_shape = None
            main_ui.parentWindow.output_printer(_window, 'input shape wrong!\nTry again!')
            return
        _model = train_model.Train(backbone=model_option, model_path=model_weights, datasets_path=dataset_path,
                                   is_freeze_train=freeze_flag, nb_workers=num_worker, log_dir=log_path, 
                                   input_shape=input_shape, batch_size=batch_size, learning_rate=learning_rate)
        main_ui.parentWindow.output_printer(_window, 'start writing {}!'.format('cls_train.txt'))
        # _model.write_dataset_txt()
        main_ui.parentWindow.output_printer(_window, 'finished!')
        main_ui.parentWindow.output_printer(_window, 'number of classes: {}'.format(_model.get_num_classes()))
        main_ui.parentWindow.output_printer(_window, 'start training!')
        _model.train()
        main_ui.parentWindow.output_printer(_window, 'train has finished!')
        main_ui.parentWindow.output_printer(_window, 'model weights have been saved in the folder called model_data!')

# if __name__ == '__main__':
#     from PyQt5.QtWidgets import QApplication
#     app = QApplication(sys.argv)
#     main(main_ui.parentWindow(), 'C:/Users/XuHongbin/Downloads/Mobilenetep015.h5', 'D:/毕设/人脸识别/images/camera_0.jpg',
#         'D:/毕设/人脸识别/images/kevin.jpg', model_option='Mobilenet', func='verify')

if __name__ == '__main__':
    from PyQt5.QtWidgets import QApplication
    app = QApplication(sys.argv)
    model_option, model_weights, dataset_path, log_path, num_worker, learning_rate, batch_size, freeze_flag = \
        'VGG', '', 'D:/毕设/人脸识别/datasets/CASIA-WebFace', 'D:/毕设/OpenAix/logs', 1, 0.001, 32, False
    main(main_ui.parentWindow(), model_option, model_weights, dataset_path, log_path, num_worker, learning_rate, batch_size, freeze_flag, 
        model_option, func='train')
# C:/Users/XuHongbin/Downloads/Mobilenetep011-loss1.078-val_loss2.035.h5
# D:/毕设/人脸识别/model_data/facenet_mobilenet.h5