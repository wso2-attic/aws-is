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

# Class: is_analytics_worker570
# Init class of Identity Server Analytics - Worker profile
class is_analytics_worker570 inherits is_analytics_worker570::params {

  # Create wso2 group
  group { $user_group:
    ensure => present,
    gid    => $user_group_id,
    system => true,
  }

  # Create wso2 user
  user { $user:
    ensure => present,
    uid    => $user_id,
    gid    => $user_group_id,
    home   => "/home/${user}",
    system => true,
  }

  # Ensure /opt/is directory is available
  file { "/opt/${service_name}":
    ensure => directory,
    owner  => $user,
    group  => $user_group,
  }

  file { "/usr/lib/wso2/":
    ensure => directory,
    owner  => $user,
    group  => $user_group,
  }

  file { "/usr/lib/wso2/wso2is-analytics/":
    ensure => directory,
    owner  => $user,
    group  => $user_group,
  }

  file { "/usr/lib/wso2/wso2is-analytics/5.7.0/":
    ensure => directory,
    owner  => $user,
    group  => $user_group,
  }

  # Copy the relevant installer to the /opt/is directory
  file { "/usr/lib/wso2/wso2is-analytics/5.7.0/${is_package}":
    owner  => $user,
    group  => $user_group,
    mode   => '0644',
    source => "puppet:///modules/installers/${is_package}",
  }

  # Install WSO2 Identity Server
  exec { 'unzip':
    command => 'unzip wso2is-analytics-5.7.0.zip',
    unless =>  '/usr/bin/test -d /usr/lib/wso2/wso2is-analytics/5.7.0/wso2is-analytics-5.7.0',
    cwd     => '/usr/lib/wso2/wso2is-analytics/5.7.0/',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  #jdk
  file { "/usr/lib/wso2/wso2is-analytics/5.7.0/${jdk_type}":
    owner  => $user,
    group  => $user_group,
    mode   => '0644',
    source => "puppet:///modules/installers/${jdk_type}",
  }

  # Install WSO2 Identity Server
  exec { 'tar':
    command => "tar -xvf ${jdk_type}",
    cwd     => '/usr/lib/wso2/wso2is-analytics/5.7.0/',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  # Copy configuration changes to the installed directory
  $template_list.each | String $template | {
    file { "/usr/lib/wso2/wso2is-analytics/5.7.0/wso2is-analytics-5.7.0/${template}":
      ensure  => file,
      owner   => $user,
      group   => $user_group,
      mode    => '0644',
      content => template("${module_name}/carbon-home/${template}.erb")
    }
  }

  # Copy wso2server.sh to installed directory
  file { "/usr/lib/wso2/wso2is-analytics/5.7.0/wso2is-analytics-5.7.0/${start_script_template}":
    ensure  => file,
    owner   => $user,
    group   => $user_group,
    mode    => '0754',
    content => template("${module_name}/carbon-home/${start_script_template}.erb")
  }

  # Copy database connector to the installed directory
  file { "/usr/lib/wso2/wso2is-analytics/5.7.0/wso2is-analytics-5.7.0/lib/${db_connector}":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/${db_connector}",
  }

  file { "/usr/lib/wso2/wso2is-analytics/5.7.0/${jdk_path}/jre/lib/security/local_policy.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    ensure => present,
    source => "puppet:///modules/installers/local_policy.jar",
  }

  file { "/usr/lib/wso2/wso2is-analytics/5.7.0/${jdk_path}/jre/lib/security/US_export_policy.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    ensure => present,
    source => "puppet:///modules/installers/US_export_policy.jar",
  }

  file { "/usr/local/bin/private_ip_extractor.py":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/private_ip_extractor.py",
  }

  # Copy the unit file required to deploy the server as a service
  file { "/etc/systemd/system/${service_name}.service":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0754',
    content => template("${module_name}/${service_name}.service.erb"),
  }

  /*
    Following script can be used to copy file to a given location.
    This will copy some_file to install_path -> repository.
    Note: Ensure that file is available in modules -> is_analytics_worker570 -> files
  */
  # file { "${install_path}/repository/some_file":
  #   owner  => $user,
  #   group  => $user_group,
  #   mode   => '0644',
  #   source => "puppet:///modules/${module_name}/some_file",
  # }
}
