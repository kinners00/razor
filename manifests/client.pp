# Class: razor::client
# Installs the Razor client gem
#
class razor::client {
  # resources
  package { 'pe-razor-client':
    ensure   => 'present',
    provider => gem,
  }
}