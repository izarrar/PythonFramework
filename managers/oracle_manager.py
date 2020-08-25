from helpers.config_helper import *
from helpers.ssm_helper import *
from helpers.oracle_helper import *
from utility.utility_helper import *



class OracleManager:
    def __init__(self):
        ssm_helper = SSMHelper()
        config_helper = ConfigHelper()
        self.utility = UtilityHelper()

        # Creating objects
        params = config_helper.config_file_reader(self.utility.path_finder("/resources/credentials/credentials.ini"), "parameters")

        # initializing credentials
        conf_host = params.get("host")
        conf_port = params.get("port")
        conf_service_name = params.get("service_name")
        conf_user = params.get("user")
        conf_password = params.get("password")

        # initializing ssm parameters

        host=ssm_helper.get_ssm_parameter_value(conf_host)

        port = ssm_helper.get_ssm_parameter_value(conf_port)

        service_name = ssm_helper.get_ssm_parameter_value(conf_service_name)

        user = ssm_helper.get_ssm_parameter_value(conf_user)

        password = ssm_helper.get_ssm_parameter_value(conf_password)

        self.helper_oracle = OracleHelper(host, port, service_name, user, password)



    def get_qa_raw_or_procseed_dataframes(self, query):
        df = self.helper_oracle.oracle_execute_query(query)

        df=self.utility.format_data_frames(df)

        return df