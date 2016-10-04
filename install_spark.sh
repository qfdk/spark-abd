#!/bin/bash

sudo apt-get install wget

## install java
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update
sudo apt-get install oracle-java8-installer

### install sbt
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
sudo apt-get update
sudo apt-get install sbt

### install scala
wget http://www.scala-lang.org/files/archive/scala-2.10.6.deb
sudo dpkg -i scala-2.10.6.deb

### install Apache spark 1.6.1
wget http://d3kbcqa49mib13.cloudfront.net/spark-1.6.1-bin-hadoop2.6.tgz
tar zvf spark-1.6.1-bin-hadoop2.6.tgz
sudo cp -r spark-1.6.1-bin-hadoop2.6 /usr/local/
echo 'PATH=/usr/local/spark-1.6.1-bin-hadoop2.6/bin:$PATH' >> .bashrc
source .bashrc
