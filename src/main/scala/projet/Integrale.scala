/* SimpleApp.scala */
package projet

import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf

object Integrale {
	def main(args: Array[String]) {
		val conf = new SparkConf().setAppName("Integrale")
				val sc = new SparkContext(conf)

		val min = 1
		val max = 10
		val n = 10
		
		val inteApproche = calcule(min, max, n, sc);
		
		
		// Calcul of difference beetwen exact and calculated
		val inteExacte = Math.log(max)-Math.log(min)
		val diff = Math.abs(inteApproche-inteExacte)
		
		println("Valeur approché ==> "+inteApproche + " valeur exacte ===> "+inteExacte + " difference ==>"+diff)
		
	}

	def calcule(min:Int,max:Int,slice:Int,sc:SparkContext):Double={

			val pas=(max-min)*1.0/slice 

					val inte = sc.parallelize(1 until slice).map { 
			  i =>	pas*1.0/(min+i*pas);
			}.reduce(_+_)

			inte
	}
}