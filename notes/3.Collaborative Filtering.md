# 协同过滤Collaborative Filtering
此刻我们从CNN进入到Natural Language Processing (NLP)的学习, 从协同过滤以及其在推荐系统的应用开始讲起

### 推荐系统
推荐系统是用来预判一个人会喜欢什么, 有多么喜欢. 一般有两种方式: 第一种是利用比如用户调查这样的信息(称之为元数据meta-data)来过滤出推荐结果. 比如微博选择感兴趣的标签, 然后就会收到相关推送. 另一种就是协同过滤.  
协同过滤则是通过找到与你喜好相似的用户, 然后根据这些用户的喜好来得到推荐结果. 而“喜好相似”, 以电影推荐的例子来说, 则是对相同电影打分接近.  
在数据集足够大的情况下, 协同过滤的效果会比元数据过滤要好得多. 而且对于协同过滤的结果再施加元数据过滤并不会对准确率有什么提高(因为要想知道一个人的爱好, 直接询问, 还不如观察这个人的行为来得可靠).  

### 协同过滤的基本实现
Movielens的dataset中选择n个用户, 对m部电影的评分(没有评分记作0). 这样得到了一个n\*m的矩阵. 对于每一个用户, 随机初始化一个长度为a的向量(embedding), 代表用户的属性; 对于每一部电影, 同样的随机初始化一个长度为a的向量, 代表电影的属性. 如果我们把一对用户-电影的embeddings做点乘, 可以得到这个用户对这部电影的计算出来的评分. 全部用户embeddings组成一个n\*a的矩阵表示; 全部电影的embeddings组成一个a\*m的矩阵表示. 对这两个矩阵坐点乘, 得到了一个与用户对电影评价相同的n\*m的矩阵.  
我们可以把这个点乘结果的矩阵看作是模型预测值, 而Movielens的dataset抽取出来的矩阵看作是标签, 这样就可以做梯度下降来优化参数, 即优化每个随机初始化的用户属性向量和电影属性向量.  
大部分情况下, 我们并不知道这些用户属性向量和电影属性向量每个参数的具体含义, 因此称之为**latent factors**(潜在因子).

### 加入bias
假设用户有一种属性, 与单个电影无关, 而是与所有电影有关, 比如某个用户非常喜欢看电影. 则我们对于每个用户引入一个bias参数, 在计算预测结果的时候, 每个用户对所有的电影的评分都加上与这个用户的bias参数. 同样的, 对于每部电影也有一个bias参数, 则所有用户对于这部电影的评分都加上这部电影的bias参数. 这样一共有n+m个bias参数, 随机初始化, 坐梯度下降的时候同时对这些bias进行优化. 加入bias之后模型的loss会进一步降低.



### 嵌入层Embedding
嵌入层只能用于第一层, 负责将下标转换成为给定形状的向量
```
keras.layers.embeddings.Embedding(input_dim, output_dim, embeddings_initializer='uniform', embeddings_regularizer=None, activity_regularizer=None, embeddings_constraint=None, mask_zero=False, input_length=None)
```
常用参数:  
input_dim: 大或等于0的整数, 字典长度, 即输入数据最大下标+1. 比如Movielens中, User的Id为1-n, 则input_dim=n.  
output_dim: 大于0的整数, 代表全连接嵌入的维度. 在Movielens中, 我们对每个User和Movie都设置50个latetn factor, 所以这里output_dim=50.  
input_length: 当输入序列的长度固定时, 该值为其长度. 注意如果要在该层后接Flatten层, 然后接Dense层, 则必须指定该参数, 否则Dense层的输出维度无法自动推断. 比如Movielens输入的是UserId/MovieId, 都是一个整数, 所以input_length=1; IMdbs输入的是长度为500的句子, 所以input_length=500.  


### 融合层Merge
Merge层提供了一系列用于融合两个层或两个张量的层对象和方法. 以大写首字母开头的是Layer类(Add, Multiply等), 以小写字母开头的是张量的函数(add, multiply).  小写字母开头的张量函数在内部实际上是调用了大写字母开头的层. 比如:  
```
import keras
input1 = keras.layers.Input(shape=(16,))
x1 = keras.layers.Dense(8, activation='relu')(input1)
input2 = keras.layers.Input(shape=(32,))
x2 = keras.layers.Dense(8, activation='relu')(input2)
subtracted = keras.layers.Subtract()([x1, x2]) 
#或者 subtracted = keras.layers.subtract([x1, x2])
```


### 函数式模型API
Functional Model API在使用时利用的是"函数式编程"的风格, 总而言之, 只要这个东西接收一个或一些张量作为输入, 然后输出的也是一个或一些张量, 那不管它是什么, 统统都称作"模型", 即Model类.  
