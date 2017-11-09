# Tips - 一些学习时掌握的小技巧

## bash小技巧：利用.bashrc使得bash每次打开是自动执行操作
每次重新打开bash的时候，alias都没有了，又要source aws-alias.sh一遍
想要让这些alias一直有效，可以把source aws-alias.sh这个命令加入到.bashrc中
对于Mac OSX，由于terminal是一种login shel，会执行~/.bash_profile而不是~/.bashrc
所以要让bash_profile自动取执行.bashrc，即在其中加入[[ -s ~/.bashrc ]] && source ~/.bashrc


## tmux:

tmux, 终端里的"窗口管理器", 相当于bash开多个窗口运行, 相当高效

session 会话：session是一个特定的终端组合。输入tmux就可以打开一个新的session

window 窗口：session 中可以有不同的 window（但是同时只能看到一个 window）

pane 面板：window 中可以有不同的 pane（可以把 window 分成不同的部分）

## upzip -q: quiet模式, 不输出文件名