#!/bin/bash

USER=vagrant
HOST=c6401
KEY=/Users/qfdk/ambari-vagrant/centos6.4/insecure_private_key
JAR_NAME=spark-self-cibtained-project_2.10-1.0.0.jar
#PROJECT_PATH=/private/student/9/79/15004879/workspace/spark-abd
PROJECT_PATH=/Users/qfdk/GitHub/spark-abd
CLUSTER_PATH=/home/$USER/abd

#SPARK_HOME=/usr/local/spark-1.6.1-bin-hadoop2.6/bin
#CONF_PATH=ml.conf
echo -e "[info] \033[1;34m Number of sclice ? \033[0m"
read SLICE

function assembly(){
    cd  $PROJECT_PATH
    echo -e "\033[1;34m[info]\033[0m=======Clean project========="
    sbt clean
    echo -e "\033[1;34m[info]\033[0m=======Assembly project======"
    sbt package
    echo -e "\033[1;34m[info]\033[0m=======Move jar to root======"
    mv $PROJECT_PATH/target/scala-2.10/$JAR_NAME ~
    echo -e "\033[1;34m[info]\033[0m Good job,BigJar done!"
    sleep 5
}

function deploy()
{
  #  ssh -t $USER@$HOST  "rm $CLUSTER_PATH/*"
    scp -i $KEY ~/$JAR_NAME $USER@$HOST:$CLUSTER_PATH/
  #  scp $PROJECT_PATH/conf/$CONF_PATH $USER@$HOST:$CLUSTER_PATH/
    echo -e "\033[1;34m[info]\033[0m=======Deploy done !========="
    sleep 2
}

function run()
{
    echo -e "\033[1;34m[info]\033[0m=======Cluster MODE=========="
    ssh -i $KEY $USER@$HOST "spark-submit --master yarn-cluster --class projet.Bigram --executor-cores 2 --conf spark.default.parallelism=$SLICE  $CLUSTER_PATH/$JAR_NAME"
}

function local() {
  sbt clean
  sbt package
  spark-submit --class projet.Bigram --num-executors 2 --executor-cores 5 ./target/scala-2.10/$JAR_NAME
}


## main
assembly&&deploy&&run
#local
