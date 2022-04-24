import matplotlib.pyplot as plt


x_axis = range(0, 11)
with_softmax = [0, 0.535, 0.691, 0.733, 0.765, 0.796, 0.811, 0.819, 0.826, 0.831, 0.835]
no_softmax = [0, 0.03, 0.05, 0.08, 0.11, 0.112, 0.122, 0.123, 0.128, 0.131, 0.134]
plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.plot(x_axis, with_softmax, marker='o', label='With Softmax Loss')
plt.plot(x_axis, no_softmax, marker='^', label='No Softmax Loss')
plt.legend(loc='right', ncol=1, fancybox=True, title='Legend')
plt.show()
print(len(no_softmax))
