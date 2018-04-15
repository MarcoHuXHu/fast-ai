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

### Multi-Input: 加入Metadata
比如在Fiesheries中, 利用函数式模型, 加入图片大小作为metadata:  
```
# 预训练模型经过卷积层后的结果
inp = Input(conv_layers[-1].output_shape[1:])

# 图像的size经过batchnormalization
sz_inp = Input((len(id2size),))
bn_inp = BatchNormalization()(sz_inp)

x = MaxPooling2D()(inp)
x = BatchNormalization(axis=1)(x)
x = Dropout(p/4)(x)
x = Flatten()(x)
x = Dense(512, activation='relu')(x)
x = BatchNormalization()(x)
x = Dropout(p)(x)
x = Dense(512, activation='relu')(x)
x = BatchNormalization()(x)
x = Dropout(p/2)(x)

# 将metadata合并入模型
x = merge([x,bn_inp], 'concat')
x = Dense(8, activation='softmax')(x)
```

## Redundant Metadata
事实上, 我们并不需要指定让模型学习Data Leakage的metadata, 模型也会自动学习这些特征. 因此我们就算给模型提供这些Metadata去学习, 也不会提高正确率. 这就是Redundant Metadata. 比如在之前的IMDB问题中, 即使给模型指定一些用户/电影的metadata去学习, 也不会提高正确率了.


## Multi Output: 给目标加边框
在Fiesheries中有人手动给照片中的鱼加入了边框, 利用这些数据, 可以训练模型在识别鱼的种类的同时, 训练如何加入包含鱼的边框. 这就需要模型有两个不同的输出, 一个是鱼的种类, 另一个是边框的坐标和长宽.  
建立模型跟之前没什么区别, 只是加入了一层`x_bb = Dense(4, name='bb')(x)`用于将前面层的结果与边框坐标(x, y), 长宽(height, width)关联的全联通层.  
```
inp = Input(conv_layers[-1].output_shape[1:])
x = MaxPooling2D()(inp)
x = BatchNormalization(axis=1)(x)
x = Dropout(p/4)(x)
x = Flatten()(x)
x = Dense(512, activation='relu')(x)
x = BatchNormalization()(x)
x = Dropout(p)(x)
x = Dense(512, activation='relu')(x)
x = BatchNormalization()(x)
x = Dropout(p/2)(x)
x_bb = Dense(4, name='bb')(x)
x_class = Dense(8, activation='softmax', name='class')(x)
```
编译和训练:  
```
model = Model([inp], [x_bb, x_class])
model.compile(Adam(lr=0.001), loss=['mse', 'categorical_crossentropy'], metrics=['accuracy'],
             loss_weights=[.001, 1.])
model.fit(conv_feat, [trn_bbox, trn_labels], batch_size=batch_size, nb_epoch=3, 
             validation_data=(conv_val_feat, [val_bbox, val_labels]))            
```
这样的模型可以提高正确率.

