import platform
import pdfplumber
import re
import os
import pandas


def getPDFData(filePath: str) -> list:
    years, fee, flag = [], [], False
    with pdfplumber.open(filePath) as pdf:
        index = 0
        for page in pdf.pages:
            index += 1
            text = page.extract_text()
            print(index)
            try:
                text2 = pdf.pages[index].extract_text()
            except:
                return [], []

            if '合并利润表' in text and ('研发费用' in text or '研发费用' in text2):
                # print(text + text2)
                for line in (text + text2).split('\n'):
                    if '项目' in line or '年' in line:
                        years.clear()
                        years.extend(line.split(' '))
                    if '研发费用' in line:
                        fee.extend(line.split(' '))
                        flag = True
                        break
            if flag:
                break
        years_res, fee_res = [], []
        for year in years:
            year_tmp = ''
            if re.search(r'\d', year):
                for ch in year:
                    if ch != ' ':
                        year_tmp += ch
                years_res.append(year_tmp)
        for fe in fee:
            fee_tmp = ''
            if re.search(r'\d', fe):
                for ch in fe:
                    if ch.isdigit() or ch == '.':
                        fee_tmp += ch
                fee_res.append(fee_tmp)
        return years_res, fee_res

if __name__ == '__main__':
    # filePaths = []
    filePaths = ['D:/中文/downloads/IPO_company/688517.pdf']
    # for file in os.listdir('./IPO_company/'):
    #     path = os.path.join(os.getcwd() + '/IPO_company/', file)
    #     if platform.system().lower() == 'windows':
    #         path = path.replace('\\', '/')
    #     filePaths.append(path)

    fileNameForWriting = './结果都放这里啦.csv'
    existsPDFIndex = {}
    if not os.path.exists(fileNameForWriting):
        with open(fileNameForWriting, 'w') as f:
            f.write('PDF name,Time,' + 'R&D expenses\n')
    else:
        tmp = list(set(pandas.read_csv('./结果都放这里啦.csv', encoding='GB18030', converters={'PDF name':str})[['PDF name']].stack().tolist()))
        for t in tmp:
            x = ''
            for ch in t:
                if ch.isdigit():
                    x += ch
            existsPDFIndex[x] = True

    for filePath in filePaths:
        fileName = re.findall(r'\d+', filePath)[0]
        print(fileName)
        if existsPDFIndex.get(fileName, False):
            continue
        year, flow = getPDFData(filePath)
        print(year)
        print(flow)
        fileName = fileName.rjust(6, '0')
        if flow == [] or len(flow) != len(year):
            with open(fileNameForWriting, 'a+') as f:
                for index in range(3):
                    f.write('{},{},{}\n'.format('\t' + fileName, ' ', ' '))
            continue

        with open(fileNameForWriting, 'a+') as f:
            for index in range(len(flow)):
                f.write('{},{},{}\n'.format('\t' + fileName, year[index], flow[index]))
