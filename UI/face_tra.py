# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'face_tra.ui'
#
# Created by: PyQt5 UI code generator 5.15.4
#
# WARNING: Any manual changes made to this file will be lost when pyuic5 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt5 import QtCore, QtWidgets
from PyQt5.QtGui import QIcon
import os


class Ui_Dialog(object):
    def setupUi(self, Dialog):
        Dialog.setObjectName("Dialog")
        Dialog.resize(634, 532)
        self.btnOK = QtWidgets.QDialogButtonBox(Dialog)
        self.btnOK.setGeometry(QtCore.QRect(490, 240, 111, 81))
        self.btnOK.setOrientation(QtCore.Qt.Vertical)
        self.btnOK.setStandardButtons(QtWidgets.QDialogButtonBox.Cancel|QtWidgets.QDialogButtonBox.Ok)
        self.btnOK.setObjectName("btnOK")
        self.groupBox = QtWidgets.QGroupBox(Dialog)
        self.groupBox.setGeometry(QtCore.QRect(50, 40, 421, 451))
        self.groupBox.setObjectName("groupBox")
        self.cmboxModelSelect = QtWidgets.QComboBox(self.groupBox)
        self.cmboxModelSelect.setGeometry(QtCore.QRect(160, 80, 111, 21))
        self.cmboxModelSelect.setObjectName("cmboxModelSelect")
        self.cmboxModelSelect.addItem("")
        self.cmboxModelSelect.addItem("")
        self.cmboxModelSelect.addItem("")
        self.cmboxModelSelect.addItem("")
        self.label = QtWidgets.QLabel(self.groupBox)
        self.label.setGeometry(QtCore.QRect(30, 80, 131, 21))
        self.label.setObjectName("label")
        self.btnDatasetSelect = QtWidgets.QPushButton(self.groupBox)
        self.btnDatasetSelect.setGeometry(QtCore.QRect(160, 170, 101, 28))
        self.btnDatasetSelect.setObjectName("btnDatasetSelect")
        self.label_2 = QtWidgets.QLabel(self.groupBox)
        self.label_2.setGeometry(QtCore.QRect(30, 170, 128, 26))
        self.label_2.setObjectName("label_2")
        self.btnLogSelect = QtWidgets.QPushButton(self.groupBox)
        self.btnLogSelect.setGeometry(QtCore.QRect(160, 220, 101, 28))
        self.btnLogSelect.setObjectName("btnLogSelect")
        self.label_3 = QtWidgets.QLabel(self.groupBox)
        self.label_3.setGeometry(QtCore.QRect(30, 220, 131, 26))
        self.label_3.setObjectName("label_3")
        self.spboxNumWorker = QtWidgets.QSpinBox(self.groupBox)
        self.spboxNumWorker.setGeometry(QtCore.QRect(160, 270, 101, 24))
        self.spboxNumWorker.setValue(1)
        self.spboxNumWorker.setObjectName("spboxNumWorker")
        self.label_4 = QtWidgets.QLabel(self.groupBox)
        self.label_4.setGeometry(QtCore.QRect(30, 270, 121, 24))
        self.label_4.setObjectName("label_4")
        self.doublespboxLR = QtWidgets.QDoubleSpinBox(self.groupBox)
        self.doublespboxLR.setGeometry(QtCore.QRect(160, 310, 101, 24))
        self.doublespboxLR.setDecimals(6)
        self.doublespboxLR.setValue(0.001000)
        self.doublespboxLR.setObjectName("doublespboxLR")
        self.label_5 = QtWidgets.QLabel(self.groupBox)
        self.label_5.setGeometry(QtCore.QRect(30, 310, 121, 24))
        self.label_5.setObjectName("label_5")
        self.label_6 = QtWidgets.QLabel(self.groupBox)
        self.label_6.setGeometry(QtCore.QRect(30, 350, 101, 24))
        self.label_6.setObjectName("label_6")
        self.spboxBS = QtWidgets.QSpinBox(self.groupBox)
        self.spboxBS.setGeometry(QtCore.QRect(160, 350, 101, 24))
        self.spboxBS.setValue(32)
        self.spboxBS.setObjectName("spboxBS")
        self.rtnFreeze = QtWidgets.QRadioButton(self.groupBox)
        self.rtnFreeze.setGeometry(QtCore.QRect(180, 400, 71, 16))
        self.rtnFreeze.setText("")
        self.rtnFreeze.setObjectName("rtnFreeze")
        self.label_7 = QtWidgets.QLabel(self.groupBox)
        self.label_7.setGeometry(QtCore.QRect(30, 400, 131, 16))
        self.label_7.setObjectName("label_7")
        self.label_8 = QtWidgets.QLabel(self.groupBox)
        self.label_8.setGeometry(QtCore.QRect(20, 120, 161, 31))
        self.label_8.setObjectName("label_8")
        self.btnSelectWeights = QtWidgets.QPushButton(self.groupBox)
        self.btnSelectWeights.setGeometry(QtCore.QRect(180, 120, 101, 31))
        self.btnSelectWeights.setObjectName("btnSelectWeights")

        self.retranslateUi(Dialog)
        self.btnOK.accepted.connect(Dialog.accept)
        self.btnOK.rejected.connect(Dialog.reject)
        QtCore.QMetaObject.connectSlotsByName(Dialog)

    def retranslateUi(self, Dialog):
        _translate = QtCore.QCoreApplication.translate
        Dialog.setWindowTitle(_translate("Dialog", "Face Training"))
        Dialog.setWindowIcon(QIcon('UI/icon/train.png'))
        self.groupBox.setTitle(_translate("Dialog", "select your parameter"))
        self.cmboxModelSelect.setItemText(0, _translate("Dialog", "VGG"))
        self.cmboxModelSelect.setItemText(1, _translate("Dialog", "Mobilenet"))
        self.cmboxModelSelect.setItemText(2, _translate("Dialog", "Inception V2"))
        self.cmboxModelSelect.setItemText(3, _translate("Dialog", "Resnet"))
        self.label.setText(_translate("Dialog", "Model backbone:"))
        self.btnDatasetSelect.setText(_translate("Dialog", "select..."))
        self.label_2.setText(_translate("Dialog", "Dataset path:"))
        self.btnLogSelect.setText(_translate("Dialog", "select..."))
        self.label_3.setText(_translate("Dialog", "Log directory:"))
        self.label_4.setText(_translate("Dialog", "Number worker:"))
        self.label_5.setText(_translate("Dialog", "Learning rate:"))
        self.label_6.setText(_translate("Dialog", "Batch size:"))
        self.label_7.setText(_translate("Dialog", "Is need Freeze:"))
        self.label_8.setText(_translate("Dialog", "Model weights path:"))
        self.btnSelectWeights.setText(_translate("Dialog", "select..."))