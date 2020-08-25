"""
----------------------------------------------------------------------------------------------------------
Description:

usage: Glue Helper Methods

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
import time
from utility.utility_helper import *
utility=UtilityHelper()
log = utility.logger("Glue")

class GlueHelper:



    def __init__(self):
        self.glue_client = boto3.client('glue')

    # method to create glue database
    def create_glue_database(self, database_name):
        """
        Create database in glue.
        :param database_name:Database name which is to be created on glue.
        :return:Nothing.
        """

        try:
            log.info('Creating ' + database_name + ' database...')
            self.glue_client.create_database(
                DatabaseInput={
                    'Name': database_name
                })
            log.info(database_name + ' database has been created successfully!')
        except Exception as ex:
            log.error('Failed to create aws glue database\n' + str(ex))

    #method to delete glue database
    def delete_glue_database(self, database_name):
        """
        Delete database on aws glue.
        :param database_name: Name of the database to delete.
        :return: Nothing.
        """

        try:
            log.info('Deleting ' + database_name + ' database.')
            self.glue_client.delete_database(
                Name=database_name
            )
            log.info(database_name + ' database has been deleted successfully!')
        except Exception as ex:
            log.error('Failed to delete aws glue database\n' + str(ex))



    #method to create aws glue crawler
    def create_glue_crawler(self, crawler_name, database_name, path_s3):
        """
        Create aws glue crawler.
        :param crawler_name: Name of the crawler to be created.
        :param database_name: Name of the database to be used by crawler.
        :param path_s3: Source s3 file path to be used by crawler.
        :return: Nothing
        """

        try:
            log.info('Creating aws glue crawler..')
            response = self.glue_client.create_crawler(
                Name=crawler_name,
                Role='arn:aws:iam::915054695365:role/service-role/AWSGlueServiceRole-Testing',
                DatabaseName=database_name,
                Targets={
                    'S3Targets': [
                        {
                            'Path': path_s3

                        }
                    ]

                }
             )
            log.info('Aws glue crawler crated successfully!!')
        except Exception as ex:
            log.error('Failed to get aws glue crawler status\n' + str(ex))

    #method to start aws glue crawler
    def start_glue_crawler(self, crawler_name):
        """
        Start aws glue crawler.
        :param crawler_name: Name of the crawler which is to be started.
        :return: Nothing.
        """

        try:
            log.info('Starting aws glue crawler')
            response = self.glue_client.start_crawler(
                Name=crawler_name
            )
            log.info('AWS glue crawler started successfully!!')
        except Exception as ex:
            log.error('Failed to start aws glue crawler\n' + str(ex))


    #method to get aws glue crawler
    def get_glue_crawler(self, crawler_name):
        """

        :param crawler_name:Name of the crawler to get
        :return: Glue crawler will be returned
        """

        try:
            response = self.glue_client.get_crawler(
                Name=crawler_name
            )
            return response
        except Exception as ex:
            log.error('Failed to get glue crawler\n' + str(ex))

    #method to get aws glue crawler current state
    def get_crawler_state(self, crawler_name):
        """
        Get aws glue crawler current state.
        :param crawler_name: Name of the crawler whose state we want to get.
        :return: Crawler state
        """

        try:
            response = self.get_glue_crawler(crawler_name)
            crawler_state = response['Crawler']['State']
            return crawler_state
        except Exception as ex:
            log.error('Failed to get aws glue crawler status\n' + str(ex))


    #method to check if aws glue crawler is in ready state
    def wait_for_crawler_ready(self,crawler_name):
        """
        Wait for crawler to be in ready state.
        :param crawler_name: Name of the crawler for checking the ready state.
        :return: Nothing.
        """

        is_crawler_ready = False
        log.info('Checking if crawler is in READY state..')
        while (is_crawler_ready != True):
            time.sleep(80)
            crawler_state = self.get_crawler_state(crawler_name)
            if (crawler_state == "READY"):

                is_crawler_ready = True
        log.info('Crawler is in READY state.')


    def stop_glue_crawler(self,crawler_name):
        """
        Stop the glue crawler from current state.
        :param crawler_name: Name of the crawler to stop.
        :return: Nothing
        """

        try:
            log.info('Stopping aws glue crawler')
            response = self.glue_client.stop_crawler(
                Name=crawler_name
            )
            log.info('AWS glue crawler stopped successfully!!')
        except Exception as ex:
            log.error('Failed to stop glue crawler\n' + str(ex))


    def delete_glue_crawler(self,crawler_name):
        """
        Delete the crawler from aws glue.
        :param crawler_name: Name of the crawler to be deleted.
        :return: Nothing
        """

        try:
            self.wait_for_crawler_ready(crawler_name)
            log.info('Deleting aws glue crawler')
            response = self.glue_client.delete_crawler(
                Name=crawler_name
            )
            log.info('AWS glue crawler deleted successfully!!')
        except Exception as ex:
            log.error('Failed to delete glue crawler\n' + str(ex))




