import os
import re
import sys
import Main
from UI import face_rec
from UI import face_ver
from UI import face_tra
from UI import gen_database
from UI import mainWindow
from PyQt5 import QtWidgets
from PyQt5 import QtGui
from PyQt5.QtGui import QIcon
from PyQt5.QtCore import QUrl, pyqtSignal, QThread
from PyQt5.QtWidgets import QApplication, QMainWindow, QDialog, QMessageBox
from PyQt5.QtMultimedia import QMediaPlayer, QMediaContent, QMediaPlaylist
from qt_material import apply_stylesheet
import ctypes
ctypes.windll.shell32.SetCurrentProcessExplicitAppUserModelID("myappid")


class parentWindow(QMainWindow):
    def __init__(self):
        QMainWindow.__init__(self)
        self.infoNum = 1

        # 创建主窗口
        self.main_ui = mainWindow.Ui_MainWindow()
        self.main_ui.setupUi(self)

        # 标记当前状态
        self.statusMsg = ''

        # 创建子窗口 和 子窗口控件
        self.myThread = MyThread(self.statusMsg, self)
        self.child_rec = childWindow_rec()
        self.child_ver = childWindow_ver()
        self.child_tra = childWindow_tra()
        self.child_genDb = childWindow_genDb()
        btn_face_rec = self.main_ui.actionFace_Recognition
        btn_face_rec.triggered.connect(lambda: self.child_rec.show())

        btn_face_ver = self.main_ui.actionFace_Verify
        btn_face_ver.triggered.connect(lambda: self.child_ver.show())

        btn_face_tra = self.main_ui.actionTrain_Model
        btn_face_tra.triggered.connect(lambda: self.child_tra.show())

        btn_genDb = self.main_ui.actionGenerate_db
        btn_genDb.triggered.connect(lambda: self.child_genDb.show())

        # set icon
        self.setWindowIcon(QIcon('UI/icon/eye.png'))

        # play video
        self.playerList = QMediaPlaylist()
        self.playerList.addMedia(QMediaContent(QUrl('UI/Movie/video.mp4')))
        self.playerList.setCurrentIndex(1)
        self.playerList.setPlaybackMode(QMediaPlaylist.CurrentItemInLoop)
        self.player = QMediaPlayer()
        self.player.setPlaylist(self.playerList)
        self.player.setVideoOutput(self.main_ui.widget_player)
        self.player.play()

        self.child_rec.statusInfo.connect(self.status_printer)
        self.child_ver.statusInfo.connect(self.status_printer)
        self.child_tra.statusInfo.connect(self.status_printer)
        self.child_genDb.statusInfo.connect(self.status_printer)

        self.main_ui.btn_Reset.clicked.connect(self.clear_status_info)
        self.main_ui.btn_Run.clicked.connect(self.run_program)
        self.main_ui.btn_Stop.clicked.connect(self.stop_program)

    def output_printer(self, msg):
        self.main_ui.textBro_outputInfo.append(msg)
        cursor = self.main_ui.textBro_outputInfo.textCursor()
        self.main_ui.textBro_outputInfo.moveCursor(cursor.End)
        QtWidgets.QApplication.processEvents()

    def status_printer(self, msg):
        self.statusMsg = msg
        for _msg in msg.split('\n'):
            _msg = 'info {}  {}'.format(self.infoNum, _msg)
            self.infoNum += 1
            self.main_ui.textBro_statusInfo.append(_msg)
            cursor = self.main_ui.textBro_statusInfo.textCursor()
            self.main_ui.textBro_statusInfo.moveCursor(cursor.End)

    def clear_status_info(self):
        self.infoNum = 1
        self.statusMsg = ''
        self.main_ui.textBro_statusInfo.clear()
        self.main_ui.textBro_outputInfo.clear()

    def run_program(self):
        self.myThread = MyThread(self.statusMsg, self)
        self.myThread.start()

    def stop_program(self):
        self.output_printer('\nStopping program...')
        try:
            # self.myThread.terminate()
            self.myThread.quit()
            self.myThread.wait()
            self.output_printer('The tsk has stopped!')
        except InterruptedError:
            self.output_printer('Sorry,you cannot stop this program!')

    def closeEvent(self, event):
        sys.exit(app.exec_())


