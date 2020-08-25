from helpers.config_helper import *
from helpers.ssm_helper import *
from helpers.athena_helper import *
from utility.utility_helper import *

class AthenaManager:
    def __init__(self):
        self.athena_helper = AthenaHelper()
        ssm_helper = SSMHelper()
        self.utility = UtilityHelper()
        config_helper = ConfigHelper()

        # Creating objects
        params = config_helper.config_file_reader(self.utility.path_finder("/resources/credentials/credentials.ini"), "parameters")

        # initializing credentials
        conf_bucket_name = params.get("bucket_name")
        conf_s3_output = params.get("s3_output")


        # initializing ssm parameters

        self.bucket_name = ssm_helper.get_ssm_parameter_value(conf_bucket_name)
        self.s3_output = ssm_helper.get_ssm_parameter_value(conf_s3_output)





    def get_raw_or_procseed_dataframes(self, query):
        try:
            df = self.athena_helper.exec_query_athena(query, self.bucket_name, self.s3_output)

            df=self.utility.format_data_frames(df)

            return df
        except Exception as e:
            raise Exception("Could'nt get data against query, Check query or connection with aws")