################################################################################
# Time-stamp: <Mon 2017-08-28 11:48:56 hcartiaux>
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
# @param gpfs_version [String] Default: '4.2.2.3'.
#          Specify the GPFS version of the packages you want to install
#
# @param gskit_version [String] Default: '8.0.50-57'.
#          Specify the gskit version version
#
# @param installer_path [String] Default: '/usr/lpp/mmfs'.
#          Path of the directory where the installer is located
#
# @param read_only [Boolean] Default: false.
#          File name of the installer
#
# @param server_sshkey [Boolean]
#          SSH key of the GPFS server
#
# @param server_sshkey_comment [Boolean]
#          SSH key comment
#
# @param server_sshkey_type [Boolean]
#          SSH key type
#
#
#
# === Requires
#
# n/a
#
# @example
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#    class { ::gpfs:
#      ensure                => absent,
#      read_only             => true,
#      server_sshkey_type    => 'ssh-rsa',
#      server_sshkey_comment => 'root@gpfs1.iris',
#      server_sshkey         => 'AAAAB3Nza...jJMtv'
#    }
#
#
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
    String  $ensure         = $gpfs::params::ensure,
    String  $gpfs_version   = $gpfs::params::gpfs_version,
    String  $gskit_version  = $gpfs::params::gskit_version,
    String  $installer_path = $gpfs::params::installer_path,
    Boolean $read_only      = $gpfs::params::read_only,
    String  $server_sshkey_type,
    String  $server_sshkey_comment,
    String  $server_sshkey
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
