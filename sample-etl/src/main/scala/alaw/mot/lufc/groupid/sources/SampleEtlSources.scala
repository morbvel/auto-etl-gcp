package alaw.mot.lufc.groupid.sources

import org.apache.spark.sql.DataFrame
import org.apache.spark.sql.functions.{col, lit, regexp_extract, substring}
import org.apache.spark.sql.types.{DoubleType, IntegerType}

object SampleEtlSources {

  val pattern = "\\(([0-9]*?)\\)"

  def getFilteredMovies(movies: DataFrame): DataFrame = {
    val yearToInt = movies
      .withColumn("year",
        lit(substring(regexp_extract(col("title"), pattern, 0), 2, 4)).cast(IntegerType)
      )

    yearToInt.filter(col("year").isNotNull)
  }

  def getFilteredTags(tags: DataFrame): DataFrame = tags
    .filter(col("userId").isNotNull).dropDuplicates("movieId")

  def getFilteredRatings(ratings: DataFrame): DataFrame = ratings
    .withColumn("rating", col("rating").cast(DoubleType))
    .filter(col("userId").isNotNull || col("rating").isNotNull)
}
