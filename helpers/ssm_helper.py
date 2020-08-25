"""
----------------------------------------------------------------------------------------------------------
Description:

usage: SSM Helper Methods

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
import json
from utility.utility_helper import *
utility=UtilityHelper()
log = utility. logger("SSM")

class SSMHelper:



    def __init__(self):
        self.ssm_client = boto3.client('ssm')


    #method to get aws ssm parameter
    def get_ssm_parameter_value(self,parameter_name):
        """
        Get parameter from aws ssm parameter store
        :param parameterName:Parameter name to be fetched
        :return: Parameter value
        """

        try:
            parameter = self.ssm_client.get_parameter(Name=parameter_name, WithDecryption=True)
            value = parameter['Parameter']['Value']
            return value
        except Exception as ex:
            print('Failed to fetch parameter from AWS SSM parameter store')


    #method to get aws ssm parameter
    def get_ssm_parameter_response(self,parameter_name):
        """
        Get parameter from aws ssm parameter store
        :param parameterName:Parameter name to be fetched
        :return: Parameter value
        """

        try:
            parameter = self.ssm_client.get_parameter(Name=parameter_name, WithDecryption=True)
            response = parameter['Parameter']['Value']
            data = json.loads(response)
            return data
        except Exception as ex:
            log.error('Failed to fetch parameter from AWS SSM parameter store\n' + str(ex))