class childWindow_rec(QDialog):
    statusInfo = pyqtSignal(str)  # 创建槽信号,str指定接收参数为str类型(字符串类型)

    def __init__(self):
        QDialog.__init__(self)
        self.child = face_rec.Ui_QDialog()
        self.child.setupUi(self)

        self.modelName = 'model:{}'.format(self.child.combox_model_select.currentText())
        self.picPath = ''
        self.modelPath = ''
        self.databasePath = ''

        self.child.btn_pic_select.clicked.connect(self.getPicPath)
        self.child.btn_model_select.clicked.connect(self.getModelPath)
        self.child.btn_database_select.clicked.connect(self.getDatabasePath)
        self.child.combox_model_select.currentIndexChanged.connect(self.getModelName)

        self.child.btnOK.accepted.connect(self.emitStatusInfo)

    def getModelName(self):
        self.modelName = 'model:{}'.format(self.child.combox_model_select.currentText())

    def getPicPath(self):
        path = QtWidgets.QFileDialog.getOpenFileName(self, "select image", "./", "Image (*.jpg)")
        if path[0] == '':
            return
        else:
            QMessageBox.information(self, 'success', 'you have selected the image!')
            img = QtGui.QPixmap(path[0]).scaled(self.child.image_show_label.width(), self.child.image_show_label.height())
            self.child.image_show_label.setPixmap(img)
            self.picPath = 'image path:{}'.format(path[0])

    def getModelPath(self):
        path = QtWidgets.QFileDialog.getOpenFileName(self, "select model weights", "./", "Model (*.h5)")
        if path[0] == '':
            return
        else:
            QMessageBox.information(self, 'success', 'you have selected the model weights!')
            self.modelPath = 'model weights path:{}'.format(path[0])

    def getDatabasePath(self):
        path = QtWidgets.QFileDialog.getOpenFileName(self, "select database", "./", "Database (*.npy)")
        if path[0] == '':
            return
        else:
            QMessageBox.information(self, 'success', 'you have selected the database!')
            self.databasePath = 'database path:{}'.format(path[0])

    def emitStatusInfo(self):
        if self.picPath == '' or self.modelPath == '' or self.databasePath == '' or self.modelName == '':
            QMessageBox.critical(self, 'Error', 'Please Complete the information!')
        else:
            self.statusInfo.emit('{}\n{}\n{}\n{}\n{}'.format('function: face recognition', self.modelName, self.picPath,
                                                             self.modelPath, self.databasePath))


class childWindow_ver(QDialog):
    statusInfo = pyqtSignal(str)

    def __init__(self):
        QDialog.__init__(self)
        self.child = face_ver.Ui_Dialog()
        self.child.setupUi(self)

        self.modelName = 'model:{}'.format(self.child.cmboxModelSel.currentText())
        self.modelWeightsPath = ''
        self.pic1Path = ''
        self.pic2Path = ''

        self.child.btnSelectModel.clicked.connect(self.getModelWeightsPath)
        self.child.cmboxModelSel.currentIndexChanged.connect(self.getModelName)
        self.child.btnSelectPic1.clicked.connect(self.getPic1Path)
        self.child.btnSelectPic2.clicked.connect(self.getPic2Path)
        self.child.btnOK.accepted.connect(self.emitStatusInfo)

    def getModelName(self):
        self.modelName = 'model:{}'.format(self.child.cmboxModelSel.currentText())

    def getPic1Path(self):
        path = QtWidgets.QFileDialog.getOpenFileName(self, "select image", "./", "Image (*.jpg)")
        if path[0] == '':
            return
        else:
            QMessageBox.information(self, 'success', 'you have selected the image!')
            img = QtGui.QPixmap(path[0]).scaled(self.child.imageOne_label.width(), self.child.imageOne_label.height())
            self.child.imageOne_label.setPixmap(img)
            self.pic1Path = 'image1 path:{}'.format(path[0])

    def getPic2Path(self):
        path = QtWidgets.QFileDialog.getOpenFileName(self, "select image", "./", "Image (*.jpg)")
        if path[0] == '':
            return
        else:
            QMessageBox.information(self, 'success', 'you have selected the image!')
            img = QtGui.QPixmap(path[0]).scaled(self.child.imageTwo_label.width(), self.child.imageTwo_label.height())
            self.child.imageTwo_label.setPixmap(img)
            self.pic2Path = 'image2 path:{}'.format(path[0])

    def getModelWeightsPath(self):
        path = QtWidgets.QFileDialog.getOpenFileName(self, "select model weights", "./", "Model (*.h5)")
        if path[0] == '':
            return
        else:
            QMessageBox.information(self, 'success', 'you have selected the model weights!')
            self.modelWeightsPath = 'model weights path:{}'.format(path[0])

    def emitStatusInfo(self):
        if self.modelName == '' or self.pic1Path == '' or self.pic2Path == '' or self.modelWeightsPath == '':
            QMessageBox.critical(self, 'Error', 'Please Complete the information!')
        else:
            self.statusInfo.emit('{}\n{}\n{}\n{}\n{}'.format('function: face verify', self.modelName,
                                                             self.modelWeightsPath, self.pic1Path, self.pic2Path))


