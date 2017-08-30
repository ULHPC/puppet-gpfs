################################################################################
# Time-stamp: <Mon 2017-08-28 11:48:42 hcartiaux>
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
  require ::gpfs::params

  $gpfs_package_version = $::operatingsystem ? {
    /(?i-mx:ubuntu|debian)/        => regsubst($gpfs::gpfs_version, '^(.*)\.(\d+)$','\1_\2'),
    /(?i-mx:centos|fedora|redhat)/ => regsubst($gpfs::gpfs_version, '^(.*)\.(\d+)$','\1-\2'),
  }
  $installer_name = "Spectrum_Scale_Protocols_Standard-${gpfs::gpfs_version}-x86_64-Linux-install"
  $packages = $::operatingsystem ? {
    /(?i-mx:ubuntu|debian)/        => [
                                        "gpfs.base_${gpfs_package_version}_amd64.deb",
                                        "gpfs.docs_${gpfs_package_version}_all.deb",
                                        "gpfs.gpl_${gpfs_package_version}_all.deb",
                                        "gpfs.msg.en-us_${gpfs_package_version}_all.deb",
                                        "gpfs.ext_${gpfs_package_version}_amd64.deb",
                                        "gpfs.gskit_${gpfs::gskit_version}_amd64.deb",
                                      ],
    /(?i-mx:centos|fedora|redhat)/ => [
                                        "gpfs.base-${gpfs_package_version}.x86_64.rpm",
                                        "gpfs.docs-${gpfs_package_version}.noarch.rpm",
                                        "gpfs.gpl-${gpfs_package_version}.noarch.rpm",
                                        "gpfs.msg.en_US-${gpfs_package_version}.noarch.rpm",
                                        "gpfs.ext-${gpfs_package_version}.x86_64.rpm",
                                        "gpfs.gskit-${gpfs::gskit_version}.x86_64.rpm",
                                      ]
  }
  $package_directory = "${gpfs::params::gpfs_base_directory}/${gpfs::gpfs_version}/gpfs_rpms/"


  package { $gpfs::params::extra_packages:
    ensure => $gpfs::ensure,
  }

  if ($gpfs::read_only and $gpfs::ensure == 'present') {
    $mountoptions_file_ensure = 'present'
  } else {
    $mountoptions_file_ensure = 'absent'
  }
  file { $gpfs::params::mountoptions_file:
    ensure  => $mountoptions_file_ensure,
    owner   => $gpfs::params::mountoptions_file_owner,
    group   => $gpfs::params::mountoptions_file_group,
    mode    => $gpfs::params::mountoptions_file_mode,
    content => 'ro',
    require => Gpfs::Install[$packages],
  }

  file { $gpfs::params::bash_profile_d_file:
    ensure  => $gpfs::ensure,
    owner   => $gpfs::params::bash_profile_d_file_owner,
    group   => $gpfs::params::bash_profile_d_file_group,
    mode    => $gpfs::params::bash_profile_d_file_mode,
    content => "export PATH=\$PATH:${gpfs::params::gpfs_base_directory}/bin\n",
  }

  ssh_authorized_key { $gpfs::server_sshkey_comment:
    ensure => $gpfs::ensure,
    user   => 'root',
    type   => $gpfs::server_sshkey_type,
    key    => $gpfs::server_sshkey,
  }


  if $gpfs::ensure == 'present' {
    gpfs::install { $packages:
      repo_location => $package_directory,
    }

    Package[$gpfs::params::extra_packages] -> Gpfs::Install[$packages]
    exec { 'gpfs-installer-exec':
      command => "${gpfs::params::installer_path}/${installer_name} --text-only --silent",
      unless  => "/bin/test -d ${gpfs::params::gpfs_base_directory}/${gpfs::gpfs_version}",
    }

    exec { 'compil-step-1':
      command => '/usr/bin/make LINUX_DISTRIBUTION=REDHAT_AS_LINUX Autoconfig',
      cwd     => '/usr/lpp/mmfs/src',
      unless  => "/bin/test -e /usr/lib/modules/${::kernelrelease}/extra/mmfslinux.ko",
      path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
      require => Gpfs::Install[$packages],
    }
    -> exec { 'compil-step-2':
      command => '/usr/bin/make World',
      cwd     => '/usr/lpp/mmfs/src',
      unless  => "/bin/test -e /usr/lib/modules/${::kernelrelease}/extra/mmfslinux.ko",
      path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
      require => Gpfs::Install[$packages],
    }
    -> exec { 'compil-step-3':
      command => '/usr/bin/make InstallImages',
      cwd     => '/usr/lpp/mmfs/src',
      unless  => "/bin/test -e /usr/lib/modules/${::kernelrelease}/extra/mmfslinux.ko",
      path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
      require => Gpfs::Install[$packages],
    }


  }
  else
  {
    gpfs::install { reverse($packages):
      repo_location => $package_directory,
    }
    Gpfs::Install[$packages] -> Package[$gpfs::params::extra_packages]
    exec { 'gpfs-installer-exec':
      command => "${gpfs::params::installer_path}/${installer_name} --remove",
      onlyif  => "/bin/test -d ${gpfs::params::gpfs_base_directory}/src",
    }
    -> exec { 'gpfs-removal':
      command => "/usr/bin/rm -rf ${gpfs::params::gpfs_base_directory}",
      onlyif  => "/bin/test -d ${gpfs::params::gpfs_base_directory}",
    }


  }

}


