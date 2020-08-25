"""
----------------------------------------------------------------------------------------------------------
Description:

usage: S3 Helper Methods

Author  : Zarrar Khan
Co Author  : Umer Malik
Release : 1

Modification Log:

How to execute:
-----------------------------------------------------------------------------------------------------------
Date                Author              Story               Description
-----------------------------------------------------------------------------------------------------------
28/11/2019         Zarrar Khan                              Initial draft.
-----------------------------------------------------------------------------------------------------------
"""


import boto3
import io
import pandas as pd
import json
from utility.utility_helper import *
utility=UtilityHelper()
log = utility. logger("S3")

class S3Helper:



    def __init__(self):
        self.s3_client = boto3.client('s3')
        self.s3_resource = boto3.resource('s3')

    # method to create s3 bucket
    def create_s3_bucket(self, bucket_name):
        """
        Create bucket on aws s3
        :param bucketname:Name by which bucket will be created on aws s3
        :return:Nothing
        """

        try:

            log.info('\nCreating bucket with the name:' + bucket_name + ' in S3...')
            self.s3_resource.create_bucket(Bucket=bucket_name)
            log.info('Bucket in S3 with the name:' + bucket_name + ' has been created successfully!')
        except Exception as ex:
            log.error('Failed to create aws s3 bucket\n' + str(ex))

    #method to upload file in s3 bucket
    def upload_file_s3(self, file_name, bucket_name, s3_upload_file_path):
        """
        Upload file on specified aws s3 bucket
        :param file_name:Path of the file which is to be uploaded on aws s3 bucket
        :param bucket_name:Name of the bucket in which file will be uploaded
        :param s3_upload_file_path:Path of aws s3 where file will be uploaded
        :return:Nothing
        """
        try:
            log.info('Required data in S3 bucket:' + bucket_name + ' is being uploaded...')
            self.s3_client.upload_file(file_name, bucket_name, s3_upload_file_path)
            log.info('Required data has been uploaded in S3 bucket:' + bucket_name + ' successfully!')
        except Exception as ex:
            log.error('Failed to upload file on aws s3 bucket\n' + str(ex))


    #method to delete all record in s3 bucket
    def delete_allrecord_s3_bucket(self,bucket_name):
        """
        Delete all record from specified aws s3 bucket
        :param bucket_name:Name of the bucket from where all record will be deleted
        :return:Nothing
        """
        try:
            log.info('Deleting all the data in S3 bucket:' + bucket_name + '.')
            bucket = self.s3_resource.Bucket(bucket_name)
            for key in bucket.objects.all():
                key.delete()
            log.info('All the data in S3 bucket:' + bucket_name + ' has been deleted successfully!')
        except Exception as ex:
            log.error('Failed to delete all record from s3 bucket\n' + str(ex))

    #method to delete s3 bucket
    def delete_s3_bucket(self, bucket_name):
        """
        Delete specified aws s3 bucket
        :param bucket_name:Name of the aws s3 bucket which is to be delete
        :return:Nothing
        """

        try:
            log.info('Deleting S3 bucket:' + bucket_name + '.')
            bucket = self.s3_resource.Bucket(bucket_name)
            bucket.delete()
            log.info('S3 bucket:' + bucket_name + ' has been deleted successfully!')
        except Exception as ex:
            log.error('Failed to delete s3 bucket\n' + str(ex))

    #method to get s3 bucket object
    def get_s3_object(self, bucket_name, s3_result_directory):
        """
        Get any object/key/file from aws s3 bucket.
        :param bucket_name:Name of the aws s3 bucket from where file is to be fetched.
        :param s3_result_directory:Path of the object/key/file which is to be fetched.
        :return:Data of file
        """

        try:
            log.info('Getting s3 object from s3 bucket..')
            response = self.s3_client.get_object(
                Bucket=bucket_name,
                Key=s3_result_directory
            )
            data=response['Body']
            return data
            log.info('S3 object fetched from s3 bucket successfully!!')
        except Exception as ex:
            log.error('Failed to get s3 object from s3 bucket\n' + str(ex))



    #method to check bucket exist
    def get_bucket_status(self, bucket):
        """
        Get bucket status.
        :param bucket: Name of the S3 bucket.
        """
        try:
            if self.s3_resource.Bucket(bucket).creation_date is not None:
                return True
            else:
                return False
        except Exception as e:
            log.error('Bucket not found', e)


    #method for getting all folders in bucket
    def get_bucket_all_folders(self, bucket):
        """
        Get all the folders from S3 bucket.
        :param bucket: Name of the S3 bucket.
        """
        if self.get_bucket_status(bucket) is True:
            try:
                bucket_obj = self.s3_resource.Bucket(bucket)
                obj_list = []
                for obj in bucket_obj.objects.all():
                    if obj.key.endswith("/"):
                        obj_list.append(obj.key)
                return obj_list
            except Exception as e:
                log.error(e)

    # Read contents from s3 file
    def read_s3_file(self, bucket, filename):
        """
        Read a file from S3 bucket
        :param bucket: Name of the S3 bucket.
        :param filename: Name of the file.
        """
        if self.get_bucket_status(bucket) is True:
            bucket_obj = self.s3_resource.Bucket(bucket)
            try:
                for obj in bucket_obj.objects.all():
                    key = obj.key
                    if filename in key:
                        if filename.endswith('.csv'):
                            obj = self.s3_client.get_object(Bucket=bucket, Key=key)
                            df = pd.read_csv(io.BytesIO(obj['Body'].read()))
                            return df
                        elif filename.endswith('.json'):
                            body = obj.get()['Body'].read()
                            body = str(body, 'utf-8').strip('b''')
                            file_body = json.loads(body)
                            return file_body
                        else:
                            body = obj.get()['Body'].read()
                            # body = str(body, 'utf-8').strip('b''')
                            return body

            except Exception as e:
                log.error(e)


    def get_metadata(self, bucket, key):
        """
        Get a file metadata S3 bucket.
        :param bucket: Name of the S3 bucket.
        :param key: Name of the file whose metadata is required.
        """
        try:
            response = (self.s3_client.list_objects(Bucket=bucket))
            meta = response.get('Contents')
            for obj in meta:
                if key in obj['Key']:
                    self.is_file = True
                    return obj

            if self.is_file is False:
                log.error("File Not Found")
        except Exception as e:
            log.error(e)


