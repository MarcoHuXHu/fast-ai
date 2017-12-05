# 第二课 一些知识概念

### 养成一个好的习惯: Train和Test的数据分开, Train完成前不去看Test的数据, 保持真实性

### Dogs vs Cats运行不了, 因为对于vgg16来说, t2.mirco实例的内存太小了, 需要切换到GPU或者t2.xlarge来运行.
**果然, 切换到xlarge就可以运行了, 贫穷限制了我的想象**
**贫穷的我最终还是选择了在本地跑, 不然光是数据和参数文件vgg16.h5就要花8刀/月**
**是时候买GPU用来学(chi)习(ji)啦**

## [Universal Approximation Theorem](https://en.wikipedia.org/wiki/Universal_approximation_theorem)

一个具有 有限的Neuron(神经元), 单层Hidden Layer 的 前馈(参数从输入层向输出层单向传播) 神经网络, 可以用来近似很多函数(欧几里德空间有界闭合子集上的连续函数)  



## Feedforward neural network 前馈神经网络
节点间连接无环的人工神经网络, 信息从输入层向输出层单相传播



### Learning Techniques:  
神经网络利用训练集不断优化自身节点间权重, 最终收敛到误差足够小的状态.  此时神经网络习得目标函数.

### Supervised learning 监督学习:
训练集有标签. 即用来训练的每一个例子, 都是输入数据和输出结果成对出现的. 

### backpropagation反向传播 & Gradient Dscent梯度下降:
反向传播: 神经网络的一种学习方式. 将神经网络推算出的结果与正确结果比较, 利用预先设定的误差函数计算出误差值, 然后把误差反过来从输出层往输入层传播, 在此过程中调节权重.  
梯度下降: 非线性最优化中, 反向传播调节权重的一种方式. 通过计算误差对于权重变化的导数, 来改变权重使得误差减小. 故而反向传播只适用于激活函数可导情况

### Stochastic gradient descent
TODO

### overfit 过拟合:
对比于可获取的数据总量来说, 用过多参数, 使得模型只要足够复杂，就可以可以完美地适应数据.



## Multi-Layer Perceptron(MLP) 多层感知器

注: 与自然语言处理Natural Language Processing(NLP) 相区别.  
前馈神经网络的一种, 包含至少三层神经节点(输入层, 输出层, 和至少一层隐藏层(hidden layer)). 除了输入节点外, 每个节点都使用非线性激活函数. MLP利用反向传播来训练.  
MLP是fully connected, 即其中任意节点, 都与下一层的每一个节点有连接, 权重为w<sub>ij<sub>.  

### Activation function 激活函数
[各类激活函数优缺点比较](https://en.wikipedia.org/wiki/Activation_function)  
节点的激活函数确定了给定的输入或输入集下, 节点的输出. 如果激活函数都为线性, 则任意多层神经节点都可以优化成两层(input-output). 故而多层感知器一定是非线性激活函数, 比如sigmoid(S函数). 

