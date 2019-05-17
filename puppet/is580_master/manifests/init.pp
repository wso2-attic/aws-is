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

class is580_master inherits is580_master::params {

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

  # Install the "zip" package
  package { 'zip':
    ensure => installed,
  }

  # Ensure /opt/is directory is available
  file { "/opt/${service_name}":
    ensure => directory,
    owner  => $user,
    group  => $user_group,
  }

  file { "/usr/local/wso2/":
    ensure => directory,
    owner  => $user,
    group  => $user_group,
  }

  file { "/usr/local/wso2/wso2is":
    ensure => directory,
    owner  => $user,
    group  => $user_group,
  }

  file { "/usr/local/wso2/wso2is/5.8.0":
    ensure => directory,
    owner  => $user,
    group  => $user_group,
  }

  file { "binary":
    path   => "${distribution_path}/${product_binary}",
    mode   => '0644',
    source => "puppet:///modules/installers/${product_binary}",
  }

  # Install the "unzip" package
  package { 'unzip':
    ensure => installed,
  }

  # Unzip the binary and create setup
  exec { "unzip-binary":
    command     => "unzip ${product_binary}",
    path        => "/usr/bin/",
    cwd         => "$distribution_path",
    onlyif      => "/usr/bin/test ! -d ${install_path}",
    subscribe   => File["binary"],
    refreshonly => true,
    require     => Package['unzip'],
  }

  # Copy configuration changes to the installed directory
  $template_list.each | String $template | {
    file { "${install_path}/${template}":
      ensure  => file,
      mode    => '0644',
      content => template("${module_name}/carbon-home/${template}.erb")
    }
  }

  # Copy database connector to the installed directory
  file { "${distribution_path}/${product}-${product_version}/repository/components/lib/${db_connector}":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/${db_connector}",
  }

  # Copy jacoco agent to the installed directory
  file { "${distribution_path}/${product}-${product_version}/lib/jacocoagent.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/jacocoagent.jar",
  }
}
