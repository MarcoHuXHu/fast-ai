# Tips - 一些学习时掌握的小技巧

## Anaconda

Anaconda是一个科学计算Python环境, 集成了常用的各种包.

### 安装:
下载安装文件: `wget https://repo.continuum.io/archive/Anaconda2-4.5.0-Linux-x86_64.sh`, 2-4.5.0表示为Anaconda2(基于python2, Anaconda3基于python3). 可以先去官网下载文件以获取最新的版本号. 

执行安装文件: `bash Anaconda2-4.5.0-Linux-x86_64.sh`, 让bash执行刚刚wget到的.sh.  

添加路径: 将`export PATH=/home/ec2-user/anaconda2/bin:$PATH`加入到~/.bashrc中, 然后`source ~/.bashrc`.  

更新Anaconda: `conda update conda`  


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
运行结束以后，在$HOME/.ssh/目录下，会新生成两个文件：id\_rsa.pub和id\_rsa。前者是你的公钥，后者是你的私钥, 然后把公钥传到服务器上去用于登录. 

比如用来添加一个用户, 先登录(以AWS Ubuntu为例, 注: 在给Ubuntu系统添加用户时, 不要添加密码)  
`[ubuntu ~]$ sudo adduser newuser --disabled-password`  
一路回车之后, 切换到新账户，以便使新建的文件具有正确的所有权。
`[ubuntu ~]$ sudo su - newuser`  
`[newuser ~]$`  
这就表示切换过来了, 然后是创建.ssh, .ssh/authorized_keys, 并设置权限  
```
[newuser ~]$ mkdir .ssh
[newuser ~]$ chmod 700 .ssh
[newuser ~]$ touch .ssh/authorized_keys
[newuser ~]$ chmod 600 .ssh/authorized_keys
```
最后vi authorized_keys, 把公钥复制过去就OK了
以及如果要删除用户:
`[ubuntu ~]$ sudo userdel -r olduser`

## chmod

chmod命令用于改变linux系统文件或目录的访问权限, 有两种操作法, 一种包含字母和符号的, 另一种纯数字

### 字母符号法
`chmod [权限范围][+-=][权限代号] file`  
权限范围:  
* u ：目录或者文件的当前的用户  
* g ：目录或者文件的当前的群组  
* o ：除了目录或者文件的当前用户或群组之外的用户或者群组  
* a ：所有的用户及群组  

`+`代表增加权限, `-`代表删去权限, `=`代表设置权限

权限代号:  
* r ：读权限，用数字4表示  
* w ：写权限，用数字2表示  
* x ：执行权限，用数字1表示  

例如: `chmod ug+w,o-x file`, 即设定文件file的属性为: 文件属主u和与文件属主同组用户g增加写权限; 其他用户o 删去执行权限  

### 数字法
`chmod [数字] file`  
数字有三位, 每一位为一个八进制数, 时权限代号的数字的和, 每一位数字分别表示一个权限范围, 其顺序是u, g, o
例如: `chmod 751 file`, 即设定文件file的属性为: 给file的属主分配读、写、执行(7)的权限，给file的所在组分配读、执行(5)的权限，给其他用户分配执行(1)的权限

## VIM小技巧:

### 移动:
`Ctrl A`: Home
`Ctrl E`: End

### 查找:
在Normal模式下按`/`进入查找模式, 然后输入要查找的字符, 按`n`为Next, `N`为Previous

## bash小技巧：

### 利用.bashrc

每次重新打开bash的时候, alias都没有了, 又要source aws-alias.sh一遍
想要让这些alias一直有效, 可以把source aws-alias.sh这个命令加入到.bashrc中
对于Mac OSX, 由于terminal是一种login shel, 会执行~/.bash_profile而不是~/.bashrc
所以要让bash_profile自动取执行.bashrc, 即在其中加入[[ -s ~/.bashrc ]] && source ~/.bashrc

### upzip -q: quiet模式, 不输出文件名

## tmux:

tmux, 终端里的"窗口管理器", 相当于bash开多个窗口运行, 相当高效.
tmux操作除了输入命令, 还可以用快捷键执行, 通过默认前缀 `ctrl + b` 之后输入对应命令来操作:  

session 会话：session是一个特定的终端组合. 在bash中输入`tmux`就可以进入tmux并打开一个新的session. 

常用命令:   
* `tmux new -s name` 打开一个名为 name 的 tmux session
* `tmux attach -t name` 重新打开名为 name 的 tmux session
* `tmux switch -t name` 切换进入名为 name 的 tmux session
* `tmux list-sessions / tmux ls`列出现有的所有 session
* `tmux detach` 离开当前开启的 session
* `tmux kill-server` 关闭所有 session

常用快捷键:  
* `d` 脱离当前会话,可暂时返回Shell界面
* `s` 选择并切换会话；在同时开启了多个会话时使用
* `D` 选择要脱离的会话；在同时开启了多个会话时使用

window 窗口：session 中可以有不同的 window（但是同时只能看到一个 window）  

常用命令:  
* `tmux new-window` 创建一个新的 window
* `tmux list-windows` 列出session中所有window
* `tmux select-window -t :0-9` 根据索引0-9转到该 window
* `tmux rename-window` 重命名当前 window

常用快捷键:
* `c` 创建新窗口
* `&` 关闭当前窗口
* `[0-9]` 数字键切换到指定窗口
* `p` 切换至上一窗口(previous window)
* `n` 切换至下一窗口(last window)
* `l` 前后窗口间互相切换(last window)
* `w` 通过窗口列表切换窗口

pane 面板：window 中可以有不同的 pane（可以把 window 分成不同的部分）  

常用命令:
* `tmux split-window` 将 window 垂直划分为两个 pane
* `tmux split-window -h` 将 window 水平划分为两个 pane
* `tmux swap-pane -[UDLR]` 与指定方向的pane交换
* `tmux select-pane -[UDLR]` 选择指定方向上的下一个 pane

常用快捷键:
* `"` 将当前面板上下分屏
* `%` 将当前面板左右分屏
* `x` 关闭当前分屏
* `!` 将当前面板置于新窗口,即新建一个窗口,其中仅包含当前面板
* `ctrl+方向键` 以1个单元格为单位移动边缘以调整当前面板大小
* `alt+方向键` 以5个单元格为单位移动边缘以调整当前面板大小
* `q` 显示面板编号
* `o` 选择当前窗口中下一个面板





## Linux下如果通过硬盘的一部分容量来给实例内存增加空间(add swap or paging space to the instance)  
```
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo chmod 600 /var/swap.1
sudo /sbin/swapon /var/swap.1
```
1024表示1GB, 要增大的话改变数字即可. 注意, 这一部分比正常内存要慢得多, 重启后会还原.  
要想改为默认设置, 即重启后也有效, 在`/etc/fstab`中加入这一句(不推荐)
```
/var/swap.1   swap    swap    defaults        0   0
```
