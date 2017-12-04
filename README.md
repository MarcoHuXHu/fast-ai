# fast-ai
## 一些链接:
Git Repo: 
https://github.com/fastai/courses

Files:
http://files.fast.ai/data/

## AWS上的环境设置
对于Windows系统, 先安装cwgwin  
For windows, install cygwin first(with wget), as many scripts are in bash instead of cmd  

然后需要把python和pip装在cygwin下, 默认会把awscli安装在Windows的Anaconda Python下, 而不是我们想要的安装在Cygwind Python下. 这样执行aws命令会找不到scripts(aws executable can't be found).  

方法如下:

通过wget安装apt-cyg  
```
wget rawgit.com/transcode-open/apt-cyg/master/apt-cyg
install apt-cyg /bin
用atp-cyg来安装python
apt-cyg install python
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install awscli
```

如果要免费试用的话, 记得把t2的instance由t2.xlarge改成t2.micro
以及, 在aws-alias.sh中获取实例的alias: aws-get-t2命令中的xlarge改成micro

最后, 由于window会自动给文本后面加换行符, 需要利用dos2unix对从github上得到的.sh文件进行转换
```
apt-cyg install dos2unix
dos2unix setup_t2.sh
dos2unix setup_instance.sh
```
最后, 执行:  
```bash setup_p2.sh```

注意, 在AWS的console中, 记得把区域切换到Oregan(us-west-2), 否则看不到创建的instance的  

## 本地环境配置

### 安装
由于Fast.ai上使用的是python2, 所以本地也使用python2版本的Anaconda2. 先从[官网](https://www.anaconda.com/download/)下载并安装Anaconda For Python2.7 version. 注意添加路径等问题.   

然后是[Keras](https://keras-cn.readthedocs.io/en/latest/)的配置. 先安装Keras的底层Theano或TensorFlow, 由于Fast.ai用的是Theano, 这里不用装TensorFlow了. Keras依赖的numpy，scipy
pyyaml, HDF5, h5py都有包含在Anaconda里面, 所以只需要装Theano:  
```conda install theano```  

Keras没放在Anaconda2上, 所以利用pip来安装:  
```pip install keras==1.2.2```

Keras默认的底层是TensorFlow, 要切换到Theano, 需要修改配置文件  
Windows: `%USERPROFILE%\.keras\keras.json`  
Mac: `~/.keras/keras.json`  
如果找不到的话, 可能需要先运行一次Keras, 比如在ipython下执行
```python
from keras.models import Sequential
model = Sequential()
```

最后把keras.json中的一下内容  
```json
"image_dim_ordering": "tf"
"backend": "tensorflow"
```
改成
```json
"image_dim_ordering": "th"
"backend": "theano"
```

### 运行
安装了Anaconda后, 会自带一个本地的Jupyter Notebook服务器, 可以在IDE中打开, 也可以通过命令行打开, 配置什么的也可见notes中内容. 然后就可以运行代码了.

不过装在win7上的在运行中好像不会显示细节, 不知道为什么...



