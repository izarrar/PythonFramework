"""
----------------------------------------------------------------------------------------------------------
Description:

usage: Utility Helper Methods

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

import json
import pandas as pd
import logging
import colorlog
from pathlib import Path
import numpy as np



class UtilityHelper:

    def __init__(self):
        self.log =self.logger("Utility")


    #method to get json file
    def  get_json(self,file_path):

        """
        Get json file from specified path
        :param filePath:File path of json which is to be fetched
        :return:Data of json file
        """

        try:

            # creating object to get json data
            data = json.load(open(file_path))

            return data
        except Exception as ex:
            self.log.error('Failed to load json.\n'+str(ex))


    # method to export data frame to CSV file
    def export_to_csv(self, csv_file_path, data_frame):
        """
        Export data frame to csv file
        :param csv_file_path:Path where csv file is to be exported.
        :param data_frame:Data frame which is to be exported in csv file.
        :return:Nothing.
        """

        try:
            self.log.info('Exporting data to csv file...')
            data_frame.to_csv(csv_file_path,index=False)
            self.log.info('Data has been exported to csv file successfully!')
        except Exception as ex:
            self.log.error('Exporting data to csv file failed.\n' + str(ex))



    #method to export data frame to parquet file
    def export_to_parquet(self,parquet_file_path, data_frame):
        """
        Export data frame to parquet file
        :param parquet_file_path:Path where parquet file is to be exported.
        :param data_frame:Data frame which is to be exported in parquet file.
        :return:Nothing.
        """

        try:
            self.log.info('\nExporting data to parquet file...')
            data_frame.to_parquet(parquet_file_path, engine='auto', compression=None,index=False)
            self.log.info('Data has been exported to parquet file successfully!')
        except Exception as ex:
            self.log.error('Exporting data to parquet file failed.\n' + str(ex))



    #method to read CSV file returns dataframe
    def csv_read_as_data_frame(self,csv_file_path):
        """
        Read csv file as data frame
        :param csv_file_path:File path of csv file which is to be read.
        :return:Data frame
        """

        try:
            self.log.info("\nReading csv file...")
            file_data = pd.read_csv(csv_file_path)
            data_frame = pd.DataFrame(file_data)
            return data_frame
        except Exception as ex:
            self.log.error('Reading data from csv file failed.\n' + str(ex))

    #method to read parquet file returns dataframe
    def parquet_as_data_frame(self, parquet_file_path):
        """
        Read parquet file as data frame
        :param parquet_file_path:File path of parquet file which is to be read.
        :return:Data frame.
        """

        try:
            self.log.info("\nReading parquet file...")
            file_data = pd.read_parquet(parquet_file_path, engine='auto')
            data_frame = pd.DataFrame(file_data)
            return data_frame
        except Exception as ex:
            self.log.error('Reading data from parquet file failed.\n' + str(ex))


    def logger(self,dunder_name) -> logging.Logger:

        log_format = (
            '%(asctime)s - '
            '%(name)s - '
            '%(message)s'
        )
        bold_seq = '\033[1m'
        colorlog_format = (
            f'{bold_seq} '
            '%(log_color)s '
            f'{log_format}'
        )
        colorlog.basicConfig(format=colorlog_format)
        logger = logging.getLogger(dunder_name)
        logger.setLevel(logging.INFO)

        return logger

    #Get path of root of the project.
    def get_project_root(self) -> Path:
        """
        Get path of root of the project.
        Returns path of root of the project .
        """
        return Path(__file__).parent.parent

    #Get path of the resources which is to be accessed.
    def path_finder(self,resource_path):
        """
        Get path of the resources which is to be accessed.
        :param resource_path:Path of the resources which is to be accessed.
        :return: Call and OS independent path of the resource
        """
        rootdir=str(self.get_project_root())
        path=str(Path(rootdir+"\\"+resource_path))
        return path

    #Sort data frames on basis of all columns.
    def sort_all_columns_dataframe(self,df):
        """
        Sort data frames on basis of all columns.
        :param df:Data frame which is to be sorted.
        :return: Sorted data frame.
        """
        df = df.sort_values(by=df.columns.tolist()).reset_index(drop=True)
        return df

    def data_frame_date_columns_formater(self,df):
        column_names = list(df.columns.values)
        date_list = 'DATE'
        res = [i for i in column_names if date_list in i]

        if (res != []):
            for item in res:
                # temporary solution yet to be tested.
                df[item] = pd.to_datetime(df[item], errors='coerce')
                df[item] = df[item].astype('datetime64[ns]')
                df[item] = df[item].dt.strftime('%m/%d/%y')


        return df

    def data_frame_date_nan_formater(self,df):

        df=df.where((pd.notnull(df)), None)

        return df

    def data_frame_bool_column_caster(self, df):
        g = df.columns.to_series().groupby(df.dtypes).groups
        column_datatypes = {k.name: v for k, v in g.items()}
        try:
            bool_types = column_datatypes['bool']
            bool_columns = []
            for item in range(len(bool_types)):
                bool_columns.append(bool_types[item])

            if (bool_columns != []):
                for item in bool_columns:
                    df[item] = df[item].astype(str)

            return df
        except Exception as ex:
            return df


    def drop_proceesed_data_frame_columns(self,df):
        df_table = df.drop(['RECORDINSERTEDTIMESTAMP', 'ROWGUID'], axis=1)
        return df_table

    def dataframe_datatype_caster(self, df):
        """
        Data frame data type caster
        :param self:
        :param df: Dataframe for changing the type.
        :return: dataframe
        """
        df = df.astype(str)
        return df



    def dataframe_match_dataTypes(self, df, df1):
        """
         Source & Target data frame data types matcher & converting data types of  bool columns to string in both data frame's
        :param self:
        :param df: Target data frame for changing the type.
        :param df1: Source data frame for changing the type.
        :return: Target data frame
        """

        for x in df1.columns:
            if x in df.columns.tolist():
                if df1[x].dtypes.name == 'bool':
                    df[x] = df[x].astype(str)
                    df1[x] = df1[x].astype(str)
                else:
                    df[x] = df[x].astype(df1[x].dtypes.name)
        return [df, df1]




    def format_data_frames(self,df):
        df.columns = df.columns.str.upper()

        df = self.data_frame_date_nan_formater(df)

        df = self.data_frame_date_columns_formater(df)

        # df = self.dataframe_datatype_caster(df)

        # df = self.sort_all_columns_dataframe(df)

        return df