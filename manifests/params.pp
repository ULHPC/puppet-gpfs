################################################################################
# Time-stamp: <Wed 2017-08-23 15:15 svarrette>
#
# File::      <tt>params.pp</tt>
# Author::    UL HPC Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2017 UL HPC Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# == Class: gpfs::params
#
# In this class are defined as variables values that are used in other
# gpfs classes and definitions.
# This class should be included, where necessary, and eventually be enhanced
# with support for more Operating Systems.
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
class gpfs::params {

  #### MODULE INTERNAL VARIABLES  #########
  # (Modify to adapt to unsupported OSes)
  #########################################

  # ensure the presence (or absence) of gpfs
  $ensure = 'present'

  # The Protocol used. Used by monitor and firewall class. Default is 'tcp'
  $protocol = 'tcp'

  # The port number. Used by monitor and firewall class. The default is 22.
  $port = 22

  # example of an array/hash variable
  $array_variable = []
  $hash_variable  = {}

  # undef variable
  $undefvar = undef

  ###########################################
  # gpfs system configs
  ###########################################
  # gpfs user / group identifiers
  $username = 'gpfs'
  $uid      = 14144
  $group    = $username
  $gid      = $uid
  $home     = "/var/lib/${username}"
  $comment  = 'Gpfs User'
  $shell    = '/sbin/nologin' # or '/bin/bash'

  # gpfs packages
  $packagename = $::operatingsystem ? {
    default => 'gpfs',
  }
  $extra_packages = $::operatingsystem ? {
    /(?i-mx:ubuntu|debian)/        => [],
    /(?i-mx:centos|fedora|redhat)/ => [],
    default => []
  }

  # Log directory
  $logdir = $::operatingsystem ? {
    default => '/var/log/gpfs'
  }
  $logdir_mode = $::operatingsystem ? {
    default => '750',
  }
  $logdir_owner = $::operatingsystem ? {
    default => 'root',
  }
  $logdir_group = $::operatingsystem ? {
    default => 'adm',
  }

  # PID for daemons
  $piddir = $::operatingsystem ? {
    default => "/var/run/gpfs",
  }
  $piddir_mode = $::operatingsystem ? {
    default => '750',
  }
  $piddir_owner = $::operatingsystem ? {
    default => 'gpfs',
  }
  $piddir_group = $::operatingsystem ? {
    default => 'adm',
  }
  $pidfile = $::operatingsystem ? {
    default => '/var/run/gpfs/gpfs.pid'
  }

  # gpfs associated services
  $servicename = $::operatingsystem ? {
    /(?i-mx:ubuntu|debian)/ => 'gpfs',
    default                 => 'gpfs'
  }
  # used for pattern in a service ressource
  $processname = $::operatingsystem ? {
    /(?i-mx:ubuntu|debian)/ => 'gpfs',
    default                 => 'gpfs'
  }
  $hasstatus = $::operatingsystem ? {
    /(?i-mx:ubuntu|debian)/        => false,
    /(?i-mx:centos|fedora|redhat)/ => true,
    default => true,
  }
  $hasrestart = $::operatingsystem ? {
    default => true,
  }

  # Configuration directory & file
  $configdir = $::operatingsystem ? {
    default => "/etc/gpfs",
  }
  $configdir_mode = $::operatingsystem ? {
    default => '0755',
  }
  $configdir_owner = $::operatingsystem ? {
    default => 'root',
  }
  $configdir_group = $::operatingsystem ? {
    default => 'root',
  }

  $configfile = $::operatingsystem ? {
    default => '/etc/gpfs.conf',
  }
  $configfile_mode = $::operatingsystem ? {
    default => '0600',
  }
  $configfile_owner = $::operatingsystem ? {
    default => 'root',
  }
  $configfile_group = $::operatingsystem ? {
    default => 'root',
  }

  $default_sysconfig = $::operatingsystem ? {
    /(?i-mx:ubuntu|debian)/ => '/etc/default/gpfs',
    default                 => '/etc/sysconfig/gpfs'
  }

}
