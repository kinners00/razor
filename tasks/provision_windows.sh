#!/bin/bash
nodename=`razor register-node --hw-info net0=$PT_mac --installed false | grep name | awk -F':' '{ gsub(/ /, "", $0); print $2 }'`
razor update-node-metadata --node $nodename --key hostname --value $PT_fqdn
razor create-tag --name $PT_fqdn --rule '["=", ["fact", "macaddress"], "'$PT_mac'"]'
razor add-policy-tag --name $PT_policy --tag $PT_fqdn
razor tags $PT_fqdn policies