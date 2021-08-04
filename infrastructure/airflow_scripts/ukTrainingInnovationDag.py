from datetime import timedelta
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago

#dags_folder = os.environ.get('DAGS_FOLDER', '/home/airflow/gcs/dags')

launchClusterScript = 'gsutil -m cp gs://datalake-scripts/cluster_scripts/createCluster.sh /home/airflow/gcs/dags &&' \
    'chmod -R 777 /home/airflow/gcs/dags && ' \
    '/home/airflow/gcs/dags/createCluster.sh '

removeClusterScript = 'gsutil -m cp gs://datalake-scripts/cluster_scripts/removeCluster.sh /home/airflow/gcs/dags &&' \
    'chmod -R 777 /home/airflow/gcs/dags && ' \
    '/home/airflow/gcs/dags/removeCluster.sh '

launchJobScript = 'gsutil -m cp gs://datalake-scripts/launch_jobs/MainLogicJob.sh /home/airflow/gcs/dags &&' \
    'chmod -R 777 /home/airflow/gcs/dags && ' \
    '/home/airflow/gcs/dags/MainLogicJob.sh '

launchBigqueryScript = 'gsutil -m cp gs://datalake-scripts/launch_jobs/BigQueryHive.sh /home/airflow/gcs/dags &&' \
    'chmod -R 777 /home/airflow/gcs/dags && ' \
    '/home/airflow/gcs/dags/BigQueryHive.sh '


default_args = {
    'owner': 'Airflow',
    'depends_on_past': True,
    'start_date': days_ago(0),
    'email': ['morbanan@everis.com'],
    'email_on_failure': True,
    'email_on_retry': True,
    'retries': 2,
    'retry_delay': timedelta(seconds=15),
}
dag = DAG(
    'uk_training_innovation_dag',
    default_args=default_args,
    description='UK POC DAG'
)



launchCluster = BashOperator(
    task_id='LaunchCluster',
    bash_command=launchClusterScript,
    dag=dag
)

launchJob = BashOperator(
    task_id='MainLogicJob',
    bash_command=launchJobScript,
    retries=1,
    dag=dag
)

copyBigquery = BashOperator(
    task_id='HiveToBigQuery',
    bash_command=launchBigqueryScript,
    retries=1,
    dag=dag
)

removeCluster = BashOperator(
    task_id='RemoveCluster',
    bash_command=removeClusterScript,
    retries=1,
    dag=dag
)

launchCluster >> launchJob >> copyBigquery >> removeCluster
