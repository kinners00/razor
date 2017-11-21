# Class: razor::bootstrap
# Retrieves the Razor bootstrap.ipxe script
#
class razor::bootstrap {
  # resources
  require pe_razor
  
  #package { 'wget':
  #  before => Exec['Download bootstrap.ipxe from Razor server'],
  #  ensure => installed,
  #}
  
  #exec { 'Download bootstrap.ipxe from Razor server':
  #  command => "wget https://${facts['fqdn']}:8151/api/microkernel/bootstrap?nic_max=1&http_port=8150 -O /var/lib/tftpboot/bootstrap.ipxe",
  #  creates => '/var/lib/tftpboot/bootstrap.ipxe',
  #}
  
  file { '/var/lib/tftpboot/bootstrap.ipxe':
    ensure => 'file',
    source => "https://${facts['fqdn']}:8151/api/microkernel/bootstrap?nic_max=1&http_port=8150",
  }
}