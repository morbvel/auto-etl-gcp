DROP TABLE IF EXISTS uk_training_innovation.movies;
CREATE EXTERNAL TABLE uk_training_innovation.movies
(
  movieId STRING,
  title STRING,
  genres STRING
)
COMMENT 'row data csv'
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
'field.delim'='\,',
'serialization.format'='\,'
)
STORED AS INPUTFORMAT
'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location 'gs://datalake-warehouse/movies/';

----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

DROP TABLE IF EXISTS uk_training_innovation.ratings;
CREATE EXTERNAL TABLE uk_training_innovation.ratings
(
  userId STRING,
  movieId STRING,
  rating STRING,
  `timestamp` STRING
)
COMMENT 'row data csv'
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
'field.delim'='\,',
'serialization.format'='\,'
)
STORED AS INPUTFORMAT
'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location 'gs://datalake-warehouse/ratings/';

----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

DROP TABLE IF EXISTS uk_training_innovation.tags;
CREATE EXTERNAL TABLE uk_training_innovation.tags
(
  userId STRING,
  movieId STRING,
  tag STRING,
  `timestamp` STRING
)
COMMENT 'row data csv'
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
'field.delim'='\,',
'serialization.format'='\,'
)
STORED AS INPUTFORMAT
'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location 'gs://datalake-warehouse/tags/';

----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

DROP TABLE IF EXISTS uk_training_innovation.final_table_poc;
CREATE EXTERNAL TABLE uk_training_innovation.final_table_poc
(
  movieId STRING,
  userId STRING,
  title STRING,
  genres STRING,
  year INTEGER,
  tag STRING,
  rating INTEGER
)
COMMENT 'row data csv'
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
'field.delim'='\,',
'serialization.format'='\,'
)
STORED AS INPUTFORMAT
'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location 'gs://datalake-warehouse/final_result/';
