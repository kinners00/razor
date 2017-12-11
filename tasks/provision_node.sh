#!/bin/bash

# See if a node was already discovered with this MAC address
echo "Searching for node with MAC address $PT_mac..."
found_node=`razor nodes | grep $PT_mac | awk -F'|' '{ gsub(/ /, "", $0); print $2 }'`
if [ -z $found_node ]
then
  # Node not assumed to be in Razor, register the node and set $razornode to new node item
  echo "Node not found, creating node..."
  razornode=`razor register-node --hw-info net0=$PT_mac --installed false | grep name | awk -F':' '{ gsub(/ /, "", $0); print $2 }'`
else
  # Node already discovered by Razor, set $razornode to existing node item and clear installed flag
  echo "Node found, clearing install flag..."
  razornode=$found_node
  razor reinstall-node --name $razornode
fi
echo "Setting hostname to $PT_fqdn..."
razor update-node-metadata --node $razornode --key hostname --value $PT_fqdn

# Update the tag rule or create the tag if it doesn't exist
tagname=${PT_policy}_tag
echo "Searching for tag with name $tagname..."
if [ -z `razor tags | grep $tagname` ]
then
  # Tag doesn't exist, so create it and add it to the policy
  echo "Tag not found, creating tag..."
  razor create-tag --name $tagname --rule '["has_macaddress", "'$PT_mac'"]'
  echo "Adding tag to razor policy $PT_policy..."
  razor add-policy-tag --name $PT_policy --tag $tagname
else
  # Tag already exists, check if it uses the correct rule
  echo "Tag found, checking the tag rule type..."
  if [ -z `razor tags $tagname | grep "rule: \[\"has_macaddress\", "` ]
  then
    echo "The razor tag rule $tagname is not configured to exclusively use has_macaddress! Canceling modification of the rule..."
    exit 1
  else
    # Tag rule is correct, check if the rule needs updating
    if [ -z `razor tags $tagname | grep "rule: \[\"has_macaddress\", " | grep $PT_mac ]
    then
      echo "Tag rule type is correct, updating rule to include MAC address $PT_mac..."
      new_rule_macs=`razor tags $tagname | grep "rule: \[\"has_macaddress\", " | awk -F, ' { $NF = substr($NF, 1, length($NF)-1); for (i=2; i<NF; i++) printf $i ", "; print $NF",", "\"'$PT_mac'\"" }'`
      new_rule='["has_macaddress", '$new_rule_macs']'
      razor update-tag-rule --name $tagname --force --rule "$new_rule"
    else
      echo "Tag rule type is correct, and MAC address $PT_mac is already part of the rule; nothing to do."
    fi
  fi
fi