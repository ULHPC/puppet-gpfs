################################################################################
# Time-stamp: <Wed 2017-08-23 14:49 svarrette>
#
# File::      <tt>init.pp</tt>
# Author::    UL HPC Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2017 UL HPC Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# == Class: gpfs
#
# Configure and manage IBM GPFS/Spectrumscale clients
#
#
# @param ensure [String] Default: 'present'.
#          Ensure the presence (or absence) of gpfs
#
# === Requires
#
# n/a
#
# @example Basic instanciation
#
#     include '::gpfs'
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { '::gpfs':
#             ensure => 'present'
#         }
#
# === Authors
#
# The UL HPC Team <hpc-sysadmins@uni.lu> of the University of Luxembourg, in
# particular
# * Sebastien Varrette <Sebastien.Varrette@uni.lu>
# * Valentin Plugaru   <Valentin.Plugaru@uni.lu>
# * Sarah Peter        <Sarah.Peter@uni.lu>
# * Hyacinthe Cartiaux <Hyacinthe.Cartiaux@uni.lu>
# * Clement Parisot    <Clement.Parisot@uni.lu>
# See AUTHORS for more details
#
# === Warnings
#
# /!\ Always respect the style guide available here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
class gpfs(
    String $ensure = $gpfs::params::ensure
)
inherits gpfs::params
{
    validate_legacy('String', 'validate_re', $ensure, ['^present', '^absent'])

    info ("Configuring gpfs (with ensure = ${ensure})")

    case $::operatingsystem {
        /(?i-mx:ubuntu|debian)/:        { include ::gpfs::common::debian }
        /(?i-mx:centos|fedora|redhat)/: { include ::gpfs::common::redhat }
        default: {
            fail("Module ${module_name} is not supported on ${::operatingsystem}")
        }
    }
}
