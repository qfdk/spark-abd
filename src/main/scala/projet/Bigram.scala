package projet
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf

object Bigram {

  def main(args: Array[String]) {
    val conf = new SparkConf().setAppName("Bigram")
    val sc = new SparkContext(conf)
    //val file = sc.textFile("./../spark-abd/data/readme.txt")
    val file = sc.textFile("hdfs://c6401.ambari.apache.org:8020/user/vagrant/readme.txt")
    file.map {
      _.split('.').map { substrings =>
        substrings.trim.split(' ').
          map { _.replaceAll("""\W""", "").toLowerCase() }.
          sliding(2)
      }.
        flatMap { identity }.map { _.mkString("%") }.
        groupBy { identity }.mapValues { _.size }
    }.
      flatMap { identity }.reduceByKey(_ + _).collect.
      foreach { x => println(x._1 + ", " + x._2) }
  }
}