def get_img_pairs_list(pairs_txt_path):
    """ 指定图片组合及其所在文件，返回各图片对的绝对路径
        Args:
            pairs_txt_path：图片pairs文件，里面是6000对图片名字的组合
        return:
            img_pairs_list：深度为2的list，每一个二级list存放的是一对图片的绝对路径
    """
    file = open(pairs_txt_path)
    img_pairs_list, labels = [], []
    while True:
        img_pairs = []
        line = file.readline().replace('\n', '')
        if line == '':
            break
        line_list = line.split('\t')
        if len(line_list) == 3:
            img_pairs.append(
                './datasets/lfw_funneled/' + line_list[0] + '/' + line_list[0] + '_' + ('000' + line_list[1])[-4:]
                + '.jpg')
            img_pairs.append(
                './datasets/lfw_funneled/' + line_list[0] + '/' + line_list[0] + '_' + ('000' + line_list[2])[-4:]
                + '.jpg')
            labels.append(1)
        elif len(line_list) == 4:
            img_pairs.append(
                './datasets/lfw_funneled/' + line_list[0] + '/' + line_list[0] + '_' + ('000' + line_list[1])[-4:]
                + '.jpg')
            img_pairs.append(
                './datasets/lfw_funneled/' + line_list[2] + '/' + line_list[2] + '_' + ('000' + line_list[3])[-4:]
                + '.jpg')
            labels.append(0)
        else:
            continue

        img_pairs_list.append(img_pairs)
    return img_pairs_list, labels
