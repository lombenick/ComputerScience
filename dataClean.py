from operator import index
import pandas as pd


if __name__ == '__main__':
    data = pd.read_csv('./结果都放这里啦.csv', converters={'PDF name':str}, encoding='ANSI')
    time = data['Time']
    indexs = []
    for i in range(len(time)):
        if '年' not in time[i]:
            indexs.append(i)
    
    for idx in indexs:
        data['Time'][idx] = '-'
        data['R&D expenses'][idx] = '-'

    # data['PDF name'].apply(lambda x : '{:0>6d}'.format(x))
    # print(data['PDF name'])
    data.to_csv('./result.csv', encoding='ANSI', index=False)
