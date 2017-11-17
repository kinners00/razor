# Class: razor::fwports
# Creates firewall port exceptions for Razor
#
class razor::fwports {
  # resources
  firewall { '100 allow Razor HTTP comms':
    dport  => 8150,
    proto  => tcp,
    action => accept,
  }->
  firewall { '101 allow Razor HTTPS comms':
    dport  => 8151,
    proto  => tcp,
    action => accept,
  }
}