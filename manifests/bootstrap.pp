# Class: razor::bootstrap
# Retrieves the Razor bootstrap.ipxe script
#
class razor::bootstrap {
  # resources
  require pe_razor
  
  package { 'wget':
    before => Exec['Download bootstrap.ipxe from Razor server'],
    ensure => installed,
  }
  
  host { 'razor.inf.puppet.vm':
    before => Exec['Download bootstrap.ipxe from Razor server'],
    ip => $facts['ipaddress'],
  }
  
  exec { 'Download bootstrap.ipxe from Razor server':
    command => "/usr/bin/wget -k https://${facts['fqdn']}:8151/api/microkernel/bootstrap?nic_max=1&http_port=8150 -O /var/lib/tftpboot/bootstrap.ipxe",
    creates => '/var/lib/tftpboot/bootstrap.ipxe',
  }
}