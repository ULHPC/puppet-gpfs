# File::      <tt>params.pp</tt>
# Author::    UL HPC Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2017 UL HPC Team
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# You need the 'future' parser to be able to execute this manifest (that's
# required for the each loop below).
#
# Thus execute this manifest in your vagrant box as follows:
#
#      sudo puppet apply -t --parser future /vagrant/tests/params.pp
#
#

include 'gpfs::params'

$names = ["ensure", "protocol", "port", "packagename"]

notice("gpfs::params::ensure = ${gpfs::params::ensure}")
notice("gpfs::params::protocol = ${gpfs::params::protocol}")
notice("gpfs::params::port = ${gpfs::params::port}")
notice("gpfs::params::packagename = ${gpfs::params::packagename}")

#each($names) |$v| {
#    $var = "gpfs::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}
