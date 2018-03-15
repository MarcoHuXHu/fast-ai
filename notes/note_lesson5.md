# 第五课

这一章开始的时候回顾了如何给预训练模型vgg16加入batch_normalization(并未加入到卷积层).  然后回顾了上节课末尾的Collaborative Filtering以及Keras的Functional Model. 这一部分仍然放在第四课的笔记中了.  

## NLP
### 实例: IMDB情感分析
目标: 根据影评来分析其表达的情感是正面/负面/中立... 整个数据集由25000条影评以及代表影评情感的标签组成. 每条影评实际是一个向量, 每个元素为一个单词按照出现频率排列的索引.  

预处理:  
首先, 考虑到很多单词出现频率极低, 为了减小内存开支和训练时间, 取用前5000个词, 之后的单词统一按一个给定ID处理.  
然后, 有的影评很长而有的很短, 需要对句子进行截断, 使长度统一为500. 使用
```trn = sequence.pad_sequences(trn, maxlen=seq_len, value=0)```
可以对向量进行截断, 短的在左边补0.

#### 建立模型
以Embedding作为第一层, 对输入的句子进行转化. 其中vocab_size=5000, 词典(选用高频词后)大小, 32为latent factors的数目, seq_len=500, 代表每个句子的长度. 
```
Embedding(vocab_size, 32, input_length=seq_len)
```
然后可以Flatten加Dense层做一个简单的神经网络, 也可以利用卷积神经网络. 方法如下:
```
Convolution1D(64, 5, padding='same', activation='relu) #新版本里面padding相当于border_mode
```
这个卷积层由64个filter组成, 每个filter为5*32. 这是因为这里每个latent factor相当于彩色图片的一个颜色通道.

#### 预训练模型
就像利用Vgg16来识别猫狗一样, 可以利用预先训练好的单词的Embedding向量. 而且不像图像识别中的预训练模型, 如果finetune和后续predict使用过程中使用的图片(比如狗的图片)和模型训练时候使用的有很大不同, 模型会不能很好的工作. 而单词则不会出现这样的问题. 不过如果语料库单一的话可能还是会有问题吧.

由于预编译模型(glove)中单词的index与IMDB不同, 因此还需要进行转换, 从中挑选IMDB中需要的Embeddings, IMDB中有的而glove中没有的Embeddings, 则随机初始化. 训练时注意一开始要把Embeddings层设置为不可训练, 等到模型稳定下来, 在设置为可训练进行微调.