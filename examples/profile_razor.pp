# Class: profile::razor
# Installs Razor and it's prereqs
#
class profile::razor {
  # resources
  include razor::dnsmasq_tftp
  include razor::fwports
  include pe_razor
  include razor::bootstrap
  include razor::client
}
