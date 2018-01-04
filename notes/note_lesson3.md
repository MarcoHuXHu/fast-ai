# 第三课

## 概念

### Correlation & Convolution

Correlation:
$$
F \circ I(x) = \sum_{i=1}^{n}F(i)I(x+i)
$$
Convolution:
$$
F \circ I(x) = \sum_{i=1}^{n}F(i)I(x-i)
$$
Convolution就是将filter先转置在做Correlation

以一个3*3的filter为例, 现有一个矩阵A, 其中一部分为:  
$
\left[
  \begin{matrix}
... & A_{i-1,j-1}    &  A_{i-1,j}  &   A_{i-1,j+1} & ...  \\
... & A_{ i,j-1}      & A_{ i,j}     &   A_{ i,j+1} &   ...  \\
... & A_{ i+1,j-1} & A_{ i+1,j} &   A_{ i+1,j+1} & ...
  \end{matrix}
\right]
$

filter矩阵X为:

$
\left[
  \begin{matrix}
   1 & 2 & 3 \\
   4 & 5 & 6 \\
   7 & 8 & 9
  \end{matrix}
\right]
$

则Correlation为:
$
X^{'}_{i,j} = 
1 * A_{i-1,j-1} + 2 * A_{i-1,j} + 3 * A_{i-1,j+1} + 
4 * A_{ i,j-1} + 5 * A_{ i,j} + 6 * A_{ i,j+1} + 
7 * A_{ i+1,j-1} + 8 * A_{ i+1,j} + 9 * A_{ i+1,j+1}
$
Convolution为:
$
X^{'}_{i,j} = 
9 * A_{i-1,j-1} + 8 * A_{i-1,j} + 7 * A_{i-1,j+1} + 
6 * A_{ i,j-1} + 5 * A_{ i,j} + 4 * A_{ i,j+1} + 
3 * A_{ i+1,j-1} + 2 * A_{ i+1,j} + 1 * A_{ i+1,j+1}
$


## Keras中的卷积层与相关概念
猜测:
比如线性层就是矩阵乘法, 卷积层就是对图像矩阵, 做filter的卷积, filter的数目就相当于矩阵的列数目

### Convolution2D


### MaxPooling2D:
**池化Pooling**: 把卷积特征划分成为m\*n个x\*y大小的不相交区域, 计算区域上特征的最大值(MaxPooling), 或者平均值, 作为Pooling后的卷积特征. Pooling后的卷积特征矩阵变成m*n的形状.
比如在vgg16中, 利用```model.add(MaxPooling2D(pool_size=(2, 2), strides=(2, 2)))```来进行Pooling, 这样下一层的特征矩阵就会在x, y方向都变为原来的一半. (strides: 步长值, 若小于pool_size则Pooling区域会相交)

### ZeroPadding2D:
对2D输入（如图片）的边界填充0，以控制卷积以后特征图的大小

### Softmax
$$
P(x_{j}) = \frac{e^{x_{j}}}{\sum_{i=1}^{n}e^{x_i}}
$$


### Dropout
随机抛弃一些Activation, 防止过拟合


### Data 
当数据不足是, 通过对训练数据的图片进行平移, 旋转, 翻转等操作(shuffle=True)产生更多训练集数据, 而验证数据不应该被改变

### Batch Regulazation
