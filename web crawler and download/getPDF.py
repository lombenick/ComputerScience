from base64 import encode
import get_doc_path
import os
from bs4 import BeautifulSoup
from urllib import request
import string
from urllib.parse import quote



def get_pdf_by_url(folder_path, lists):
    href_list = []
    header = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36'}
    if not os.path.exists(folder_path):
        print("Selected folder not exist, try to create it.")
        os.makedirs(folder_path)
    for url in lists:
        print("Try downloading file: {}".format(url))
        filename = url.split('/')[-1].split('.')[0] + '.pdf'
        filepath = folder_path + '/' + filename
        if os.path.exists(filepath):
            print("File have already exist. skip")
        else:
            try:
                url = quote(url, safe=string.printable)
                add = request.Request(url=url,headers=header)
                response = request.urlopen(add)
                strs = response.read()
                html = strs.decode('utf-8')
                soup = BeautifulSoup(html, 'html.parser')
                for k in soup.find_all('a'):
                    try:
                        if (k['class'][0] == 'ad2'):
                            href_list.append(k['href'])
                            request.urlretrieve('https:' + k['href'], filepath)
                            break
                    except:
                        continue

            except Exception as e:
                print("Error occurred when downloading file, error message:")
                print(e)


if __name__ == "__main__":
    root_path = './raw_data'
    paths = get_doc_path.get_file(root_path)
    for filename, path in paths.items():
        with open(path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            url_list = []
            for line in lines:
                url_list.append('https://data.eastmoney.com/xg/xg/detail/' + line.strip() + '.html')
            foldername = "./downloads/{}".format(filename.split('.')[0])

            get_pdf_by_url(foldername, url_list)
