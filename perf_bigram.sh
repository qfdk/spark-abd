#!/bin/bash

USER=vagrant
HOST=c6401
KEY=/Users/qfdk/ambari-vagrant/centos6.4/insecure_private_key

echo "The number of executors: "
read numExecutors
echo "The max thread of core in each executor:"
read executorCores
echo -e "[info]\033[1;34m Loading ...\033[0m"

function run()
{
	for ((cpt_core=1;cpt_core<=$executorCores;cpt_core++));do
		for((j=0;j<5;j++));do
			echo -e "[#]===> \033[1;34m [ time: $j Thread: $cpt_core] execution\033[0m"
			for((i=1;i<=$numExecutors;i++));do
			echo -e "[info]\033[1;34m [ $i ] Mode cluster\033[0m"
			# nb=$[$i*$executorCores*2]
			cmd="spark-submit --class projet.Integrale --master yarn-cluster --num-executors $i --executor-memory 512M --executor-cores $cpt_core  ~/spark-self-cibtained-project_2.10-1.0.0.jar 536870912 >tmp 2>&1&&cat tmp|grep proxy/application_[0-9]*_[0-9]*|uniq|sed -e 's/\//\n/g'|grep application>appId"
			ssh -i $KEY $USER@$HOST $cmd
			ssh -i $KEY $USER@$HOST "cat appId>>appIdList&&rm tmp"
			## copy appId 2 local
			scp -i $KEY $USER@$HOST:~/appId .
			appId=`cat appId`
			wget http://c6402.ambari.apache.org:8088/cluster/app/$appId
			duree=`cat $appId|grep -E "([0-9]*mins, )? [0-9]*(sec)"| awk 'gsub(/^ *| *$/,"")'`
			echo "$appId,$i,$cpt_core,$duree" >> app_result.csv
			## clean list appIds
			ssh -i $KEY $USER@$HOST "rm appId"
			rm $appId
		done;
	done;
done;
}

run

scp -i $KEY $USER@$HOST:~/appIdList .