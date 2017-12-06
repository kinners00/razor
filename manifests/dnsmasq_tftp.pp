# Class: razor::dnsmasq_tftp
# Installs dnsmasq and configures it for TFTP only
#
class razor::dnsmasq_tftp {
  # resources
  $dnsmasq_dhcp_content = "listen-address=172.16.66.5
listen-address=127.0.0.1
no-dhcp-interface=lo
server=172.16.66.1
local=/puppet.vm/
no-hosts
no-resolv
domain=puppet.vm
dhcp-fqdn
dhcp-range=172.16.66.100,172.16.66.200,12h
dhcp-authoritative
dhcp-option=option:router,172.16.66.2
dhcp-option=option:dns-server,172.16.66.1"

  $razor_content = "# Boot logic
dhcp-match=set:EFI,option:client-arch,7
dhcp-boot=tag:EFI,ipxe.efi

dhcp-match=set:iPXE,175
dhcp-boot=tag:iPXE,bootstrap.ipxe

dhcp-boot=undionly-20140116.kpxe
# TFTP setup
enable-tftp
tftp-root=/var/lib/tftpboot"

  file { '/var/lib/tftpboot':
    ensure => 'directory',
    seltype => 'tftpdir_rw_t',
    mode   => '0655',
  }
  -> file { '/var/lib/tftpboot/undionly-20140116.kpxe':
    ensure  => 'file',
    seltype => 'tftpdir_rw_t',
    source  => 'https://s3.amazonaws.com/pe-razor-resources/undionly-20140116.kpxe',
  }
  -> file { '/var/lib/tftpboot/ipxe.efi':
    ensure  => 'file',
    seltype => 'tftpdir_rw_t',
    source  => 'http://boot.ipxe.org/ipxe.efi',
  }
  -> package { 'dnsmasq':
    ensure => 'present',
  }
  -> file { '/etc/dnsmasq.d/razor':
    ensure  => 'file',
    content => $razor_content,
    notify  => Service['dnsmasq'],
  }
  -> file { '/etc/dnsmasq.d/dhcp':
    ensure  => 'file',
    content => $dnsmasq_dhcp_content,
    notify  => Service['dnsmasq'],
  }
  -> service { 'dnsmasq':
    ensure => 'running',
    enable => true,
  }

  package { 'policycoreutils-python':
    ensure  => 'present',
    require => File['/var/lib/tftpboot'],
  }
  -> exec { 'Define SELinux tftpdir_t file type for tftpboot folder':
    command => '/usr/sbin/semanage fcontext -a -t tftpdir_t "/var/lib/tftpboot(/.*)?"',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    unless  => 'ls -Z /var/lib | grep tftpboot | grep tftpdir_',
  }
  -> exec { 'Apply SELinux tftpdir_t file type to tftpboot folder hierarchy':
    before  => Service['dnsmasq'],
    command => '/sbin/restorecon -R -v /var/lib/tftpboot',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    unless  => 'ls -Z /var/lib | grep tftpboot | grep tftpdir_',
  }
}