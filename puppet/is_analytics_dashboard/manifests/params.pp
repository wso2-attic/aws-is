# ----------------------------------------------------------------------------
#  Copyright (c) 2018 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ----------------------------------------------------------------------------

# Claas is_analytics_dashboard::params
# This class includes all the necessary parameters.
class is_analytics_dashboard::params {
  $user = 'wso2carbon'
  $user_id = 802
  $user_group = 'wso2'
  $user_home = '/home/$user'
  $user_group_id = 802
  $product = 'wso2is-analytics'
  $product_version = '5.8.0'
  $profile = 'dashboard'
  $service_name = "${product}-${profile}"
  $hostname = 'localhost'
  $mgt_hostname = 'localhost'
  $jdk_version = 'JDK_TYPE'
  $db_managment_system = 'CF_DBMS'
  $oracle_sid = 'WSO2ISDB'
  $db_password = 'CF_DB_PASSWORD'
  $is_package = 'wso2is-analytics-5.8.0.zip'

  # Define the template
  $start_script_template = "bin/${profile}.sh"
  $template_list = [
    'conf/dashboard/deployment.yaml'
  ]

  if $jdk_version == 'ORACLE_JDK8' {
    $jdk_type = "jdk-8u144-linux-x64.tar.gz"
    $jdk_path = "jdk1.8.0_144"
  } elsif $jdk_version == 'OPEN_JDK8' {
    $jdk_type = "jdk-8u192-ea-bin-b02-linux-x64-19_jul_2018.tar.gz"
    $jdk_path = "jdk1.8.0_192"
  } elsif $jdk_version == 'Corretto_JDK8' {
    $jdk_type = "amazon-corretto-8.202.08.2-linux-x64.tar.gz"
    $jdk_path = "amazon-corretto-8.202.08.2-linux-x64"
  }

  # -------------- Deploymeny.yaml Config -------------- #

  # Carbon Configuration Parameters
  $ports_offset = 2

  # Configuration used for the databridge communication
  $databridge_keystore = '${sys:carbon.home}/resources/security/wso2carbon.jks'
  $databridge_keystore_password = 'wso2carbon'
  $binary_data_receiver_hostname = '0.0.0.0'

  # Configuration of the Data Agents - to publish events through
  $thrift_agent_trust_store = '${sys:carbon.home}/resources/security/client-truststore.jks'
  $thrift_agent_trust_store_password = 'wso2carbon'
  $binary_agent_trust_store = '${sys:carbon.home}/resources/security/client-truststore.jks'
  $binary_agent_trust_store_password = 'wso2carbon'

  # Secure Vault Configuration
  $securevault_key_store = '${sys:carbon.home}/resources/security/securevault.jks'
  $securevault_private_key_alias = 'wso2carbon'
  $securevault_secret_properties_file = '${sys:carbon.home}/conf/${sys:wso2.runtime}/secrets.properties'
  $securevault_master_key_reader_file = '${sys:carbon.home}/conf/${sys:wso2.runtime}/master-keys.yaml'

  # Data Sources Configuration
  $business_rules_db_url = 'jdbc:h2:${sys:carbon.home}/wso2/${sys:wso2.runtime}/database/BUSINESS_RULES_DB;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000;MVCC=TRUE'
  $business_rules_db_username = 'wso2carbon'
  $business_rules_db_password = 'wso2carbon'
  $business_rules_db_driver = 'org.h2.Driver'

  $status_dashboard_db_url = 'jdbc:h2:${sys:carbon.home}/wso2/${sys:wso2.runtime}/database/wso2_status_dashboard;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000;MVCC=TRUE'
  $status_dashboard_db_username = 'wso2carbon'
  $status_dashboard_db_password = 'wso2carbon'
  $status_dashboard_db_driver = 'org.h2.Driver'

  $metrics_db_url = 'jdbc:h2:${sys:carbon.home}/wso2/dashboard/database/metrics;AUTO_SERVER=TRUE'
  $metrics_db_username = 'wso2carbon'
  $metrics_db_password = 'wso2carbon'
  $metrics_db_driver = 'org.h2.Driver'

  $permission_db_url = 'jdbc:h2:${sys:carbon.home}/wso2/${sys:wso2.runtime}/database/PERMISSION_DB;IFEXISTS=TRUE;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000;MVCC=TRUE'
  $permission_db_username = 'wso2carbon'
  $permission_db_password = 'wso2carbon'
  $permission_db_driver = 'org.h2.Driver'

  if $db_managment_system == 'mysql' {
    $is_analytics_db_username = 'CF_DB_USERNAME'
    $is_analytics_db_url = 'jdbc:mysql://CF_RDS_URL:3306/IS_ANALYTICS_DB?useSSL=false'
    $db_driver_class_name = 'com.mysql.jdbc.Driver'
    $db_connector = 'mysql-connector-java-5.1.41-bin.jar'
    $db_validation_query = 'SELECT 1'

  } elsif $db_managment_system =~ 'oracle' {
    $is_analytics_db_username = 'IS_ANALYTICS_DB'
    $is_analytics_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $db_driver_class_name = 'oracle.jdbc.OracleDriver'
    $db_validation_query = 'SELECT 1 FROM DUAL'
    $db_connector = 'ojdbc8_1.0.0.jar'

  } elsif $db_managment_system == 'sqlserver-se' {
    $is_analytics_db_username = 'CF_DB_USERNAME'
    $is_analytics_db_url = 'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=IS_ANALYTICS_DB;SendStringParametersAsUnicode=false'
    $db_driver_class_name = 'com.microsoft.sqlserver.jdbc.SQLServerDriver'
    $db_connector = 'mssql-jdbc-7.0.0.jre8.jar'
    $db_validation_query = 'SELECT 1'

  } elsif $db_managment_system == 'postgres' {
    $is_analytics_db_username = 'CF_DB_USERNAME'
    $is_analytics_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/IS_ANALYTICS_DB'
    $db_driver_class_name = 'org.postgresql.Driver'
    $db_connector = 'postgresql-42.2.5.jar'
    $db_validation_query = 'SELECT 1; COMMIT'
  }

  $is_analytics_db = {
    url               => $is_analytics_db_url,
    username          => $is_analytics_db_username,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  # wso2.business.rules.manager config
  $business_rules_manager_username = 'admin'
  $business_rules_manager_password = 'admin'

  # wso2.status.dashboard config
  $status_dashboard_username = 'admin'
  $status_dashboard_password = 'admin'

  # transport.http configuration
  $default_host = '0.0.0.0'
  $default_listener_keystore = '${carbon.home}/resources/security/wso2carbon.jks'
  $default_listener_keystore_password = 'wso2carbon'
  $default_listener_keystore_cert_pass = 'wso2carbon'
}
