echo aws-alias loaded

export fastId='i-0962b3128935da2ab'
alias fast-ssh='ssh -i "~/.ssh/aws-key-fast-ai.pem" ubuntu@ec2-34-214-81-120.us-west-2.compute.amazonaws.com'
alias fast-get='echo $fastId'
alias fast-ip='export fastIp=`aws ec2 describe-instances --filters "Name=instance-id,Values=$fastId" --query "Reservations[0].Instances[0].PublicIpAddress"` && echo $fastIp'
alias fast-start='aws ec2 start-instances --instance-ids $fastId && aws ec2 wait instance-running --instance-ids $fastId && export fastIP=`aws ec2 describe-instances --filters "Name=instance-id,Values=$fastId" --query "Reservations[0].Instances[0].PublicIpAddress"` && echo $fastIp'
alias fast-stop='aws ec2 stop-instances --instance-ids $fastId'
alias fast-state='aws ec2 describe-instances --instance-ids $fastId --query "Reservations[0].Instances[0].State.Name"'

fast-upload() {
	scp -i ~/.ssh/aws-key-fast-ai.pem "$1" ubuntu@ec2-34-214-81-120.us-west-2.compute.amazonaws.com:~/upload/"$2"
}

export xlargeId='i-09a7a661a05f5cce9'
alias xlarge-ssh='ssh -i "~/.ssh/aws-key-fast-large.pem" ubuntu@ec2-35-165-223-67.us-west-2.compute.amazonaws.com'
alias xlarge-get='echo $xlargeId'
alias xlarge-ip='export xlargeIp=`aws ec2 describe-instances --filters "Name=instance-id,Values=$xlargeId" --query "Reservations[0].Instances[0].PublicIpAddress"` && echo $xlargeIp'
alias xlarge-start='aws ec2 start-instances --instance-ids $xlargeId && aws ec2 wait instance-running --instance-ids $xlargeId && export xlargeIP=`aws ec2 describe-instances --filters "Name=instance-id,Values=$xlargeId" --query "Reservations[0].Instances[0].PublicIpAddress"` && echo $xlargeIp'
alias xlarge-stop='aws ec2 stop-instances --instance-ids $xlargeId'
alias xlarge-state='aws ec2 describe-instances --instance-ids $xlargeId --query "Reservations[0].Instances[0].State.Name"'

xlarge-upload() {
	scp -i ~/.ssh/aws-key-xlarge-ai.pem "$1" ubuntu@ec2-34-214-81-120.us-west-2.compute.amazonaws.com:~/upload/"$2"
}

export huxhuId='i-0da06dc6ad1cfa17e'
alias huxhu-ssh='ssh -i ~/.ssh/aws-key-huxhu-tech.pem ec2-user@ec2-34-216-5-46.us-west-2.compute.amazonaws.com'
alias huxhu-get='echo $huxhuId'
alias huxhu-ip='export huxhuIp=`aws ec2 describe-instances --filters "Name=instance-id,Values=$huxhuId" --query "Reservations[0].Instances[0].PublicIpAddress"` && echo $huxhuIp'
alias huxhu-start='aws ec2 start-instances --instance-ids $huxhuId && aws ec2 wait instance-running --instance-ids $huxhuId && export huxhuIp=`aws ec2 describe-instances --filters "Name=instance-id,Values=$huxhuId" --query "Reservations[0].Instances[0].PublicIpAddress"` && echo $huxhuIp'
alias huxhu-stop='aws ec2 stop-instances --instance-ids $huxhuId'
alias huxhu-state='aws ec2 describe-instances --instance-ids $huxhuId --query "Reservations[0].Instances[0].State.Name"'

huxhu-upload() {
	scp -i ~/.ssh/aws-key-huxhu-tech.pem "$1" ec2-user@ec2-34-216-5-46.us-west-2.compute.amazonaws.com:~/upload/"$2"
}

if [[ `uname` == *"CYGWIN"* ]]
then
    # This is cygwin.  Use cygstart to open the notebook
    alias aws-nb='cygstart http://$fastIp:8888'
fi

if [[ `uname` == *"Linux"* ]]
then
    # This is linux.  Use xdg-open to open the notebook
    alias aws-nb='xdg-open http://$fastIp:8888'
fi

if [[ `uname` == *"Darwin"* ]]
then
    # This is Mac.  Use open to open the notebook
    alias aws-nb='open http://$fastIp:8888'
fi