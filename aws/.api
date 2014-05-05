DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export EC2_HOME="${DIR}/ec2-api-tools-1.6.13.0"
BIN=$EC2_HOME/bin
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
# load private key from rootkey.csv
export AWS_ACCESS_KEY=$(awk -F '=' '/AWSAccessKey/ {print $2}' ${DIR}/rootkey.csv)
export AWS_SECRET_KEY=$(awk -F '=' '/AWSSecretKey/ {print $2}' ${DIR}/rootkey.csv)
