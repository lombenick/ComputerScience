import mainWindow
import getData
from PyQt5.QtCore import QThread
from PyQt5.QtCore import pyqtSignal
from PyQt5 import QtWidgets
from PyQt5.QtWidgets import QMessageBox
from PyQt5.QtWidgets import QApplication, QMainWindow
import sys
import re


# 创建一个子线程
class UpdateThread(QThread):
    updateData = pyqtSignal(bool)
    def __init__(self, filePaths):
        QThread.__init__(self)
        self.filePaths = filePaths
    
    def run(self):
        with open('../结果都放这里啦.csv', 'w') as f:
            f.write(',,' + '流动比率（倍）' + ',速动比率（倍）\n')
            for filePath in self.filePaths:
                fileName = re.findall(r'\d+', filePath)[0]
                table = getData.getPDFData(filePath)
                if not table or len(table) == 0:
                    continue
                
                year, flow, speed = [], [], []
                for row in table:
                    if '主要财务指标' in row:
                        year.extend(row[1:])
                    if '流动比率（倍）' in row:
                        flow.extend(row[1:])
                    if '速动比率（倍）' in row:
                        speed.extend(row[1:])
                        
                for index in range(len(flow)):
                    f.write('{},{},{},{}\n'.format(fileName, year[index], flow[index], speed[index]))

        self.updateData.emit(True)

class parentWindow(QMainWindow):
    def __init__(self):
        QMainWindow.__init__(self)

        self.filePaths = []
        self.main_ui = mainWindow.Ui_MainWindow()
        self.main_ui.setupUi(self)
        self.main_ui.pushButton.clicked.connect(self.getFilePaths)
        self.main_ui.pushButton_2.clicked.connect(self.getData)
        self.main_ui.progressBar.setVisible(False)

    def getFilePaths(self):
        filePaths = QtWidgets.QFileDialog.getOpenFileNames(None, "选取多个文件", "../","PDF Files (*.pdf)")
        self.filePaths = filePaths[0]
        if len(filePaths[0]) != 0:
            QMessageBox.information(self,'提示','好啦好啦，收到要处理的PDF啦！')

    
    def getData(self):
        if len(self.filePaths) == 0:
            QMessageBox.warning(self,'警告','还没选择文件呢！小笨蛋！')
            return
        
        QMessageBox.information(self,'提示','我在计算啦，等下哈！')
        self.main_ui.progressBar.setVisible(True)
        self.main_ui.progressBar.setRange(0, 0)

        self.subThread = UpdateThread(filePaths=self.filePaths)
        self.subThread.updateData.connect(self.finished)
        self.subThread.start()
    
    def finished(self):
        QMessageBox.information(self,'提示','我弄完了呀！结果都放csv文件里面啦！')
        self.main_ui.progressBar.setVisible(False)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = parentWindow()
    window.setWindowTitle('提取PDF信息')

    window.show()
    sys.exit(app.exec_())
