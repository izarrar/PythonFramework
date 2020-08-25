"""
----------------------------------------------------------------------------------------------------------
Description:

usage: Configuration Helper Methods

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

from configparser import ConfigParser
from pathlib import Path
from utility.utility_helper import *



utility=UtilityHelper()
log = utility.logger("Configuration")

class ConfigHelper:



    def __init__(self):
        self.utility_helper = UtilityHelper()

        # Creating objects
        params = self.config_file_reader(utility.path_finder("/resources/credentials/credentials.ini"), "parameters")

        # initializing credentials
        self.entities = params.get("entities")



    def config_file_reader(self,file_name, key_value_section):
        """
        Configuration file reader
        :param filename:Name of file from which key values are to be fetched
        :param keyvalue_section: Section of which key-value pairs are to be fetched
        :return:List of Key-Value Pairs
        """

        parser = ConfigParser(allow_no_value=True)
        parser.read(file_name)


        key_value_pair = {}
        if parser.has_section(key_value_section):
            params = parser.items(key_value_section)
            for param in params:
                key_value_pair[param[0]] = param[1]
        else:
            raise Exception('Section {0} not found in the {1} file'.format(key_value_section, file_name))

        return key_value_pair



    #method to fetch quries or csv's from paths in json return type for query is string and csv is dataframe
    def json_config_data(self, json_file_path, entity_name, file_type):
            """
            Read query or csv data from json file
            :param json_file_path:Path of json file from which data is to be read.
            :param response_type:Two types of responses BANNER|CSV
            :param entity_name:Name of entity from which data(query or csv path) is to be fetched.
            :param query_type:Two types of query query|processed
            :return:Query or Data frame
            """

            try:

                response = utility.get_json(json_file_path)
                response_type= response['entity'][entity_name.upper()]['entity_type']
                restype = response_type.upper()
                if restype == "BANNER":
                    banner_entities = response['entity'][entity_name.upper()]
                    #reading query
                    query_file = open(utility.path_finder(banner_entities[file_type]))
                    query = query_file.read()
                    entity_config_data = [restype, query]
                    return entity_config_data
                elif restype == "CSV":
                    # reading csv file
                    csv_entities = response['entity'][entity_name.upper()]
                    # file_data = pd.read_csv(utility.path_finder(csv_entities[file_type]))
                    # data_frame = pd.DataFrame(file_data)
                    query_file = open(utility.path_finder(csv_entities[file_type]))
                    query = query_file.read()
                    entity_config_data = [restype, query]
                    return entity_config_data
                else:
                    log.error('Test data parameters are not correct')
            except Exception as ex:
                    log.error('Test data parameters are not correct\n' + str(ex))


    def get_entities(self):
        """
        Read entities from config file
        :return: Entity List
        """

        entity_string_list = []

        entity_string_parts = self.entities.split(",")
        for item in entity_string_parts:
            striped_item = item.strip()
            striped_item = striped_item.strip('\"')
            striped_item = striped_item.upper()
            striped_item = striped_item.replace(' ', '')
            entity_string_list.append(striped_item)

        return entity_string_list

