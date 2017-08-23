################################################################################
# Time-stamp: <Wed 2017-08-23 15:14 svarrette>
#
# File::      <tt>common.pp</tt>
# Author::    UL HPC Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2017 UL HPC Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# = Class: gpfs::common
#
# Base class to be inherited by the other gpfs classes, containing the common code.
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
#
class gpfs::common {

  # Load the variables used in this module. Check the params.pp file
  require gpfs::params

  # Order
  if ($gpfs::ensure == 'present') {
    Group['gpfs'] -> User['gpfs'] -> Package['gpfs']
  }
  else {
    Package['gpfs'] -> User['gpfs'] -> Group['gpfs']
  }

  # Prepare the user and group
  group { 'gpfs':
    ensure => $gpfs::ensure,
    name   => gpfs::params::group,
    gid    => gpfs::params::gid,
  }
  user { 'munge':
    ensure     => $gpfs::ensure,
    name       => $gpfs::params::username,
    uid        => $gpfs::params::gid,
    gid        => $gpfs::params::gid,
    comment    => $gpfs::params::comment,
    home       => $gpfs::params::home,
    managehome => true,
    system     => true,
    shell      => $gpfs::params::shell,
  }

  package { 'gpfs':
    name    => "${gpfs::params::packagename}",
    ensure  => "${gpfs::ensure}",
  }
  package { $gpfs::params::extra_packages:
    ensure => 'present'
  }

  if $gpfs::ensure == 'present' {

    # Prepare the log directory
    file { "${gpfs::params::logdir}":
      ensure => 'directory',
      owner  => "${gpfs::params::logdir_owner}",
      group  => "${gpfs::params::logdir_group}",
      mode   => "${gpfs::params::logdir_mode}",
      require => Package['gpfs'],
    }

    # Configuration file
    file { "${gpfs::params::configdir}":
      ensure => 'directory',
      owner  => "${gpfs::params::configdir_owner}",
      group  => "${gpfs::params::configdir_group}",
      mode   => "${gpfs::params::configdir_mode}",
      require => Package['gpfs'],
    }
    # Regular version using file resource
    file { 'gpfs.conf':
      ensure  => "${gpfs::ensure}",
      path    => "${gpfs::params::configfile}",
      owner   => "${gpfs::params::configfile_owner}",
      group   => "${gpfs::params::configfile_group}",
      mode    => "${gpfs::params::configfile_mode}",
      #content => template("gpfs/gpfsconf.erb"),
      #source => "puppet:///modules/gpfs/gpfs.conf",
      #notify  => Service['gpfs'],
      require => [
        #File["${gpfs::params::configdir}"],
        Package['gpfs']
      ],
    }

    # # Concat version -- see https://forge.puppetlabs.com/puppetlabs/concat
    # include concat::setup
    # concat { "${gpfs::params::configfile}":
      #     warn    => false,
      #     owner   => "${gpfs::params::configfile_owner}",
      #     group   => "${gpfs::params::configfile_group}",
      #     mode    => "${gpfs::params::configfile_mode}",
      #     #notify  => Service['gpfs'],
      #     require => Package['gpfs'],
      # }
    # # Populate the configuration file
    # concat::fragment { "${gpfs::params::configfile}_header":
      #     ensure  => "${gpfs::ensure}",
      #     target  => "${gpfs::params::configfile}",
      #     content => template("gpfs/gpfs_header.conf.erb"),
      #     #source => "puppet:///modules/gpfs/gpfs_header.conf",
      #     order   => '01',
      # }
    # concat::fragment { "${gpfs::params::configfile}_footer":
      #     ensure  => "${gpfs::ensure}",
      #     target  => "${gpfs::params::configfile}",
      #     content => template("gpfs/gpfs_footer.conf.erb"),
      #     #source => "puppet:///modules/gpfs/gpfs_footer.conf",
      #     order   => '99',
      # }

    # PID file directory
    file { "${gpfs::params::piddir}":
      ensure  => 'directory',
      owner   => "${gpfs::params::piddir_user}",
      group   => "${gpfs::params::piddir_group}",
      mode    => "${gpfs::params::piddir_mode}",
    }
  }
  else
  {
    # Here $gpfs::ensure is 'absent'
    file {
      [
        $gpfs::params::configdir,
        $gpfs::params::logdir,
        $gpfs::params::piddir,
      ]:
        ensure => $gpfs::ensure,
        force  => true,
    }
  }
    # Sysconfig / default daemon directory
    file { "${gpfs::params::default_sysconfig}":
      ensure  => $gpfs::ensure,
      owner   => $gpfs::params::configfile_owner,
      group   => $gpfs::params::configfile_group,
      mode    => '0755',
      #content => template("gpfs/default/gpfs.erb"),
      #source => "puppet:///modules/gpfs/default/gpfs.conf",
      notify  =>  Service['gpfs'],
      require =>  Package['gpfs']
    }

  service { 'gpfs':
    ensure     => ($gpfs::ensure == 'present'),
    name       => "${gpfs::params::servicename}",
    enable     => ($gpfs::ensure == 'present'),
    pattern    => "${gpfs::params::processname}",
    hasrestart => "${gpfs::params::hasrestart}",
    hasstatus  => "${gpfs::params::hasstatus}",
    require    => [
      Package['gpfs'],
      File[$gpfs::params::configdir],
      File[$gpfs::params::logdir],
      File[$gpfs::params::piddir],
      File[$gpfs::params::configfile_init]
    ],
    subscribe  => File['gpfs.conf'],
  }

}
