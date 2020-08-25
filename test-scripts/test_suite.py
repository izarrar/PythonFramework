import pytest
import time
import allure


from managers.oracle_manager import OracleManager
from managers.athena_manager import AthenaManager
from helpers.config_helper import ConfigHelper
from helpers.comparison_helper import ComparisonHelper
from utility.utility_helper import UtilityHelper
from helpers.ssm_helper import SSMHelper



@allure.suite("Automation Suite")
@allure.sub_suite("Ingestion Automation")
class TestInjestionAutomation:

    ssm_helper = SSMHelper()
    comparison_helper = ComparisonHelper()
    utility = UtilityHelper()
    config_helper = ConfigHelper()
    oracle_manager = OracleManager()
    athena_manager = AthenaManager()

    Entities = config_helper.get_entities()

    qa_raw_df_name = "QA Raw"
    qa_processed_df_name = "QA Processed"
    dev_raw_df_name = "DEV Raw"
    dev_processed_df_name = "DEV Processed"


    @pytest.fixture(params=Entities, scope='class')
    def Entity(self, request):
        EntityName = request.param

        global qa_raw_query
        global qa_raw_df
        global qa_processed_query
        global qa_processed_df
        global dev_raw_query
        global dev_raw_df
        global dev_processed_query
        global dev_processed_df
        global new_qa_raw_df
        global new_qa_processed_df
        try:
            entity_json_data = self.config_helper.json_config_data(self.utility.path_finder('/resources/entity-configurations/entityConfigQA.json'), EntityName, 'raw')
            if (entity_json_data[0] == "BANNER"):
                qa_raw_query = entity_json_data[1]
                qa_raw_df = self.oracle_manager.get_qa_raw_or_procseed_dataframes(qa_raw_query)
                # oracle login here
            elif (entity_json_data[0] == "CSV"):
                qa_raw_query=entity_json_data[1]
                qa_raw_df =self.athena_manager.get_raw_or_procseed_dataframes(qa_raw_query)



            entity_json_data = self.config_helper.json_config_data(self.utility.path_finder('/resources/entity-configurations/entityConfigQA.json'),EntityName, 'processed')

            if (entity_json_data[0] == "BANNER"):
                qa_processed_query = entity_json_data[1]
                qa_processed_df = self.oracle_manager.get_qa_raw_or_procseed_dataframes(qa_processed_query)


            elif (entity_json_data[0] == "CSV"):
                qa_processed_query = entity_json_data[1]
                qa_processed_df = self.athena_manager.get_raw_or_procseed_dataframes(qa_processed_query)
        except Exception as e:
            raise AssertionError("Couldn't create test data for expected data set")

        try:
            entity_json_data = self.config_helper.json_config_data(self.utility.path_finder('/resources/entity-configurations/entityConfigDev.json'), EntityName, 'raw')
            dev_raw_query = entity_json_data[1]
            dev_raw_df = self.athena_manager.get_raw_or_procseed_dataframes(dev_raw_query)

            entity_json_data = self.config_helper.json_config_data(self.utility.path_finder('/resources/entity-configurations/entityConfigDev.json'), EntityName, 'processed')
            dev_processed_query = entity_json_data[1]
            dev_processed_df = self.athena_manager.get_raw_or_procseed_dataframes(dev_processed_query)
        except Exception as e:
            raise AssertionError("Couldn't create test data for actual data set")


        try:
            list_raw = self.utility.dataframe_match_dataTypes(qa_raw_df, dev_raw_df)
            new_qa_raw_df = list_raw[0]
            dev_raw_df = list_raw[1]

            list_processed = self.utility.dataframe_match_dataTypes(qa_processed_df, dev_processed_df)
            new_qa_processed_df = list_processed[0]
            dev_processed_df = list_processed[1]

            new_qa_raw_df = self.utility.sort_all_columns_dataframe(new_qa_raw_df)
            dev_raw_df = self.utility.sort_all_columns_dataframe(dev_raw_df)

            new_qa_processed_df = self.utility.sort_all_columns_dataframe(new_qa_processed_df)
            dev_processed_df = self.utility.sort_all_columns_dataframe(dev_processed_df)
        except Exception as e:
            raise AssertionError("Couldn't create test data for data set")

        return request.param


    @allure.feature('Metadata verification')
    @allure.story('Row & Column count verification of Raw Data')
    @allure.title("Row & Column count verification of Raw Data")
    def test_raw_row_column_count(self, Entity):

        self.comparison_helper.verify_dataframes_row_column_count(dev_raw_df, qa_raw_df, self.dev_raw_df_name, self.qa_raw_df_name)

    @allure.feature('Data verification')
    @allure.story('Data verification of Raw Data')
    @allure.title("Data verification of Raw Data")
    def test_raw_data_comparison(self, Entity):
            self.comparison_helper.verify_dataframes_data_comparsion(dev_raw_df, new_qa_raw_df, self.dev_raw_df_name, self.qa_raw_df_name, Entity, 'raw')



    @allure.feature('Additional column verification')
    @allure.story('Additional column verification in Processed Data')
    @allure.title("Additional column verification in Processed Data")
    def test_dev_processed_additional_column_count(self, Entity):
        self.comparison_helper.verify_datframe_additional_columns_addition(dev_processed_df, self.dev_processed_df_name)

    @allure.feature('Row Gui ID verification')
    @allure.story('Row Gui ID verification in Processed File')
    @allure.title("Row Gui ID verification in Processed File")
    def test_dev_processed_row_gui_id(self, Entity):
        time.sleep(4)
        self.comparison_helper.verify_datframe_row_gui_id(dev_processed_df, self.dev_processed_df_name)


    @allure.feature('Metadata verification')
    @allure.story('Row & Column count verification of Processed Data')
    @allure.title("Row & Column count verification of Processed Data")
    def test_processed_row_column_count(self, Entity):
        self.dev_processed_df = self.utility.drop_proceesed_data_frame_columns(dev_processed_df)
        self.comparison_helper.verify_dataframes_row_column_count(self.dev_processed_df, qa_processed_df, self.dev_processed_df_name, self.qa_processed_df_name)

    @allure.feature('Data verification')
    @allure.story('Data verification of Processed Data')
    @allure.title("Data verification of Processed Data")
    def test_processed_data_comparison(self, Entity):
            self.dev_processed_df = self.utility.drop_proceesed_data_frame_columns(dev_processed_df)
            self.comparison_helper.verify_dataframes_data_comparsion(self.dev_processed_df, new_qa_processed_df, self.dev_processed_df_name , self.qa_processed_df_name, Entity,'processed')



