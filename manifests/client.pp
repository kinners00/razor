# Class: razor::client
# Installs the Razor client gem
#
class razor::client {
  # resources
  package { 'rubygems':
    ensure => present,
  }

  package { 'pe-razor-client':
    ensure   => 'present',
    provider => gem,
    require  => Package['rubygems'],
  }
}