"""
----------------------------------------------------------------------------------------------------------
Description:

usage: Oracle Helper Methods

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


import pandas as pd
import cx_Oracle
from utility.utility_helper import *

utility=UtilityHelper()

log = utility.logger("Oracle")

class OracleHelper:



    def __init__(self,host,port,service_name,user,password):
        """
        Constructor to initialize query parameter
        :param host:Host name of oracle server
        :param port:Post number of oracle server
        :param service_name: Service Name to connect oracle server
        :param user: Username to connect oracle server
        :param password: Password to connect oracle server
        """
        try:
            self.dsn_tns = cx_Oracle.makedsn(host, port, service_name=service_name)
            self.connection = cx_Oracle.connect(user=r'' + user + '', password=password, encoding='utf8', dsn=self.dsn_tns)
        except Exception as e:
            raise Exception("Couldn't create oracle connection")

    #method to execute query on oracle database
    def oracle_execute_query(self,query):
        """
        Execute specified query on oracle
        :param query:Query to be executed on oracle
        :return:Data frame
        """

        try:
            connection = self.connection
            df = pd.read_sql_query(query, connection)
            return df
        except Exception as ex:
            log.error('Reading data from oracle database failed\n'+str(ex))



