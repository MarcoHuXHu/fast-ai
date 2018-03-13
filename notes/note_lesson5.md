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

#### 模型输入
```
Embedding(vocab_size, 32, input_length=seq_len)
```
其中vocab_size=5000, 词典(选用高频词后)大小, 32为latent factors的数目, seq_len=500, 代表每个句子