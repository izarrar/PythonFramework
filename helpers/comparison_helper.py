"""
----------------------------------------------------------------------------------------------------------
Description:

usage: Comparison Helper Methods

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

import pytest
import pandas as pd
import datacompy
import time

from utility.utility_helper import *
from helpers.ssm_helper import *
utility=UtilityHelper()
ssm_helper=SSMHelper()

log = utility.logger("Comparison")


class ComparisonHelper:


    def compare_dataframes(self,df1, df2):
        """
        Compare two dataframes by applying similar sorting and row indexes.
        :param df1: Source Data Frame.
        :param df2: Target Data Frame.
        """
        try:
            columns = df1.columns

            if len(columns) == 1:
                # Sorting of Data frames on common column
                df1 = df1.sort_values([columns[0]], ascending=[1])
                df2 = df2.sort_values([columns[0]], ascending=[1])
            else:
                # Sorting of Data frames on common column
                df1 = df1.sort_values([columns[0], columns[1]], ascending=[1, 1])
                df2 = df2.sort_values([columns[0], columns[1]], ascending=[1, 1])

            # Reindexing of Columns for Data frames
            df1 = df1.reindex(sorted(df1.columns), axis=1)
            df2 = df2.reindex(sorted(df2.columns), axis=1)

            # Resetting the Row Index for Data frames
            df1 = df1.reset_index(drop=True)
            df2 = df2.reset_index(drop=True)

            # Change Data types to Object
            df1 = df1.astype(str)
            df2 = df2.astype(str)
            # Comparing Data frames
            log.info(df1)
            log.info(df2)
            result = df1.equals(df2)
            if result is True:
                comparison_results=[result,True]
                return comparison_results
            else:
                difference = pd.concat([df1,df2],sort=False)
                comparison_results = [difference, False]
                return comparison_results


        except Exception as e:
            log.error(e)

    #Compare two data frames using Datacompy library.
    def compare_dataframes_datacompy(self,df1,df2,df1_name,df2_name):
        """
        Compare two data frames using Datacompy library
        :param df1: Source data frame
        :param df2: Target data frame
        :param df1_name: Source data frame name
        :param df2_name: Target data frame name
        :return: Comparison object
        """
        try:
            compare = datacompy.Compare(
                df1,
                df2,
                on_index=True,  # You can also specify a list of columns eg ['policyID','statecode']
                abs_tol=0,  # Optional, defaults to 0
                rel_tol=0,  # Optional, defaults to 0
                df1_name=df1_name,  # Optional, defaults to 'df1'
                df2_name=df2_name  # Optional, defaults to 'df2'
            )
            return compare
        except Exception as e:
            log.error(e)

    #Row & Column counts comparison of two data frames.
    def verify_dataframes_row_column_count(self,df1,df2,df1_name,df2_name):

        """
        Row & Column counts comparison of two data frames.
        :param df1: Source data frame
        :param df2: Target data frame
        :param df1_name: Source data frame name
        :param df2_name: Target data frame name
        :return:Nothing
        """
        try:
            compare = self.compare_dataframes_datacompy(df1, df2, df1_name, df2_name)
            row_count_df1 = len(df1)
            row_count_df2 = len(df2)
            col_count_df1 = len(compare.column_stats) + len(compare.df1_unq_columns())
            col_count_df2 = len(compare.column_stats) + len(compare.df2_unq_columns())

            log.info("Column count verification")
            log.info("--------------------------")

            if (col_count_df1 == col_count_df2):
                log.info("Column count of " + df1_name + " File: " + str(col_count_df1))
                log.info("Column count of " + df2_name + " File: " + str(col_count_df2))
                log.info("Column count of both " + df1_name + " & " + df2_name + " files is equal!!")
            else:
                log.info("Column count of " + df1_name + " File: " + str(col_count_df1))
                log.info("Column count of " + df2_name + " File: " + str(col_count_df2))
                log.info("Column count of both " + df1_name + " & " + df2_name + " files is not equal.")
                pytest.fail("Column count of both " + df1_name + " & " + df2_name + " files is not equal.")


            log.info(" ")

            log.info("Row count verification")
            log.info("-----------------------")

            if (row_count_df1 == row_count_df2):
                log.info("Row count " + df1_name + " File: " + str(row_count_df1))
                log.info("Row count " + df2_name + " File: " + str(row_count_df2))
                log.info("Row count of both " + df1_name + " & " + df2_name + " files is equal!")
            else:
                log.info("Row count " + df1_name + " File: " + str(row_count_df1))
                log.info("Row count of " + df2_name + " File: " + str(row_count_df2))
                log.info("Row count of both " + df1_name + " & " + df2_name + " is not equal!")
                raise Exception("Row count of both " + df1_name + " & " + df2_name + " is not equal!")
        except Exception as e:
            raise AssertionError(str(e))

    #Data comparison of two data frames.
    def verify_dataframes_data_comparsion(self, df1, df2, df1_name, df2_name, entity_name, data_verification_type):

            """
            Data comparison of two data frames.
            :param df1: Source data frame
            :param df2: Target data frame
            :param df1_name: Source data frame name
            :param df2_name: Target data frame name
            :return:Nothing
            """
            log.info("Data Comparison")
            log.info("----------------")
            try:
                compare = self.compare_dataframes_datacompy(df1, df2, df1_name, df2_name)
                if (compare.intersect_rows_match()):
                    log.info(df1_name + " & " + df2_name + " files are equal!!")
                else:
                    log.info(df1_name + " File & " + df2_name + " File are not equal")
                    log.info("")
                    log.info("Rows with unequal values between " + df1_name + " File & " + df2_name + " File")
                    log.info("-----------------------------------------------------------------------")

                    col_names = []
                    mismatched = pd.DataFrame()

                    for item in range(len(compare.column_stats)):
                        col_names.append(compare.column_stats[item]['column'])

                    for item in range(len(col_names)):
                        if len(compare.sample_mismatch(col_names[item], for_display=True)) > 0:
                            log.info("")
                            log.info(compare.sample_mismatch(col_names[item], for_display=True))
                            mismatched_col_df = compare.sample_mismatch(col_names[item],
                                                                        sample_count=max(len(df1), len(df2)),
                                                                        for_display=True)

                            # mismatched = mismatched.append(mismatched_col_df, ignore_index=False, sort=False)
                            # mismatched = mismatched.merge(mismatched_col_df, left_on=None, right_on=None, on=None, how='outer')
                            # mismatched = pd.concat([mismatched, mismatched_col_df], axis=0, ignore_index=True, sort=False)
                            for col in mismatched_col_df.columns:
                                df_col_values = mismatched_col_df[col].tolist()
                                for x in range(len(df_col_values), max(len(df1), len(df2))+1):
                                    df_col_values.append('')
                                mismatched[col] = df_col_values
                            mismatched['']=''

                    timeStr = time.strftime("%Y-%m-%d-%H.%M.%S")
                    utility.export_to_csv(utility.path_finder('/resources/mismatched-results/' + data_verification_type + '/' +entity_name+'/' + timeStr + '-' + entity_name + '.csv'), mismatched)

                    raise Exception(df1_name + " & " + df2_name + " files are not equal!!")
                # print("\n")
                # print(compare.report())
            except Exception as e:
                raise AssertionError(str(e))



    #Check the count and uniqueness of rowGuiId column in dataframe.
    def verify_datframe_row_gui_id(self,df,df_name):
        """
        check the count and uniqueness of rowGuiId column in dataframe.
        :param df: Pandas DataFrame
        :return: Nothing.
        """
        log.info("RowGuID verification on " + df_name + " File")
        log.info("-----------------------------------------------------")

        try:
            df.columns = df.columns.str.upper()
            row_gui_id = df['ROWGUID'].describe()
            count_of_df = len(df.index)
            count_of_row_gui_id = row_gui_id[0]
            count_of_unique_row_gui_id = row_gui_id[1]

            if count_of_df == count_of_row_gui_id:
                log.info('Count of row gui id & count of rows in data frame is equal! \n count : ' + str(count_of_unique_row_gui_id))
                if count_of_unique_row_gui_id == count_of_df:
                    log.info("There are no duplicate values in row gui id column")
                else:
                    log.error("Values in row gui id column are duplicate")
                    raise Exception("Values in row gui id column are duplicate")
            else:
                log.error("Count of row gui id & count of rows in data frame is not equal")
                raise Exception("Count of row gui id & count of rows in data frame is not equal")
        except Exception as e:
            raise AssertionError(str(e))

    #Additional column verification in data frame.
    def verify_datframe_additional_columns_addition(self,df,df_name):
        """
         Additional column verification in data frame.
        :param df: Target data frame.
        :param df_name: Target data frame name.
        :return: Nothing.
        """

        log.info("Additional column verification " + df_name + " File")
        log.info("-----------------------------------------------------")
        try:
            additional_coulmns_expected = ['rowguid', 'datapath', 'userid', 'groupentityexecutionid','recordinsertedtimestamp', 'tenantid']
            additional_coulmns_actual = []
            count_check=0
            for col in df.columns:
                col_lower = col.lower()
                additional_coulmns_actual.append(col_lower)

            for item in additional_coulmns_expected:
                if item in additional_coulmns_actual:
                    log.info(item + " additional column exist in  " + df_name + " file")
                else:
                    log.info(item + " additional column do not exist in " + df_name + " file")
                    count_check=1
            if count_check > 0:
                 raise Exception("Additional column do not exist in " + df_name + " file")

        except Exception as e:
          raise AssertionError(str(e))

