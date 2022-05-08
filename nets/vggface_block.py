from keras import *
from keras import backend as k
from keras.layers import Conv2D, ZeroPadding2D, Activation, Input, Dropout
from keras.models import Model
from keras.layers.pooling import MaxPooling2D
from keras.layers.core import Lambda, Flatten
import numpy as np
from keras.preprocessing import image
from utils import imagenet_utils


def VGGModel(input_shape):
    """
    Implementation of the vggface model used for FaceNet

    Arguments:
    input_shape -- shape of the images of the dataset

    Returns:
    model -- a Model() instance in Keras
    """
    # input层
    # X_input = Input(input_shape)

    # Block 1
    X = ZeroPadding2D((1, 1))(input_shape)
    X = Conv2D(64, (3, 3), name='block1_conv1')(X)
    X = ZeroPadding2D((1, 1))(X)
    X = Conv2D(64, (3, 3), activation='relu', name='block1_conv2')(X)
    X = MaxPooling2D((2, 2), strides=(2, 2), name='block1_pool')(X)

    # Block 2
    X = ZeroPadding2D((1, 1))(X)
    X = Conv2D(128, (3, 3), activation='relu', name='block2_conv1')(X)
    X = ZeroPadding2D((1, 1))(X)
    X = Conv2D(128, (3, 3), activation='relu', name='block2_conv2')(X)
    X = MaxPooling2D((2, 2), strides=(2, 2), name='block2_pool')(X)

    # Block 3
    X = ZeroPadding2D((1, 1))(X)
    X = Conv2D(256, (3, 3), activation='relu', name='block3_conv1')(X)
    X = ZeroPadding2D((1, 1))(X)
    X = Conv2D(256, (3, 3), activation='relu', name='block3_conv2')(X)
    X = ZeroPadding2D((1, 1))(X)
    X = Conv2D(256, (3, 3), activation='relu', name='block3_conv3')(X)
    X = MaxPooling2D((2, 2), strides=(2, 2), name='block3_pool')(X)

    # Block 4
    X = ZeroPadding2D((1, 1))(X)
    X = Conv2D(512, (3, 3), activation='relu', name='block4_conv1')(X)
    X = ZeroPadding2D((1, 1))(X)
    X = Conv2D(512, (3, 3), activation='relu', name='block4_conv2')(X)
    X = ZeroPadding2D((1, 1))(X)
    X = Conv2D(512, (3, 3), activation='relu', name='block4_conv3')(X)
    X = MaxPooling2D((2, 2), strides=(2, 2), name='block4_pool')(X)

    # Block 5
    X = ZeroPadding2D((1, 1))(X)
    X = Conv2D(512, (3, 3), activation='relu', name='block5_conv1')(X)
    X = ZeroPadding2D((1, 1))(X)
    X = Conv2D(512, (3, 3), activation='relu', name='block5_conv2')(X)
    X = ZeroPadding2D((1, 1))(X)
    X = Conv2D(512, (3, 3), activation='relu', name='block5_conv3')(X)
    X = MaxPooling2D((2, 2), strides=(2, 2), name='block5_pool')(X)

    # Block 6
    X = Conv2D(4096, (7, 7), activation='relu', name='block6_conv1')(X)
    X = Dropout(0.5, name='block6_dropout1')(X)
    X = Conv2D(4096, (1, 1), activation='relu', name='block6_conv2')(X)
    X = Dropout(0.5, name='block6_dropout2')(X)
    X = Conv2D(2622, (1, 1), name='block6_conv3')(X)
    X = Flatten(name='block6_flatten')(X)

    # L2 normalization
    # X = Lambda(lambda x: k.l2_normalize(x, axis=1))(X)

    # Create model instance
    model = Model(inputs=input_shape, outputs=X, name='FaceRecoModel')
    return model


def preprocess_image(image_path, target_size=(224, 224)):
    img = image.load_img(image_path, target_size=target_size)
    img = image.img_to_array(img)
    img = np.expand_dims(img, axis=0)
    img = imagenet_utils.preprocess_input(img)
    return img
