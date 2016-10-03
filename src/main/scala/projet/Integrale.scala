/* SimpleApp.scala */
package projet

import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf

object Integrale {
	def main(args: Array[String]) {
		val conf = new SparkConf().setAppName("Integrale")
				val sc = new SparkContext(conf)


	}

	def calcule(min:Int,max:Int,slice:Int,sc:SparkContext):Double={

			val pas=(max-min)*1.0/slice 

					val inte = sc.parallelize(1 until slice, 1).map { i =>
					pas*1.0/i
			}.reduce(_+_)

			inte
	}
}