# 第六课 RNN

RNN可以使得数据的顺序对模型训练和预测起到帮助: 当我们把结构化的数据比如一段文字, 按顺序(按字母/单词)分拆成多个输入, 以如上形式输入模型, 通过Hidden1操作的结果, 既接受Input0, 也接受到Input1; 而第n层Hidden(n)操作的结果, 则是通过了前面n-1层, 层层计算, 再接受Input(n). 即第n个Input在训练和预测时, 第1个Input的影响依然存在, 这样便可以看作模型"记住"了来自之前的数据.

### RNN的基本构造
```
Input0 → Hidden1 → Hidden2 → ... Hidden(n) → Output
           ↑         ↑             ↑
         Input1    Input2    ... Input(n)
```
在上图中, 箭头代表矩阵运算(如Dense层的线性运算, Convolution层的卷积运算)以及Activation(如relu, softmax). Input, Hidden, Output都代表张量, Input是按照时序拆分的输入, 比如对于文本而言, 一个Input是一句话中的一个词/字母对应的Embedding. Hidden与Output都是箭头代表的运算的结果, 所以上图也可以写成:  
```
         Hidden1   Hidden2       Hidden(n)
           ↑         ↑             ↑         
Input0 → Matrix1 → Matrix2 → ... Matrix(n) → Output
           ↑         ↑             ↑
         Input1    Input2    ... Input(n)
注: 图中实际应该由Hidden指向下一个Matrix
```
可以看出图中的箭头代表的运算实际分为三类:  
1. 从 Input  到 Hidden  
2. 从 Hidden 到 Hidden  
3. 从 Hidden 到 Output  
其中每一个Input的形状都是一致的, 每个Matrix的形状也是一致的, 考虑到我们希望矩阵运算的这些参数能够具有“记忆”, 因此实际上使用的是同一个矩阵, 即Matrix1 = Matrix2 = ... = Matrix(n)



### RNN实例: 文本预测
本例通过分析文本, 根据之前出现的字母来推测下一个出现的字母, 从而模仿原文本生成新的语句

#### 模型1: 单输出的RNN
##### 自行搭建的简单RNN
cs表示一个循环内接受的字符个数.  
输入输出数据:
```
c_in_dat = [[idx[i+n] for i in xrange(0, len(idx)-1-cs, cs)] for n in range(cs)]
c_out_dat = [idx[i+cs] for i in xrange(0, len(idx)-1-cs, cs)]
xs = [np.stack(c[:-2]) for c in c_in_dat]
y = np.stack(c_out_dat[:-2])
```
模型输入:
```
def embedding_input(name, n_in, n_out):
    inp = Input(shape=(1,), dtype='int64', name=name+'_in')
    emb = Embedding(n_in, n_out, input_length=1, name=name+'_emb')(inp)
    return inp, Flatten()(emb)
c_ins = [embedding_input('c'+str(n), vocab_size, n_fac) for n in range(cs)]
# c_ins[0]为输入, c_ins[1]为对应的Embedding
```
构建三种箭头分别表示的运算:
```
dense_in = Dense(n_hidden, activation='relu') # 从Input到Hidden
dense_hidden = Dense(n_hidden, activation='relu', init='identity') # 从 Hidden到Hidden
dense_out = Dense(vocab_size, activation='softmax') # 从Hidden到Output
# init='identity' 由于hidden层要循环cs次, 初始化误差太大会导致无法优化. 
# 以单位矩阵初始化Dense层, 使得模型未训练时能保证输入与输出一致
```
模型组合并训练:
```
for i in range(1,cs):
    c_dense = dense_in(c_ins[i][1])
    hidden = dense_hidden(hidden)
    hidden = merge([c_dense, hidden]) # 默认以加法merge
c_out = dense_out(hidden)
model = Model([c[0] for c in c_ins], c_out)
model.compile(loss='sparse_categorical_crossentropy', optimizer=Adam())
model.fit(xs, y, batch_size=64, nb_epoch=12)
```
##### 使用Keras
Keras将RNN封装成一个layer, 这样使用一个Embedding-RNN-Dense的序贯模型就行了
```
model=Sequential([
        Embedding(vocab_size, n_fac, input_length=cs),
        SimpleRNN(n_hidden, activation='relu', inner_init='identity'),
        Dense(vocab_size, activation='softmax')
    ])
```
这里Embedding前两个参数与之前相同, 然而不同于手动建模, 为了配合RNN, input_length不再是1(代表输入一个字母), 而是cs(代表输入cs个字母).  
模型的编译和训练与自行搭建的模型是一样的, 
```
model.compile(loss='sparse_categorical_crossentropy', optimizer=Adam())
model.fit(np.concatenate(xs,axis=1), y, batch_size=64, nb_epoch=8)
```

#### 输出序列的RNN
以上模型会传入cs-1个字母作为input, 而第cs个作为output. 但是这样RNN实际上对这cs-1个字母每个都有一个output, 而这些output也是可以跟原文对照来帮助训练的, 因此对模型做如下修改:
首先是训练用的输出会变成:
```
c_out_dat = [[idx[i+n] for i in xrange(1, len(idx)-cs, cs)] for n in range(cs)]
# 注: input循环的下标是xrange(0, len(idx)-cs-1)
```
三种箭头表示的运算还是一样, 不过在组合模型上略有不同. 