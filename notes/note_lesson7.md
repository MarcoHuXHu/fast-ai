# 第七课

## Resnet(Residual Network残差网络)
对于一般的图像识别的finetune而言, 卷积层一般是不动的, 可以直接使用输入数据经过卷积层的结果来训练. 所谓残差, 即上一次Hidden层的输出与这一次Hidden层的输出之差. Resnet训练优化的就是这个残差函数. Resnet有很多个Block, 每一个Block内有由若干个卷积层. 该Block的输出为: 输入Hidden层经过这些卷积层运算的结果与输入Hidden层之和.  
设每个卷积层的运算为C, Block进入时的Hidden为H_t, Resnet的这个Block的输出H_(t+1)为:  
H_(t+1) = H_t + C(C(C(...(H_t)...)))  
残差R(H_t)为:  
R(H_t) = H_(t+1) - H_t
可以看出, Resnet输出的是两个Block之间的差, 这样通过不断优化两个Block之间的残差, 使得前一个Block不断接近答案. 另外, 每个Block的首尾需要作求和运算, 则其输出的维度必须一致, 则MaxPooling只能放在Block之间.


## Data Leakage
有时候一些来自于输入, 但是又和实际应用无关的数据, 会大大提高模型的准确率. 比如在Fisheries中, 照片的长宽会与输出有很明显的关联. 照片的长款可以反映拍照的相机的类型, 从而与某一艘船对应起来, 而船只会在固定海域航行, 拍摄到的鱼的种类也与此相关, 因此模型通过学习照片的长宽就能很好的预测鱼的种类了. 然而这样建立出来的模型对于实际应用则没有太大帮助, 只要船上的相机与训练集不同, 就会导致很大偏差.


## Redundant Metadata
事实上, 我们并不需要指定让模型学习Data Leakage的metadata, 模型也会自动学习这些特征. 因此我们就算给模型提供这些Metadata去学习, 也不会提高正确率. 这就是Redundant Metadata. 比如在之前的IMDB问题中, 即使给模型指定一些用户/电影的metadata去学习, 也不会提高正确率了.


## Multi Output