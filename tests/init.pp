# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
#
#
# You can execute this manifest as follows in your vagrant box:
#
#      sudo puppet apply -t /vagrant/tests/init.pp
#
node default {
    class { ::gpfs:
      ensure                => present,
      gpfs_version          => '4.2.3.1',
      gskit_version         => '8.0.50-75',
      read_only             => true,
      server_sshkey_type    => 'ssh-rsa',
      server_sshkey_comment => 'root@gs7k-1-1',
      server_sshkey         => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCrfR6Xw/axFVtUfPucSHK0S1TE+1CUvfCjm2cQm0PIBSNYMrk/h40eoHYeVfDASyAJLKYivCM97wN7gXkkqHVipftZAqWWseVUH/l5zLeoPIowK3I5LL8owrxwosICw/9PLJG3SRsZiKxJHB+QEBRDhUAO8IlD2B5dB9z0oTuvc637f/73BXv1WObCn66UvY1oJ5RZra3QRrgvoOqGXTKhmcwjR6sBNw5D3jqueh48NMVjcSidKLvX7ThW9BpX+Kmm6cgsIsQteyOErqHrwy+T0r5IUzsg3D5j4z6uIRdH+fMa+1n82P/7kaYsfsNXNKQwE947n9SWzEbQG2/jJMtv'
    }
}
