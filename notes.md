# Tips - 一些学习时掌握的小技巧

## SSH

SSH是一种网络协议, 用于计算机之间的加密登录, 常用的实现有OpenSSH, PuTTY.

### 整个过程是这样的  
（1）远程主机收到用户的登录请求把自己的公钥发给用户.  
（2）用户使用这个公钥, 将登录密码加密后, 发送回来.  
（3）远程主机用自己的私钥, 解密登录密码, 如果密码正确, 就同意用户登录.

### 中间人攻击  
如果有人截获了登录请求, 然后冒充远程主机, 将伪造的公钥发给用户, 就可以用伪造的公钥, 获取用户的登录密码, 并用这个密码登录远程主机

### 口令登录  
连接到主机: 
```
$ ssh user@host
The authenticity of host 'host (12.18.429.21)' can't be established.
RSA key fingerprint is 98:2e:d7:e0:de:9f:ac:67:28:c2:42:2d:37:16:58:4d.
Are you sure you want to continue connecting (yes/no)?
```
选yes表示用户决定接受这个远程主机的公钥, 然后输入密码登录

### 公钥登录
原理就是用户将自己的公钥储存在远程主机上。登录的时候，远程主机会向用户发送一段随机字符串，用户用自己的私钥加密后，再发回来。远程主机用事先储存的公钥进行解密，如果成功，就证明用户是可信的，直接允许登录shell，不再要求密码。

这种方法要求用户必须提供自己的公钥。如果没有现成的，可以直接用ssh-keygen生成一个:  
`$ ssh-keygen'  
运行结束以后，在$HOME/.ssh/目录下，会新生成两个文件：id\_rsa.pub和id\_rsa。前者是你的公钥，后者是你的私钥。然后把公钥传到服务器上去

## bash小技巧：利用.bashrc

每次重新打开bash的时候, alias都没有了, 又要source aws-alias.sh一遍
想要让这些alias一直有效, 可以把source aws-alias.sh这个命令加入到.bashrc中
对于Mac OSX, 由于terminal是一种login shel, 会执行~/.bash_profile而不是~/.bashrc
所以要让bash_profile自动取执行.bashrc, 即在其中加入[[ -s ~/.bashrc ]] && source ~/.bashrc


## tmux:

tmux, 终端里的"窗口管理器", 相当于bash开多个窗口运行, 相当高效

session 会话：session是一个特定的终端组合. 输入tmux就可以打开一个新的session

window 窗口：session 中可以有不同的 window（但是同时只能看到一个 window）

pane 面板：window 中可以有不同的 pane（可以把 window 分成不同的部分）


## upzip -q: quiet模式, 不输出文件名