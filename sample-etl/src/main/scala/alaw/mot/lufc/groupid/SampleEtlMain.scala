package alaw.mot.lufc.groupid

import alaw.mot.lufc.groupid.sources.SampleEtlSources
import org.apache.spark.sql.{DataFrame, SparkSession}
import org.apache.spark.sql.functions.col
import org.apache.spark.sql.types.IntegerType

object SampleEtlMain extends App {

  val spark: SparkSession = SparkSession.builder().enableHiveSupport().getOrCreate()

  val rawMovies = spark.table("uk_training_innovation.movies")
  val rawTags = spark.table("uk_training_innovation.tags")
  val rawRatings = spark.table("uk_training_innovation.ratings")

  val moviesFiltered = SampleEtlSources.getFilteredMovies(rawMovies)
  val tagsFiltered = SampleEtlSources.getFilteredTags(rawTags)
  val ratingsFiltered = SampleEtlSources.getFilteredRatings(rawRatings)

  joinDataframes(moviesFiltered, tagsFiltered, ratingsFiltered)
    .select("movieId","userId", "title", "genres", "year", "tag", "rating")
    .dropDuplicates("movieId","userId", "title")
    .createOrReplaceTempView("final_dataframe")

  spark.sql("INSERT OVERWRITE TABLE uk_training_innovation.final_table_poc SELECT * from final_dataframe")

  def joinDataframes(movies: DataFrame, tags: DataFrame, ratings: DataFrame): DataFrame = {
    movies.
      join(
        tags,
        Seq("movieId"),
        "left_outer"
      ).drop("timestamp")
      .join(
        ratings,
        Seq("movieId", "userId"),
        "left_outer"
      ).drop("timestamp")
  }

}
