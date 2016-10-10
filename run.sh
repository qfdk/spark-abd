#!/bin/bash

USER=qfdk
HOST=esir-abd-li-maiga

JAR_NAME=spark-self-cibtained-project_2.10-1.0.0.jar
PROJECT_PATH=/private/student/9/79/15004879/workspace/spark-abd
CLUSTER_PATH=/home/$USER/abd
SPARK_HOME=/usr/local/spark-1.6.1-bin-hadoop2.6/bin
#CONF_PATH=ml.conf
echo -e "[info]\e[1;34m Number of sclice ? \e[0m"
read SLICE

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
    ssh $USER@$HOST "$SPARK_HOME/spark-submit --class projet.Bigram --executor-cores 5 --conf spark.default.parallelism=$SLICE  $CLUSTER_PATH/$JAR_NAME"
}

function local() {
  sbt clean
  sbt package
  spark-submit --class projet.Bigram --num-executors 2 --executor-cores 5 ./target/scala-2.10/$JAR_NAME
}


## main
assembly&&deploy&&run
#local
