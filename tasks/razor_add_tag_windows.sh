#!/bin/bash
razor create-tag --name $PT_name --rule '["=", ["fact", "macaddress"], '"$PT_mac"']'
razor add-policy-tag --name win2016 --tag $PT_name
