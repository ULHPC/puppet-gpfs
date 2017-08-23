################################################################################
# Time-stamp: <Wed 2017-08-23 14:37 svarrette>
#
# File::      <tt>mydef.pp</tt>
# Author::    UL HPC Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2017 UL HPC Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# == Defines: gpfs::mydef
#
# Configure and manage IBM GPFS/Spectrumscale clients
#
# == Pre-requisites
#
# * The class 'gpfs' should have been instanciated
#
# == Parameters:
#
# [*ensure*]
#   default to 'present', can be 'absent'.
#   Default: 'present'
#
# [*content*]
#  Specify the contents of the mydef entry as a string. Newlines, tabs,
#  and spaces can be specified using the escaped syntax (e.g., \n for a newline)
#
# [*source*]
#  Copy a file as the content of the mydef entry.
#  Uses checksum to determine when a file should be copied.
#  Valid values are either fully qualified paths to files, or URIs. Currently
#  supported URI types are puppet and file.
#  In neither the 'source' or 'content' parameter is specified, then the
#  following parameters can be used to set the console entry.
#
# == Sample usage:
#
#     include "gpfs"
#
# You can then add a mydef specification as follows:
#
#      gpfs::mydef {
#
#      }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[https://docs.puppet.com/puppet/latest/style_guide.html]
#
define gpfs::mydef(
    $ensure         = 'present',
    $content        = '',
    $source         = ''
)
{
  validate_re($ensure, '^present$|^absent$')
  #validate_string($mode)
  #validate_hash($hash)
  #validate_absolute_path($path)
  #if ! (is_string($owner) or is_integer($owner)) {
  #  fail("\$owner must be a string or integer, got ${owner}")
  #}
  #validate_bool($replace)

    include gpfs::params

    # $name is provided at define invocation
    $basename = $name

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("gpfs::mydef 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ($gpfs::ensure != $ensure) {
        if ($gpfs::ensure != 'present') {
            fail("Cannot configure a gpfs '${basename}' as gpfs::ensure is NOT set to present (but ${gpfs::ensure})")
        }
    }

    # if content is passed, use that, else if source is passed use that
    $real_content = $content ? {
        '' => $source ? {
            ''      => template('gpfs/gpfs_entry.erb'),
            default => ''
        },
        default => $content
    }
    $real_source = $source ? {
        '' => '',
        default => $content ? {
            ''      => $source,
            default => ''
        }
    }

    # concat::fragment { "${gpfs::params::configfile}_${basename}":
    #     ensure  => "${ensure}",
    #     target  => "${gpfs::params::configfile}",
    #     content => $real_content,
    #     source  => $real_source,
    #     order   => '50',
    # }

    # case $ensure {
    #     present: {

    #     }
    #     absent: {

    #     }
    #     disabled: {

    #     }
    #     default: { err ( "Unknown ensure value: '${ensure}'" ) }
    # }

}
