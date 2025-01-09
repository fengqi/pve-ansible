#!/bin/bash

STATUS=running ansible-playbook -i pve update.yml --limit vm
# STATUS=running ansible-playbook -i pve update.yml --limit lxc
