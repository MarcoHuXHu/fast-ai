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