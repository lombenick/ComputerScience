import keras.backend as K
from keras.layers import Activation, Dense, Input, Lambda
from keras.models import Model
from nets.vggface_block import VGGModel
from nets.inception_blocks_v2 import InceptionV2
from nets.inception_resnetv1 import InceptionResNetV1
from nets.mobilenet import MobileNet


def facenet(num_classes=None, backbone="Mobilenet", mode="train"):
    #   利用主干网络进行特征提取
    if backbone == "Mobilenet":
        inputs = Input(shape=[160, 160, 3])
        model = MobileNet(inputs)
    elif backbone == "Resnet":
        inputs = Input(shape=[160, 160, 3])
        model = InceptionResNetV1(inputs)
    elif backbone == "Inception V2":
        K.set_image_data_format('channels_first')
        inputs = Input([3, 96, 96])
        model = InceptionV2(inputs)
    elif backbone == "VGG":
        K.set_image_data_format('channels_first')
        inputs = Input([3, 224, 224])
        model = VGGModel(inputs)
    else:
        raise ValueError('Unsupported backbone - `{}`'.format(backbone))

    if mode == "train":
        # --------------------------------------------#
        #   训练的话利用交叉熵和triplet_loss
        #   结合一起训练
        # --------------------------------------------#
        logits = Dense(num_classes)(model.output)
        softmax = Activation("softmax", name="Softmax")(logits)

        normalize = Lambda(lambda x: K.l2_normalize(x, axis=1), name="Embedding")(model.output)
        combine_model = Model(inputs, [softmax, normalize])
        return combine_model
    elif mode == "predict":
        # --------------------------------------------#
        #   预测的时候只需要考虑人脸的特征向量就行了
        # --------------------------------------------#
        x = Lambda(lambda x: K.l2_normalize(x, axis=1), name="Embedding")(model.output)
        model = Model(inputs, x)
        return model
    else:
        raise ValueError('Unsupported mode - `{}`, Use train, predict.'.format(mode))
