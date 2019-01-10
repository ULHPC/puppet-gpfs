################################################################################
# Time-stamp: <Mon 2017-08-28 14:30:31 hcartiaux>
#
# File::      <tt>install.pp</tt>
# Author::    UL HPC Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2017 UL HPC Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# == Defines: gpfs::install
#
# Definition used internally, in order to install the packages extracted from
# the IBM Spectrum Scale installer
#
# == Pre-requisites
#
# * The class 'gpfs' should have been instanciated
#
# == Parameters:
#
# [*name*]
#  The name of the definition is the name of a package
#
# [*repo_location*]
#  Location of the packages on the disk
#
# == Sample usage:
#
#     include "gpfs"
#
# You can then use the install definition as follows:
#
#    gpfs::install { $packages:
#      repo_location => $package_directory,
#    }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[https://docs.puppet.com/puppet/latest/style_guide.html]
#
define gpfs::install (
  String $package_name = $name,
  String $repo_location = undef
  ) {

  require ::gpfs::params

  if ! ($package_name or $repo_location){
    fail('you must define a package name and a repository location !')
  }

  $package_provider = $::operatingsystem ? {
    /(?i-mx:ubuntu|debian)/        => 'dpkg',
    /(?i-mx:centos|fedora|redhat)/ => 'rpm',
  }

  if ($gpfs::ensure == 'present') {
    $package_ensure = 'latest'
  } else {
    $package_ensure = $gpfs::ensure
  }

  package { regsubst($package_name, '^([^-]*).*$', '\1'):
    ensure   => $package_ensure,
    provider => $package_provider,
    source   => "${repo_location}/${package_name}",
    require  => Exec['gpfs-installer-exec'];
  }

}
