# Class: razor::bootstrap
# Retrieves the Razor bootstrap.ipxe script
#
class razor::bootstrap {
  # resources
  require pe_razor
  
  file { '/var/lib/tftpboot/bootstrap.ipxe':
    ensure => 'file',
    source => "https://$facts['fqdn']:8151/api/microkernel/bootstrap?nic_max=1&http_port=8150",
  }
}