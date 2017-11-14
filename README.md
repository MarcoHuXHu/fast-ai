# fast-ai
## 一些链接:
Git Repo: 
https://github.com/fastai/courses

Files:
http://files.fast.ai/data/

## 关于环境设置
对于Windows系统, 先安装cwgwin
For windows, install cygwin first(with wget), as many scripts are in bash instead of cmd

然后需要把python和pip装在cygwin下, 不然执行aws命令会找不到scripts
If run pip install awscli from cygwin, it may install awscli in Window's Anaconda Python installation, instead of in Cygwin's Python (which is what you want). 
Then, when you run aws configure, you will get an error that the aws executable can't be found. The solution is to try the following from a cygwin shell:pip uninstall awscli

方法如下:

通过wget安装apt-cyg
wget rawgit.com/transcode-open/apt-cyg/master/apt-cyg
install apt-cyg /bin
用atp-cyg来安装python
apt-cyg install python
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install awscli

如果要免费试用的话, 记得把t2的instance由t2.xlarge改成t2.micro
以及, 在aws-alias.sh中获取实例的alias: aws-get-t2命令中的xlarge改成micro

最后, 由于window会自动给文本后面加换行符, 需要利用dos2unix把从github上copy的sh转换
apt-cyg install dos2unix
dos2unix setup_t2.sh
dos2unix setup_instance.sh
then finally, bash setup_p2.sh

注意, 在AWS的console中, 记得把区域切换到Oregan(us-west-2), 否则看不到创建的instance的
