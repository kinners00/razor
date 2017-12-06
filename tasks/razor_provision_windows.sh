#!/bin/bash
razor register-node --hw-info net0=$PT_mac --installed false | grep name | gawk


razor create-tag --name $PT_name --rule '["=", ["fact", "macaddress"], "'$PT_mac'"]'
razor add-policy-tag --name $PT_policy --tag $PT_name
razor tags $PT_name nodes