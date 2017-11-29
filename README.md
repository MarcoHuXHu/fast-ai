# fast-ai
## 一些链接:
Git Repo: 
https://github.com/fastai/courses

Files:
http://files.fast.ai/data/

## AWS上的环境设置
对于Windows系统, 先安装cwgwin  
For windows, install cygwin first(with wget), as many scripts are in bash instead of cmd  

然后需要把python和pip装在cygwin下, 不然执行aws命令会找不到scripts.  
If run pip install awscli from cygwin, it may install awscli in Window's Anaconda Python installation, instead of in Cygwin's Python (which is what you want). 
Then, when you run aws configure, you will get an error that the aws executable can't be found. The solution is to try the following from a cygwin shell:pip uninstall awscli

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

## aws密钥丢失/共享
按照默认安装, 密钥储存在~/.ssh的aws-key-fast-ai.pem  
目前可行的方法是一台机器安装(执行setup-t2/p2.sh -> setup-instance.sh), 然后把.pem复制到其他机器上, 然后使用`chmod 400 key.pem`来设置权限, 之后便可用这个密钥登录.  
参见:
[在 AWS Linux 实例上管理用户账户](http://docs.aws.amazon.com/zh_cn/AWSEC2/latest/UserGuide/managing-users.html).  

如果完全丢失了密钥, 则需要通过另一个instance来恢复, 参见: 
[论坛](https://forums.aws.amazon.com/message.jspa?messageID=475034)
[视频](http://d2930476l2fsmh.cloudfront.net/LostKeypairRecoveryOfLinuxInstance.mp4)  

## 利用AWS控制台来创建实例

### AMI
AMI(Amazon Machine Images)相当于一个系统的镜像, 类似于系统还原点. 可以使用AWS提供的默认AMI(比如AWS Linux, Ubnutu等), 包含了Linux/Ubuntu操作系统和一些软件. 也可以想Fast.ai的install一样, 连接到已有的AMI(老师给大家搭建的, 上面装了比如tmux, Jupyter Notebook, Anaconda等等). 实例引用这些AMI就相当于从当前这样一个镜像开始使用.

### VPC,  Subnet, Route-Table, Internet-Gateway
VPC(Virtual Private Cloud)是AWS提供的虚拟网络, 相当于云端的一个私有的小型局域网. Subnet规定了VPC内的IP地址范围; Route Table相当于这个空间的路由器, Internet Gateway则是这个空间的网关.  

配置时, 要给VPC设置其IPv4 CIDR, 比如: `10.0.0.0/16`, 然后建立一个Internet Gateway并与VPC进行attach. 以及配置Subnet和Route Table, 其Destination一个指向`10.0.0.0/16`(即Target为VPC的local), 另一个指向`0.0.0.0/0`(即Gateway ID, 如: igw-********). 最后检查Subnet的Netwrok ACL是否对端口Allow.

创建完实例会自动生成key-pairs. 注意, 这个key-pair不能再次生成, 在Key Pairs里面create key pair会因为Permission Denied(Public Key), 而不可以用来连接实例. 


