################################################################################
# Time-stamp: <Mon 2017-08-28 11:49:06 hcartiaux>
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
  $read_only = false

  ###########################################
  # gpfs system configs
  ###########################################

  # gpfs packages
  $installer_path = $::operatingsystem ? {
    default => '/root/GPFS',
  }

  $extra_packages = $::operatingsystem ? {
    /(?i-mx:ubuntu|debian)/        => 'build-essential',
    /(?i-mx:centos|fedora|redhat)/ => ['libaio', 'ksh', 'm4', 'gcc-c++'], # net-tools (already installed)
    default => []
  }

  $gpfs_version = $::operatingsystem ? {
    default => '4.2.2.3',
  }

  $gskit_version = $::operatingsystem ? {
    default => '8.0.50-57',
  }

  $gpfs_base_directory = $::operatingsystem ? {
    default => '/usr/lpp/mmfs',
  }

  $mountoptions_file = $::operatingsystem ? {
    default => '/var/mmfs/etc/localMountOptions'
  }
  $mountoptions_file_owner = $::operatingsystem ? {
    default => 'root'
  }
  $mountoptions_file_group = $::operatingsystem ? {
    default => 'root'
  }
  $mountoptions_file_mode = $::operatingsystem ? {
    default => '0755'
  }

  $bash_profile_d_file = $::operatingsystem ? {
    default => '/etc/profile.d/gpfs.sh'
  }
  $bash_profile_d_file_owner = $::operatingsystem ? {
    default => 'root'
  }
  $bash_profile_d_file_group = $::operatingsystem ? {
    default => 'root'
  }
  $bash_profile_d_file_mode = $::operatingsystem ? {
    default => '0755'
  }

}
