#----------------------------------------------------------------------------
#  Copyright (c) 2019 WSO2, Inc. http://www.wso2.org
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
#----------------------------------------------------------------------------

class is590::params {

  $packages = ["unzip"]
  $user = 'wso2carbon'
  $user_id = 802
  $user_group = 'wso2'
  $user_home = '/home/$user'
  $user_group_id = 802
  $service_name = 'wso2is'
  $product_name = 'wso2is'
  $version = "5.9.0"
  $hostname = 'CF_ELB_DNS_NAME'
  $mgt_hostname = 'CF_ELB_DNS_NAME'
  $enable_test_mode = 'ENABLE_TEST_MODE'
  $jdk_version = 'JDK_TYPE'
  $db_managment_system = 'CF_DBMS'
  $oracle_sid = 'WSO2ISDB'
  $db_password = 'CF_DB_PASSWORD'
  $aws_access_key = 'access-key'
  $aws_secret_key = 'secretkey'
  $aws_region = 'REGION_NAME'
  $local_member_host = $::ipaddress
  $http_proxy_port  = '80'
  $https_proxy_port = '443'
  $is_package = 'wso2is-5.9.0.zip'
  $admin_username = 'admin'
  $admin_password = 'admin'

  $jvmxms = '256m'
  $jvmxmx = '1024m'

  # Define the templates
  $start_script_template = 'bin/wso2server.sh'

  $template_list = [
    'repository/conf/deployment.toml'
  ]

  # JDK Configuration parameters
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
  $java_dir = "/opt"
  $java_symlink = "${java_dir}/java"
  $java_home = "${java_dir}/${jdk_path}"

  $target = "/usr/lib/wso2"
  $product_dir = "${target}/${product_name}/${version}"

  # ----- Master-datasources config params -----

  if $db_managment_system == 'mysql' {
    $wso2_shared_db_name = 'CF_DB_USERNAME'
    $wso2_bps_db_name = 'CF_DB_USERNAME'
    $wso2_identity_db_name = 'CF_DB_USERNAME'
    $wso2_consent_db_name = 'CF_DB_USERNAME'
    $wso2_shared_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2IS_SHARED_DB?autoReconnect=true&amp;useSSL=false'
    $wso2_bps_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2IS_BPS_DB?autoReconnect=true&amp;useSSL=false'
    $wso2_identity_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2IS_IDENTITY_DB?autoReconnect=true&amp;useSSL=false'
    $wso2_consent_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2IS_CONSENT_DB?autoReconnect=true&amp;useSSL=false'
    $db_driver_class_name = 'com.mysql.jdbc.Driver'
    $db_connector = 'mysql-connector-java-5.1.41-bin.jar'
    $db_validation_query = 'SELECT 1'
  } elsif $db_managment_system =~ 'oracle' {
    $wso2_shared_db_name = 'WSO2IS_SHARED_DB'
    $wso2_bps_db_name = 'WSO2IS_BPS_DB'
    $wso2_identity_db_name = 'WSO2IS_IDENTITY_DB'
    $wso2_consent_db_name = 'WSO2IS_CONSENT_DB'
    $wso2_shared_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $wso2_bps_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $wso2_identity_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $wso2_consent_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $db_driver_class_name = 'oracle.jdbc.OracleDriver'
    $db_validation_query = 'SELECT 1 FROM DUAL'
    $db_connector = 'ojdbc8.jar'
  } elsif $db_managment_system == 'sqlserver-se' {
    $wso2_shared_db_name = 'CF_DB_USERNAME'
    $wso2_bps_db_name = 'CF_DB_USERNAME'
    $wso2_identity_db_name = 'CF_DB_USERNAME'
    $wso2_consent_db_name = 'CF_DB_USERNAME'
    $wso2_shared_db_url = 'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=WSO2IS_SHARED_DB;SendStringParametersAsUnicode=false'
    $wso2_bps_db_url = 'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=WSO2IS_BPS_DB;SendStringParametersAsUnicode=false'
    $wso2_identity_db_url = 'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=WSO2IS_IDENTITY_DB;SendStringParametersAsUnicode=false'
    $wso2_consent_db_url = 'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=WSO2IS_CONSENT_DB;SendStringParametersAsUnicode=false'
    $db_driver_class_name = 'com.microsoft.sqlserver.jdbc.SQLServerDriver'
    $db_connector = 'mssql-jdbc-7.0.0.jre8.jar'
    $db_validation_query = 'SELECT 1'
  } elsif $db_managment_system == 'postgres' {
    $wso2_shared_db_name = 'CF_DB_USERNAME'
    $wso2_bps_db_name = 'CF_DB_USERNAME'
    $wso2_identity_db_name = 'CF_DB_USERNAME'
    $wso2_consent_db_name = 'CF_DB_USERNAME'
    $wso2_shared_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/WSO2IS_SHARED_DB'
    $wso2_bps_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/WSO2IS_BPS_DB'
    $wso2_identity_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/WSO2IS_IDENTITY_DB'
    $wso2_consent_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/WSO2IS_CONSENT_DB'
    $db_driver_class_name = 'org.postgresql.Driver'
    $db_connector = 'postgresql-42.2.5.jar'
    $db_validation_query = 'SELECT 1; COMMIT'
  }

  $wso2_shared_db = {
    url               => $wso2_shared_db_url,
    username          => $wso2_shared_db_name,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  $wso2_bps_db = {
    url               => $wso2_bps_db_url,
    username          => $wso2_bps_db_name,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  $wso2_identity_db = {
    url               => $wso2_identity_db_url,
    username          => $wso2_identity_db_name,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  $wso2_consent_db = {
    url               => $wso2_consent_db_url,
    username          => $wso2_consent_db_name,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  # Carbon.xml
  $ports_offset = 0

  # user-mgt.xml
  $enable_scim = true

  $key_store = {
    type         => 'JKS',
    password     => 'wso2carbon',
    key_alias    => 'wso2carbon',
    location     => 'wso2carbon.jks',
    key_password => 'wso2carbon',
  }

  $trust_store = {
    location => 'client-truststore.jks',
    type     => 'JKS',
    password => 'wso2carbon'
  }
}
