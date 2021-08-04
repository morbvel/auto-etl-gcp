package alaw.mot.lufc.groupid

import alaw.mot.lufc.groupid.sources.SampleEtlSources
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.sql.{Row, SparkSession}
import org.junit.runner.RunWith
import org.scalatest.FlatSpec
import org.scalatest.junit.JUnitRunner

case class getFilteredMovies(title: String)
case class joinDataframesMovies(movieId: String, title: String, genres: String)
case class joinDataframesTags(userId: String, movieId: String, tag: String, timestamp: String)
case class joinDataframesRatings(userId: String, movieId: String, rating: String, timestamp: String)

@RunWith(classOf[JUnitRunner])
class SampleEtlSourcesTest extends FlatSpec{

  val conf:SparkConf = new SparkConf().setAppName("SampleEtlSourcesTest").setMaster("local")
  val sc:SparkContext = new SparkContext(conf)
  val sqlContext: SparkSession = new org.apache.spark.sql.SQLContext(sc)

  import sqlContext.implicits._

  "getFilteredMovies" should "return a new year colum" in {

    val inputDf = List(
      getFilteredMovies("Toy Story (1995)"),
      getFilteredMovies("My Crazy Life (Mi vida loca) (1993)"),
      getFilteredMovies("The Eleventh Victim (2012)"),
      getFilteredMovies("The Eleventh Victim 8 (2012)"),
      getFilteredMovies("The Eleventh Victim 8")
    ).toDF()

    val expectedResults = Set(
      Row("Toy Story (1995)", 1995),
      Row("My Crazy Life (Mi vida loca) (1993)", 1993),
      Row("The Eleventh Victim (2012)", 2012),
      Row("The Eleventh Victim 8 (2012)", 2012)
    )

    val results = SampleEtlSources.getFilteredMovies(inputDf)

    assert(results.count == expectedResults.size)
    assert(results.collect().toSet == expectedResults)
  }

  "joinDataframes" should "return the correct values for the function" in {

    val movies = List(
      joinDataframesMovies("1", "Sample_1", "genres_1")
    ).toDF()
    val tags = List(
      joinDataframesTags("1", "1", "tag_1", "timestamp")
    ).toDF()
    val ratings = List(
      joinDataframesRatings("1", "1", "5.8", "timestamp")
    ).toDF()

    val expectedResults = Set(
      Row("1", "1", "Sample_1", "genres_1", "tag_1", "5.8")
    )

    val results = SampleEtlMain.joinDataframes(movies, tags, ratings)

    assert(results.count == expectedResults.size)
    assert(results.collect().toSet == expectedResults)
  }

}
