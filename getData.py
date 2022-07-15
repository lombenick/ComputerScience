import pdfplumber


def getPDFData(filePath: str) -> list:
    with pdfplumber.open(filePath) as pdf:
        index = 0
        for page in pdf.pages:
            index += 1
            text = page.extract_text()

            if '主要财务指标' in text:
                tables = page.extract_tables()
                if (len(tables) == 0):
                    continue
                
                for table in tables:
                    for line in table:
                        if '流动比率（倍）' in line:
                            return table