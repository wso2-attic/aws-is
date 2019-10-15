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

class is590 inherits is590::params {
  # Install system packages
  package { $packages:
    ensure => installed
  }

  # Create wso2 group
  group { $user_group:
    ensure => present,
    gid    => $user_group_id,
    system => true,
  }

  # Create wso2 user
  user { $user:
    ensure  => present,
    uid     => $user_id,
    gid     => $user_group_id,
    home    => "/home/${user}",
    system  => true,
    require => Group["${user_group}"]
  }

  # Create WSO2 product pack directory
  file { ["${target}", "${target}/${product_name}", "${product_dir}"]:
    ensure  => directory,
    owner   => $user,
    group   => $user_group,
    require => [ User["${user}"], Group["${user_group}"] ]
  }

  # Copy binary to product pack directory
  file { "wso2-binary":
    path    => "${product_dir}/${is_package}",
    owner   => $user,
    group   => $user_group,
    mode    => '0644',
    source  => "puppet:///modules/installers/${is_package}",
    require => File["${target}", "${target}/${product_name}", "${product_dir}"],
  }

  # Unzip the binary and create setup
  exec { "unzip-pack":
    command => "unzip -o ${is_package} -d ${product_dir}",
    path    => "/usr/bin/",
    user    => $user,
    group   => $user_group,
    cwd     => "${product_dir}",
    onlyif  => "/usr/bin/test ! -d ${product_dir}/${product_name}-${version}",
    require => File["wso2-binary"],
  }

  # Setting up the JDK
  file { "copy-jdk-distribution":
    path   => "${java_dir}/${jdk_type}",
    source => "puppet:///modules/installers/${jdk_type}",
  }

  exec { "unpack-jdk":
    command => "tar -zxvf ${jdk_type}",
    path    => "/bin/",
    cwd     => "${java_dir}",
    onlyif  => "/usr/bin/test ! -d ${java_home}",
    require => File["copy-jdk-distribution"],
  }

  # Create symlink to Java binary
  file { "${java_symlink}":
    ensure  => "link",
    target  => "${java_home}",
    require => Exec["unpack-jdk"]
  }

  # Copy configuration changes to the installed directory
  $template_list.each |String $template| {
    file { "${product_dir}/${product_name}-${version}/${template}":
      ensure  => file,
      mode    => '0644',
      content => template("${module_name}/carbon-home/${template}.erb"),
      require => Exec["unzip-pack"],
    }
  }

  # Copy wso2server.sh to installed directory
  file { "${product_dir}/${product_name}-${version}/${start_script_template}":
    ensure  => file,
    owner   => $user,
    group   => $user_group,
    mode    => '0754',
    content => template("${module_name}/carbon-home/${start_script_template}.erb"),
    require => Exec["unzip-pack"],
  }

  # Copy database connector to the installed directory
  file { "${product_dir}/${product_name}-${version}/repository/components/lib/${db_connector}":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/${db_connector}",
    require => Exec["unzip-pack"],
  }

  file { "${java_symlink}/jre/lib/security/local_policy.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    ensure => present,
    source => "puppet:///modules/installers/local_policy.jar",
    require => Exec["unpack-jdk"],
  }

  file { "${java_symlink}/jre/lib/security/US_export_policy.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    ensure => present,
    source => "puppet:///modules/installers/US_export_policy.jar",
    require => Exec["unpack-jdk"],
  }

  file { "/usr/local/bin/private_ip_extractor.py":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/private_ip_extractor.py",
  }

  # Copy jacoco agent to the installed directory
  file { "${product_dir}/${product_name}-${version}/lib/jacocoagent.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/jacocoagent.jar",
  }
}
