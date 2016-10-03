#!/bin/bash

USER=qfdk
HOST=esir-abd-li-maiga

JAR_NAME=spark-self-cibtained-project_2.10-1.0.0.jar
PROJECT_PATH=/private/student/9/79/15004879/workspace/abd
CLUSTER_PATH=/home/qfdk/abd
CONF_PATH=ml.conf

function assembly(){
    cd  $PROJECT_PATH
    echo -e "\e[1;34m[info]\e[0m=======Clean project========="
    /private/student/9/79/15004879/local/sbt/bin/sbt clean
    echo -e "\e[1;34m[info]\e[0m=======Assembly project======"
    /private/student/9/79/15004879/local/sbt/bin/sbt package
    echo -e "\e[1;34m[info]\e[0m=======Move jar to root======"
    mv $PROJECT_PATH/target/scala-2.10/$JAR_NAME ~
    echo -e "\e[1;34m[info]\e[0m Good job,BigJar done!"
    sleep 5
}

function deploy()
{
  #  ssh -t $USER@$HOST  "rm $CLUSTER_PATH/*"
    scp ~/$JAR_NAME $USER@$HOST:$CLUSTER_PATH/
  #  scp $PROJECT_PATH/conf/$CONF_PATH $USER@$HOST:$CLUSTER_PATH/
    echo -e "\e[1;34m[info]\e[0m=======Deploy done !========="
    sleep 2
}

function run()
{
    echo -e "\e[1;34m[info]\e[0m=======Standlond MODE=========="
    ssh -i $KEY $USER@$HOST "spark-submit --class Simple --num-executors 2 --executor-cores 5  $CLUSTER_PATH/$JAR_NAME"
}



## main

if [[ $# -eq "0" ]]; then
  assembly&&deploy&&run
fi
