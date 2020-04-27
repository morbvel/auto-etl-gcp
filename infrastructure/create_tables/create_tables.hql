DROP TABLE IF EXISTS auto_etl_poc.alternate_purchase;
CREATE EXTERNAL TABLE auto_etl_poc.alternate_purchase
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
location 'gs://datalake-inputs/movies/';
