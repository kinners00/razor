#!/bin/bash
razor create-tag --name $PT_name --rule '["=", ["fact", "macaddress"], "'$PT_mac'"]'
razor add-policy-tag --name $PT_policy --tag $PT_name
razor tags $PT_name nodes