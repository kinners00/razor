#!/bin/bash

# See if a node was already discovered with this MAC address
found_node=`razor nodes | grep $PT_mac | awk -F'|' '{ gsub(/ /, "", $0); print $2 }'`
if [ -z $found_node ]
then
  # Node not assumed to be in Razor, register the node and set $razornode to new node item
  razornode=`razor register-node --hw-info net0=$PT_mac --installed false | grep name | awk -F':' '{ gsub(/ /, "", $0); print $2 }'`
else
  # Node already discovered by Razor, set $razornode to existing node item
  razornode=$found_node
fi
razor update-node-metadata --node $razornode --key hostname --value $PT_fqdn

# Update the tag rule or create the tag if it doesn't exist
if [ -z `razor tags | grep $PT_policy`]
then
  # Tag doesn't exist, so create it
  razor create-tag --name $PT_policy --rule '["has_macaddress", "'$PT_mac'"]'
else
  # Tag already exists, update the tag rule
  rule_macs=``
  razor update-tag-rule --name $PT_policy --force --rule '["has_macaddress", "'$rule_macs'"]'
fi





razor add-policy-tag --name $PT_policy --tag $PT_fqdn
razor tags $PT_fqdn policies