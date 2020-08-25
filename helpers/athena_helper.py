"""
----------------------------------------------------------------------------------------------------------
Description:

usage: Athena Helper Methods

Author  : Adil Qayyum
Release : 1

Modification Log:

How to execute:
-----------------------------------------------------------------------------------------------------------
Date                Author              Story               Description
-----------------------------------------------------------------------------------------------------------
05/7/2019         Adil Qayyum                              Initial draft.
-----------------------------------------------------------------------------------------------------------
"""


import io
import boto3
from utility.utility_helper import *
import pandas as pd

utility=UtilityHelper()
log = utility.logger("Athena")


class AthenaHelper:



    def __init__(self):
        self.s3 = boto3.resource('s3')
        self.s3_client = boto3.client('s3')
        self.athena_client = boto3.client('athena')



    def exec_query_athena(self, query, bucket, output_location):
        """
        Execute query on Athena.
        :param query: The query to be executed.
        :param bucket: The bucket where results are to be placed.
        :param output_location: The S3 path where the results are to be placed.
        """
        response = self.athena_client.start_query_execution(
            QueryString=query,
            ResultConfiguration={
                'OutputLocation': output_location
            }
        )

        execution_id = response['QueryExecutionId']
        result = self.athena_client.get_query_execution(QueryExecutionId=execution_id)
        output_key = (result['QueryExecution']['ResultConfiguration']['OutputLocation']).split('s3://' + bucket + '/')

        while result['QueryExecution']['Status']['State'] == 'RUNNING':
            result = self.athena_client.get_query_execution(QueryExecutionId=execution_id)

        try:
            obj = self.s3_client.get_object(Bucket=bucket, Key=output_key[1])
            df = pd.read_csv(io.BytesIO(obj['Body'].read()))

            # File cleansing on S3
            self.s3_client.delete_object(Bucket=bucket, Key=output_key[1])
            self.s3_client.delete_object(Bucket=bucket, Key=output_key[1] + '.metadata')

        except Exception as e:
            df = pd.DataFrame()
            df = df.fillna(0)


        return df