#!/bin/bash

USER=vagrant
HOST=c6401
KEY=/Users/qfdk/ambari-vagrant/centos6.4/insecure_private_key
JAR_NAME=spark-self-cibtained-project_2.10-1.0.0.jar

PROJECT_PATH=/Users/qfdk/GitHub/spark-abd
CLUSTER_PATH=/home/$USER/abd

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
  scp -i $KEY "/Users/qfdk/$JAR_NAME" $USER@$HOST:$CLUSTER_PATH/
  echo -e "\033[1;34m[info]\033[0m=======Deploy done !========="
  sleep 2
}

function run()
{
  echo -e "\033[1;34m[info]\033[0m=======Cluster MODE=========="
  ssh -i $KEY $USER@$HOST "spark-submit --master yarn-cluster --class projet.Bigram --executor-cores 1 --conf spark.default.parallelism=$SLICE $CLUSTER_PATH/$JAR_NAME"
}

function local()
{
  sbt clean
  sbt package
  spark-submit --class projet.Integrale --num-executors 2 --executor-cores 2 ./target/scala-2.10/$JAR_NAME 10
}

function perf_local_Integral() {
  sbt clean
  sbt package

  resultFileName=result/result_inte_`date +'%d%m%Y_%H%M'`.csv

  echo "Prog,n,nbThread,timeDebut,timeEnd,duration" > $resultFileName
  
  
  for (( n=2;n<1000000000;n=$n*2 ))
  do
    for ((cpt=0;cpt<1;cpt++))
      do  
          for (( nbThread=1; nbThread<=16; nbThread++ ))
          do  
            debut=`date +%s`
            date +%s
            spark-submit --class projet.Integrale  --executor-cores $nbThread ./target/scala-2.10/$JAR_NAME $n
            fin=`date +%s`
            duration=$[$fin-$debut ]
            echo "Integral,$n,$nbThread,$debut,$fin,$duration" >>  $resultFileName
            echo "[INFO] n = $n , nbcore = $nbThread, duration = $duration"
          done
      done
  done
}

function perf_local_Bigram() {
  sbt clean
  sbt package

  resultFileName=result/result_bigram_`date +'%d%m%Y_%H%M'`.csv

  echo "Prog,n,nbThread,timeDebut,timeEnd,duration" > $resultFileName
  
  for ((cpt=0;cpt<5;cpt++))
  do
          for (( nbThread=1; nbThread<=5; nbThread++ ))
          do  
            debut=`date +%s`
            date +%s
            spark-submit --class projet.Bigram  --executor-cores $nbThread ./target/scala-2.10/$JAR_NAME
            fin=`date +%s`
            duration=$[$fin-$debut ]
            echo "Bigram,,$nbThread,$debut,$fin,$duration" >>  $resultFileName
          done
  done
}


## main
#assembly&&deploy&&run
#perf_local
# local
perf_local_Integral
perf_local_Bigram
