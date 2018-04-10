# 第七课

## Resnet(Residual Network残差网络)
对于一般的图像识别的finetune而言, 卷积层一般是不动的, 可以直接使用输入数据经过卷积层的结果来训练. 所谓残差, 即上一次Hidden层的输出与这一次Hidden层的输出之差. Resnet训练优化的就是这个残差函数. Resnet有很多个Block, 每一个Block内有由若干个卷积层. 该Block的输出为: 输入Hidden层经过这些卷积层运算的结果与输入Hidden层之和.  
设每个卷积层的运算为C, Block进入时的Hidden为H_t, Resnet的这个Block的输出H_(t+1)为:  
H_(t+1) = H_t + C(C(C(...(H_t)...)))  
残差R(H_t)为:  
R(H_t) = H_(t+1) - H_t
### Global Average Pooling


## Data Leakage

## Redundant Metadata
