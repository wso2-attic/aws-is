#----------------------------------------------------------------------------
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
#----------------------------------------------------------------------------

class is570::params {

  $user = 'wso2carbon'
  $user_id = 802
  $user_group = 'wso2'
  $user_home = '/home/$user'
  $user_group_id = 802
  $service_name = 'wso2is'
  $hostname = 'CF_ELB_DNS_NAME'
  $mgt_hostname = 'CF_ELB_DNS_NAME'
  $jdk_version = 'JDK_TYPE'
  $enable_test_mode = 'ENABLE_TEST_MODE'
  $aws_access_key = 'access-key'
  $aws_secret_key = 'secretkey'
  $aws_region = 'REGION_NAME'
  $local_member_host = $::ipaddress
  $http_proxy_port  = '80'
  $https_proxy_port = '443'
  $is_package = 'wso2is-5.7.0.zip'

  # Define the templates
  $start_script_template = 'bin/wso2server.sh'

  $template_list = [
    'repository/conf/datasources/master-datasources.xml',
    'repository/conf/datasources/bps-datasources.xml',
    'repository/conf/identity/identity.xml',
    'repository/conf/carbon.xml',
    'repository/conf/user-mgt.xml',
    'repository/conf/axis2/axis2.xml',
    'repository/conf/registry.xml',
    'repository/conf/tomcat/catalina-server.xml',
    'repository/conf/consent-mgt-config.xml',
  ]

  $clustering               = {
    enabled => true,
  }

  # Configuration Params
  if $jdk_version == 'ORACLE_JDK8' {
    $jdk_type = "jdk-8u144-linux-x64.tar.gz"
    $jdk_path = "jdk1.8.0_144"
  } elsif $jdk_version == 'OPEN_JDK8' {
    $jdk_type = "jdk-8u192-ea-bin-b02-linux-x64-19_jul_2018.tar.gz"
    $jdk_path = "jdk1.8.0_192"
  }

  # Master-datasources.xml
  $wso2_reg_db = {
    url               => 'jdbc:mysql://CF_RDS_URL:3306/WSO2IS_REG_DB?autoReconnect=true&amp;useSSL=false',
    username          => 'CF_DB_USERNAME',
    password          => 'CF_DB_PASSWORD',
    driver_class_name => 'com.mysql.jdbc.Driver',
  }

  $wso2_bps_db = {
    url               => 'jdbc:mysql://CF_RDS_URL:3306/WSO2IS_BPS_DB?autoReconnect=true&amp;useSSL=false',
    username          => 'CF_DB_USERNAME',
    password          => 'CF_DB_PASSWORD',
    driver_class_name => 'com.mysql.jdbc.Driver',
  }


  $wso2_user_db = {
    url               => 'jdbc:mysql://CF_RDS_URL:3306/WSO2IS_USER_DB?autoReconnect=true&amp;useSSL=false',
    username          => 'CF_DB_USERNAME',
    password          => 'CF_DB_PASSWORD',
    driver_class_name => 'com.mysql.jdbc.Driver',
  }

  $wso2_identity_db = {
    url               => 'jdbc:mysql://CF_RDS_URL:3306/WSO2IS_IDENTITY_DB?autoReconnect=true&amp;useSSL=false',
    username          => 'CF_DB_USERNAME',
    password          => 'CF_DB_PASSWORD',
    driver_class_name => 'com.mysql.jdbc.Driver',
  }

  $wso2_consent_db = {
    url               => 'jdbc:mysql://CF_RDS_URL:3306/WSO2IS_CONSENT_DB?autoReconnect=true&amp;useSSL=false',
    username          => 'CF_DB_USERNAME',
    password          => 'CF_DB_PASSWORD',
    driver_class_name => 'com.mysql.jdbc.Driver',
  }

  # Carbon.xml
  $ports_offset = 0

  # user-mgt.xml
  $enable_scim = true

  $key_store = {
    type         => 'JKS',
    password     => 'wso2carbon',
    key_alias    => 'wso2carbon',
    location     => '${carbon.home}/repository/resources/security/wso2carbon.jks',
    key_password => 'wso2carbon',
  }

  $trust_store = {
    location => '${carbon.home}/repository/resources/security/client-truststore.jks',
    type     => 'JKS',
    password => 'wso2carbon'
  }
}
