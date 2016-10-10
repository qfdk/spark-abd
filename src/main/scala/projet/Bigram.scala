package projet
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf

object Bigram {

	def main(args: Array[String]) {
		val conf = new SparkConf().setAppName("Bigram")
				val sc = new SparkContext(conf)
		val file_name = "tr_pg17489.txt"
		val file = sc.textFile("/home/qfdk/abd/" + file_name)


		val array=file.flatMap(line => line.split(" ")).collect()

		for( Array(a,b,_*) <- array.sliding(2).toArray ) 
			yield (a.toLowerCase(), b.toLowerCase())



	}
}