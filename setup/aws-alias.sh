echo aws-alias loaded

export microId='i-0962b3128935da2ab'
alias micro-ssh='ssh -i "~/.ssh/aws-key-micro-ai.pem" ubuntu@ec2-34-214-81-120.us-west-2.compute.amazonaws.com'
alias micro-get='echo $microId'
alias micro-ip='export microIp=`aws ec2 describe-instances --filters "Name=instance-id,Values=$microId" --query "Reservations[0].Instances[0].PublicIpAddress"` && echo $microIp'
alias micro-start='aws ec2 start-instances --instance-ids $microId && aws ec2 wait instance-running --instance-ids $microId && export microIP=`aws ec2 describe-instances --filters "Name=instance-id,Values=$microId" --query "Reservations[0].Instances[0].PublicIpAddress"` && echo $microIp'
alias micro-stop='aws ec2 stop-instances --instance-ids $microId'
alias micro-state='aws ec2 describe-instances --instance-ids $microId --query "Reservations[0].Instances[0].State.Name"'

micro-upload() {
	scp -i ~/.ssh/aws-key-micro-ai.pem "$1" ubuntu@ec2-34-214-81-120.us-west-2.compute.amazonaws.com:~/upload/"$2"
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
    alias aws-nb='cygstart http://$microIp:8888'
fi

if [[ `uname` == *"Linux"* ]]
then
    # This is linux.  Use xdg-open to open the notebook
    alias aws-nb='xdg-open http://$microIp:8888'
fi

if [[ `uname` == *"Darwin"* ]]
then
    # This is Mac.  Use open to open the notebook
    alias aws-nb='open http://$microIp:8888'
fi