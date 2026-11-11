## Intro

```bash
├── CR.md
├── README.md
├── run.sh
├── install_spark.sh
├── bin
├── build.sbt
├── project
│   ├── plugins.sbt
│   ├── project
│   └── target
├── src
│   ├── main
│   └── test
└── target
    ├── resolution-cache
    ├── scala-2.10
    └── streams
```

## How to install Apache Spark and its env ?

with this script it will download a list of programme and put the schema in the $PATH

* Java 1.8
* Scala 2.10.6
* SBT
* Apache Spark 1.6.1

```bash
bash install_spark.sh
```

## How to execute the application Spark ?

```bash
bash run.sh

## HDFS
vagrant ssh c6401
su hdfs
hdfs dfs -mkdir /user/vagrant
hadoop fs -chown -R vagrant /user/vagrant
```
![](./img/1.png)
![](./img/2.png)
![](./img/3.png)

## Sponsor

<a href="https://voilapro.app/?ref=github-spark-abd"><img src="voila-banner.png" alt="Voilà Pro" width="500"/></a>

This project is sponsored by [Voilà Pro](https://voilapro.app/?ref=github-spark-abd) — voice typing for macOS. Hold a key, speak, and the text lands at your cursor, in any mix of languages.