class childWindow_tra(QDialog):
    statusInfo = pyqtSignal(str)

    def __init__(self):
        QDialog.__init__(self)
        self.child = face_tra.Ui_Dialog()
        self.child.setupUi(self)

        self.modelSel = 'model:{}'.format(self.child.cmboxModelSelect.currentText())
        self.modelWeights = ''
        self.datasetPath = ''
        self.logPath = 'log path:{}'.format(os.path.join(os.getcwd(), 'logs').replace('\\', '/'))
        self.numWorker = 'num worker value:{}'.format(self.child.spboxNumWorker.value())
        self.learningRate = 'learning rate value:{}'.format(self.child.doublespboxLR.value())
        self.batchSize = 'batch size value:{}'.format(self.child.spboxBS.value())
        self.freezeFlag = 'freeze flag:{}'.format('False')

        self.child.cmboxModelSelect.currentIndexChanged.connect(self.getModelSel)
        self.child.btnSelectWeights.clicked.connect(self.getModelWeights)
        self.child.btnDatasetSelect.clicked.connect(self.getDatasetPath)
        self.child.btnLogSelect.clicked.connect(self.getLogPath)
        self.child.spboxNumWorker.valueChanged.connect(self.getNumWorker)
        self.child.doublespboxLR.valueChanged.connect(self.getLearningRate)
        self.child.spboxBS.valueChanged.connect(self.getBatchSize)
        self.child.rtnFreeze.clicked.connect(self.getFreezeFlag)
        self.child.btnOK.accepted.connect(self.emitStatusInfo)

    def getModelSel(self):
        self.modelSel = 'model:{}'.format(self.child.cmboxModelSelect.currentText())

    def getModelWeights(self):
        path = QtWidgets.QFileDialog.getOpenFileName(self, "select backbone model weights", "./", "Weights(*.h5)")
        if path[0] == '':
            return
        else:
            QMessageBox.information(self, 'success', 'you have selected the weights!')
            self.modelWeights = 'model weights path:{}'.format(path[0])

    def getDatasetPath(self):
        path = QtWidgets.QFileDialog.getExistingDirectory(self, "select dataset folder", "./")
        if path == '':
            return
        else:
            QMessageBox.information(self, 'success', 'you have selected the dataset!')
            self.datasetPath = 'dataset path:{}'.format(path)

    def getLogPath(self):
        path = QtWidgets.QFileDialog.getExistingDirectory(self, "select log folder", "./")
        if path == '':
            return
        else:
            QMessageBox.information(self, 'success', 'you have selected the log folder!')
            self.logPath = 'log path:{}'.format(path)

    def getNumWorker(self):
        self.numWorker = 'num worker value:{}'.format(self.child.spboxNumWorker.value())

    def getLearningRate(self):
        self.learningRate = 'learning rate value:{}'.format(self.child.doublespboxLR.value())

    def getBatchSize(self):
        self.batchSize = 'batch size value:{}'.format(self.child.spboxBS.value())

    def getFreezeFlag(self):
        if self.child.rtnFreeze.isChecked():
            self.freezeFlag = 'freeze flag:{}'.format('True')
        else:
            self.freezeFlag = 'freeze flag:{}'.format('False')

    def emitStatusInfo(self):
        if self.modelSel == '' or self.datasetPath == '' or self.logPath == '' or self.numWorker == '' or \
           self.learningRate == '' or self.batchSize == '' or self.freezeFlag == '':
            QMessageBox.critical(self, 'Error', 'Please Complete the information!')
        else:
            self.statusInfo.emit('{}\n{}\n{}\n{}\n{}\n{}\n{}\n{}\n{}'.format('function: face train', self.modelSel,
                                                                             self.modelWeights, self.datasetPath,
                                                                             self.logPath, self.numWorker,
                                                                             self.learningRate, self.batchSize,
                                                                             self.freezeFlag))


