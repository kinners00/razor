# Class: razor::dnsmasq_tftp
# Installs dnsmasq and configures it for TFTP only
#
class razor::dnsmasq_tftp {
  # resources
  $razor_content = "# iPXE sets option 175, mark it for network IPXEBOOT
dhcp-match=IPXEBOOT,175
dhcp-boot=net:IPXEBOOT,bootstrap.ipxe
dhcp-boot=undionly-20140116.kpxe
# TFTP setup
enable-tftp
tftp-root=/var/lib/tftpboot"

  file { '/var/lib/tftpboot':
    ensure => 'directory',
    mode   => '0655',
  }
  -> package { 'dnsmasq':
    ensure => 'present',
  }
  -> file { '/etc/dnsmasq.d/razor':
    ensure  => 'file',
    content => $razor_content,
  }
  ~> service { 'dnsmasq':
    ensure => 'running',
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