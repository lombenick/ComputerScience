# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'face_rec.ui'
#
# Created by: PyQt5 UI code generator 5.15.4
#
# WARNING: Any manual changes made to this file will be lost when pyuic5 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtGui import QIcon


class Ui_QDialog(object):
    def setupUi(self, QDialog):
        QDialog.setObjectName("QDialog")
        QDialog.resize(753, 359)
        self.btnOK = QtWidgets.QDialogButtonBox(QDialog)
        self.btnOK.setGeometry(QtCore.QRect(100, 310, 321, 32))
        self.btnOK.setOrientation(QtCore.Qt.Horizontal)
        self.btnOK.setStandardButtons(QtWidgets.QDialogButtonBox.Cancel|QtWidgets.QDialogButtonBox.Ok)
        self.btnOK.setObjectName("btnOK")
        self.groupBox = QtWidgets.QGroupBox(QDialog)
        self.groupBox.setGeometry(QtCore.QRect(30, 30, 401, 271))
        self.groupBox.setObjectName("groupBox")
        self.btn_database_select = QtWidgets.QPushButton(self.groupBox)
        self.btn_database_select.setGeometry(QtCore.QRect(200, 210, 121, 28))
        self.btn_database_select.setObjectName("btn_database_select")
        self.label_3 = QtWidgets.QLabel(self.groupBox)
        self.label_3.setGeometry(QtCore.QRect(40, 160, 101, 26))
        self.label_3.setObjectName("label_3")
        self.btn_pic_select = QtWidgets.QPushButton(self.groupBox)
        self.btn_pic_select.setGeometry(QtCore.QRect(200, 160, 121, 28))
        self.btn_pic_select.setObjectName("btn_pic_select")
        self.btn_model_select = QtWidgets.QPushButton(self.groupBox)
        self.btn_model_select.setGeometry(QtCore.QRect(200, 110, 121, 28))
        self.btn_model_select.setObjectName("btn_model_select")
        self.label_2 = QtWidgets.QLabel(self.groupBox)
        self.label_2.setGeometry(QtCore.QRect(30, 210, 141, 26))
        self.label_2.setObjectName("label_2")
        self.label = QtWidgets.QLabel(self.groupBox)
        self.label.setGeometry(QtCore.QRect(20, 110, 151, 26))
        self.label.setObjectName("label")
        self.label_4 = QtWidgets.QLabel(self.groupBox)
        self.label_4.setGeometry(QtCore.QRect(30, 60, 121, 26))
        self.label_4.setObjectName("label_4")
        self.combox_model_select = QtWidgets.QComboBox(self.groupBox)
        self.combox_model_select.setGeometry(QtCore.QRect(200, 60, 121, 22))
        self.combox_model_select.setObjectName("combox_model_select")
        self.combox_model_select.addItem("")
        self.combox_model_select.addItem("")
        self.combox_model_select.addItem("")
        self.combox_model_select.addItem("")
        self.groupBox_2 = QtWidgets.QGroupBox(QDialog)
        self.groupBox_2.setGeometry(QtCore.QRect(470, 50, 221, 241))
        self.groupBox_2.setObjectName("groupBox_2")
        self.image_show_label = QtWidgets.QLabel(self.groupBox_2)
        self.image_show_label.setGeometry(QtCore.QRect(10, 50, 201, 181))
        font = QtGui.QFont()
        font.setPointSize(12)
        font.setBold(False)
        font.setItalic(False)
        font.setWeight(50)
        font.setStrikeOut(False)
        self.image_show_label.setFont(font)
        self.image_show_label.setAlignment(QtCore.Qt.AlignCenter)
        self.image_show_label.setObjectName("image_show_label")

        self.retranslateUi(QDialog)
        self.btnOK.accepted.connect(QDialog.accept)
        self.btnOK.rejected.connect(QDialog.reject)
        QtCore.QMetaObject.connectSlotsByName(QDialog)

    def retranslateUi(self, QDialog):
        _translate = QtCore.QCoreApplication.translate
        QDialog.setWindowIcon(QIcon('UI/icon/faceRec.png'))
        QDialog.setWindowTitle(_translate("QDialog", "Face Recognition"))
        self.groupBox.setTitle(_translate("QDialog", "select your parameter"))
        self.btn_database_select.setText(_translate("QDialog", "select..."))
        self.label_3.setText(_translate("QDialog", "Image path:"))
        self.btn_pic_select.setText(_translate("QDialog", "select..."))
        self.btn_model_select.setText(_translate("QDialog", "select..."))
        self.label_2.setText(_translate("QDialog", "Database path:"))
        self.label.setText(_translate("QDialog", "Model weight path:"))
        self.label_4.setText(_translate("QDialog", "Model backbone:"))
        self.combox_model_select.setItemText(0, _translate("QDialog", "VGG"))
        self.combox_model_select.setItemText(1, _translate("QDialog", "Inception V2"))
        self.combox_model_select.setItemText(2, _translate("QDialog", "Resnet"))
        self.combox_model_select.setItemText(3, _translate("QDialog", "Mobilenet"))
        self.groupBox_2.setTitle(_translate("QDialog", "image selected"))
        self.image_show_label.setText(_translate("QDialog", "Select Image"))
