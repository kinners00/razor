# Class: razor::fwports
# Creates firewall port exceptions for Razor
#
class razor::fwports {
  # resources
  require iptables
  
  firewall { '100 allow Razor HTTP comms':
    dport  => 8150,
    proto  => tcp,
    action => accept,
  }->
  firewall { '101 allow Razor HTTPS comms':
    dport  => 8151,
    proto  => tcp,
    action => accept,
  }->
  firewall { '102 allow DHCP comms':
    dport  => 67,
    proto  => udp,
    action => accept,
  }->
  firewall { '103 allow DHCP comms':
    dport  => 68,
    proto  => udp,
    action => accept,
  }->
  firewall { '104 allow TFTP comms':
    dport  => 69,
    proto  => udp,
    action => accept,
  }->
  firewall { '105 allow Samba - NetBIOS Name Service':
    dport  => 137,
    proto  => udp,
    action => accept,
  }->
  firewall { '106 allow Samba - NetBIOS Datagram Service':
    dport  => 138,
    proto  => udp,
    action => accept,
  }->
  firewall { '107 allow Samba - NetBIOS Session Service':
    dport  => 139,
    proto  => tcp,
    action => accept,
  }->
  firewall { '108 allow Samba - Microsoft Directory Service':
    dport  => 445,
    proto  => tcp,
    action => accept,
  }
  
}