class childWindow_genDb(QDialog):
    statusInfo = pyqtSignal(str)

    def __init__(self):
        QDialog.__init__(self)
        self.child = gen_database.Ui_Dialog()
        self.child.setupUi(self)

        self.modelSel = 'model:{}'.format(self.child.cmbox_selMol.currentText())
        self.modelWeightsPath = ''
        self.sourcePath = ''
        self.databasePath = ''

        self.child.cmbox_selMol.currentIndexChanged.connect(self.getModelName)
        self.child.btn_selectMolW.clicked.connect(self.getModelWeight)
        self.child.btn_sourceParh.clicked.connect(self.getSourcePath)
        self.child.btn_generateDb.clicked.connect(self.getDatabasePath)
        self.child.btnOK.accepted.connect(self.emitStatusInfo)

    def getModelName(self):
        self.modelSel = 'model:{}'.format(self.child.cmbox_selMol.currentText())

    def getModelWeight(self):
        path = QtWidgets.QFileDialog.getOpenFileName(self, "select model weights path", "./", "Model Weights(*.h5)")
        if path[0] == '':
            return
        else:
            QMessageBox.information(self, 'success', 'you have selected the model weights path!')
            self.modelWeightsPath = 'model weights path:{}'.format(path[0])

    def getSourcePath(self):
        path = QtWidgets.QFileDialog.getExistingDirectory(self, "select source path", "./")
        if path == '':
            return
        else:
            QMessageBox.information(self, 'success', 'you have selected the raw data path!')
            self.sourcePath = 'raw data path:{}'.format(path)

    def getDatabasePath(self):
        path = QtWidgets.QFileDialog.getExistingDirectory(self, "select database", "./")
        if path == '':
            return
        else:
            QMessageBox.information(self, 'success', 'you have selected the database path!')
            self.databasePath = 'database path:{}'.format(path)

    def emitStatusInfo(self):
        if self.sourcePath == '' or self.databasePath == '' or self.modelSel == '' or self.modelWeightsPath == '':
            QMessageBox.critical(self, 'Error', 'Please Complete the information!')
        else:
            self.statusInfo.emit('{}\n{}\n{}\n{}\n{}'.format('function: generate database', self.modelSel,
                                                             self.modelWeightsPath, self.sourcePath, self.databasePath))


class MyThread(QThread):
    def __init__(self, statusMsg, _window):
        super(MyThread, self).__init__()
        self.statusMsg = statusMsg
        self.window = _window

    def run(self) -> None:
            self.run_program() # 启动线程

    def run_program(self):
        if self.statusMsg == '':
            return
        model_option = re.findall(r'model:(.+)\n', self.statusMsg)[0]

        if 'recognition' in self.statusMsg:
            model_weights_path = re.findall(r'model weights path:(.+)\n', self.statusMsg)[0]
            pic_path = re.findall(r'image path:(.+)\n', self.statusMsg)[0]
            database_path = re.findall(r'database path:(.+)', self.statusMsg)[0]
            try:
                Main.main(self.window, model_weights_path, database_path, pic_path, model_option=model_option,
                          func='predict')
            except InterruptedError:
                parentWindow.output_printer(self.window, 'Sorry, something go wrong!')

        elif 'verify' in self.statusMsg:
            model_weights_path = re.findall(r'model weights path:(.+)\n', self.statusMsg)[0]
            pic_path1 = re.findall(r'image1 path:(.+)\n', self.statusMsg)[0]
            pic_path2 = re.findall(r'image2 path:(.+)', self.statusMsg)[0]
            Main.main(self.window, model_weights_path, pic_path1, pic_path2, model_option=model_option, func='verify')

        elif 'train' in self.statusMsg:
            model_weights = re.findall(r'model weights path:(.+)\n', self.statusMsg)
            model_weights = model_weights[0] if model_weights else ''
            dataset_path = re.findall(r'dataset path:(.+)\n', self.statusMsg)[0]
            log_path = re.findall(r'log path:(.+)\n', self.statusMsg)[0]
            num_worker = re.findall(r'num worker value:(.+)\n', self.statusMsg)[0]
            learning_rate = re.findall(r'learning rate value:(.+)\n', self.statusMsg)[0]
            batch_size = re.findall(r'batch size value:(.+)\n', self.statusMsg)[0]
            freeze_flag = True if re.findall(r'freeze flag:(.+)', self.statusMsg)[0] == 'True' else False
            Main.main(self.window, model_option, model_weights, dataset_path, log_path, int(num_worker),
                      float(learning_rate), int(batch_size), bool(freeze_flag), model_option=model_option, func='train')

        else:
            model_weights_path = re.findall(r'model weights path:(.+)\n', self.statusMsg)[0]
            source_path = re.findall(r'raw data path:(.+)\n', self.statusMsg)[0]
            database_path = re.findall(r'database path:(.+)', self.statusMsg)[0]
            try:
                Main.main(self.window, model_weights_path, source_path, database_path, model_option=model_option,
                          func='generate database')
            except InterruptedError:
                parentWindow.output_printer(self.window, 'Sorry, something go wrong!')


if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = parentWindow()
    window.setWindowTitle('OpenAix Viewer')
    apply_stylesheet(app, theme='dark_amber.xml')

    window.show()
    sys.exit(app.exec_())
