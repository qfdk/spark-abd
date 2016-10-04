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
    // cut number
    val n = 100000

    val inteApproche = calcule(min, max, n, sc);

    // {\begin{matrix}\int {\frac  {1}{x}}\,{\mathrm  {d}}x=\ln \left|x\right|+C\end{matrix}};
    // Calcul of difference beetwen exact and calculated
    val inteExacte = Math.log(Math.abs(max)) - Math.log(Math.abs(min))
    val diff = Math.abs(inteApproche - inteExacte)

    println("Valeur approché ==> " + inteApproche)
    println("Valeur exacte ===> " + inteExacte)
    println("Difference ==>" + diff)

  }

  def calcule(min: Int, max: Int, nbPart: Int, sc: SparkContext): Double = {

    val pas = (max - min) * 1.0 / nbPart

    val inte = sc.parallelize(1 until nbPart).map {
      i => pas * 1.0 / (min + i * pas);
    }.reduce(_ + _)

    inte
  }
}