# 第一课 熟悉环境与工具

## Google Cloud
Google的Colaboratory目前是免费提供GPU给用, 感动坏了.

不过不像AWS, Google Cloud只提供计算功能, 虚拟机关机就没数据了, 所以运行之前要重新安装各种库.
预装了python(2.7/3.6), pip, apt-get这些基本工具, 当然还有自家的TensorFlow.

**安装pytorch**, 考虑到更新, 这个命令可以去[官网](http://pytorch.org/)上获得, CUDA选择8.0
```
!pip3 install http://download.pytorch.org/whl/cu80/torch-0.3.1-cp36-cp36m-linux_x86_64.whl 
!pip3 install torchvision
```
**安装fastai**
```
!pip3 install fastai
```
虽然每次都要重装, 而且预训练模型的参数要重新载入, 但是考虑到40mb/s的网速, 不到一分钟就可以把环境配置好了呢~

## AWS

执行Fast.ai课程提供的bash脚本就可以完成对于学习环境的配置了, 这里主要是自行手动配置的一些笔记

### AMI
AMI(Amazon Machine Images)相当于一个系统的镜像, 类似于系统还原点. 可以使用AWS提供的默认AMI(比如AWS Linux, Ubnutu等), 包含了Linux/Ubuntu操作系统和一些软件. 也可以想Fast.ai的install一样, 连接到已有的AMI(老师给大家搭建的, 上面装了比如tmux, Jupyter Notebook, Anaconda等等). 实例引用这些AMI就相当于从当前这样一个镜像开始使用.

### VPC,  Subnet, Route-Table, Internet-Gateway
VPC(Virtual Private Cloud)是AWS提供的虚拟网络, 相当于云端的一个私有的小型局域网. Subnet规定了VPC内的IP地址范围; Route Table相当于这个空间的路由器, Internet Gateway则是这个空间的网关.  

配置时, 要给VPC设置其IPv4 CIDR, 比如: `10.0.0.0/16`, 然后建立一个Internet Gateway并与VPC进行attach. 以及配置Subnet和Route Table, 其Destination一个指向`10.0.0.0/16`(即Target为VPC的local), 另一个指向`0.0.0.0/0`(即Gateway ID, 如: igw-********). 最后检查Subnet的Netwrok ACL是否对端口Allow.

创建完实例会自动生成key-pairs. 注意, 这个key-pair不能再次生成, 在Key Pairs里面create key pair会因为Permission Denied(Public Key), 而不可以用来连接实例. 

### AWS密钥丢失/共享
按照默认安装, 密钥储存在~/.ssh的aws-key-fast-ai.pem  
目前可行的方法是一台机器安装(执行setup-t2/p2.sh -> setup-instance.sh), 然后把.pem复制到其他机器上, 然后使用`chmod 400 key.pem`来设置权限, 之后便可用这个密钥登录.  
参见:
[在 AWS Linux 实例上管理用户账户](http://docs.aws.amazon.com/zh_cn/AWSEC2/latest/UserGuide/managing-users.html).  

如果完全丢失了密钥, 则需要通过另一个instance来恢复, 参见: 
[论坛](https://forums.aws.amazon.com/message.jspa?messageID=475034)
[视频](http://d2930476l2fsmh.cloudfront.net/LostKeypairRecoveryOfLinuxInstance.mp4)  

### AWS省钱之EIP(Elastic IP)

由于AWS的EIP是有限的, 所以为了防止空占, 对于没有绑定运行实例的EIP, 每个要收取每小时0.005刀的费用.  
**注意是运行实例, 实例处于停止状态是要收费的**, 也就是说实例运行要收取运行时的费用, 不运行要收取EIP的费用.  
于是对于免费实例来说, 运行不收钱而不运行反而收钱...... 节能环保的好孩子我就这样冤枉交了好多刀......



## Anaconda

Anaconda是一个科学计算Python环境, 集成了常用的各种包.

### 安装:
下载安装文件: `wget https://repo.continuum.io/archive/Anaconda2-4.5.0-Linux-x86_64.sh`, 2-4.5.0表示为Anaconda2(基于python2, Anaconda3基于python3). 可以先去官网下载文件以获取最新的版本号. 

执行安装文件: `bash Anaconda2-4.5.0-Linux-x86_64.sh`, 让bash执行刚刚wget到的.sh.  

添加路径: 将`export PATH=/home/ec2-user/anaconda2/bin:$PATH`加入到~/.bashrc中, 然后`source ~/.bashrc`.  

更新Anaconda: `conda update conda`  

### 卸载:
由于很多库已经不对python2提供更新了, theano也不动了, 所以我们更新到Anaconda3. 首先使用以下命令清理Anaconda的配置.
#### Mac卸载
```
conda install anaconda-clean
anaconda-clean --yes
```
然后直接`sudo rm -rf ~/anaconda`就可以删除了.  
最后Anaconda会把配置文件备份到`~/.anaconda_backup`, 也删掉.

#### Win卸载
Windows直接运行anaconda目录下的uninstall可以卸载干净.




## Jupyter Notebook

一款类似于学习笔记的工具, 将markdown与code结合在一起, 可以一边记笔记一边跑代码, 同时还可以生成和插入图表

### 安装和配置:
fast.ai给的AMI已经装好了, 如果在自己的服务器或本地上安装的话, Anaconda也自带了Jupyter Notebook, 不需要再安装.  
配置的话, 首先进入`IPython`生成密码. 这个密码Jupyter Notebook的访问密码, 记得复制一下生成的密钥.  
```
$ ipython
In [1]: from IPython.lib import passwd                                                                    
In [2]: passwd()                                                                                          
Enter password:                                                                                           
Verify password:  
Out[2]: 'sha1:aeaec*****d2:d5************************************ec' 
```
退出IPython, 然后给Jupyter Notebook生成配置:  
`$ jupyter notebook --generate-config`  
接着生成https访问所需的密钥:  
```
$ mkdir certs                                                
$ cd certs                        
$ openssl req -x509 -nodes days 365 -newkey rsa:1024 -keyout notes.pem -out notes.pem 
```
然后修改Jupyter Notebook的配置: 在`~/.jupyter/jupyter_notebook_config.py`中加入:  
```
c = get_config()                                             
c.NotebookApp.certfile = u'/home/ec2-user/certs/notes.pem'
c.NotebookApp.ip = '*'                                       
c.NotebookApp.open_browser = False              
c.NotebookApp.password = u'sha1:aeaec*****d2:d5************************************ec'
c.NotebookApp.port = 8888                              
```

最后, 执行`conda install nb_conda`, 这样Jupyter Notebook就可以使用conda root的kernel了.

运行`Jupyter Notebook`. 然后通过https://AWS实例的IP:8888就可以进入. 注意要加`https`. 以及AWS的VPC的Security Group中加入`Inbound Rules`:  
|Type|Protocol|Port Range|Source|
|---|---|---|---|
|Custom TCP Rule| TCP (6)  |8880-8899 |0.0.0.0/0|

### Jupyter Notebook与防火墙的战斗
学习中发现, Jupyter Notebook可以在Mac上运行, 甚至可以在iPhone上运行, 然而在Windows上却不行. 防火墙也全部关掉了. 看来是杀毒软件的问题. 不过好像利用https来连接的话就可以执行了诶.



## Keras
Keras是一个高层神经网络API, Keras由纯Python编写而成并基Tensorflow, Theano以及CNTK后端.  

**本课程使用的是Keras-1.2.2, Theano0.8.2, 注意不要更新, 如果更新了, 使用一下命令还原到1.2.2版本:**  
```
pip install 'keras<2'
conda install 'theano<0.9'
```

**OSX要先安装xcode命令行, 否则会报stdio.h file not found的错误**
```xcode-select --install```