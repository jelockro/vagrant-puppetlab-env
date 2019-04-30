#!/bin/bash
systemctl disable firewalld
setenforce 0

if ps aux | grep -q "puppet master" | grep -v grep
then
    echo "Puppet Master is already installed. Exiting..."
else
    # Configure /etc/hosts file
    echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.5    puppetmaster.debug.vlan  puppet" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.10   node01.debug.vlan  node01" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.20   node02.debug.vlan node02" | sudo tee --append /etc/hosts 2> /dev/null
    
    # Install Puppet Master
    cd /provision_data
    tar -xf puppet-enterprise-2018.1.0-el-7-x86_64.tar.gz
    cd puppet-enterprise-2018.1.0-el-7-x86_64
    ./puppet-enterprise-installer -y -c /provision_data/pe.conf
    echo -e  "\n\nPuppet Enterprise Installation Complete!! Woohoo!"
    
    # Move SSH private Keys for bitbucket 
    echo  -e "\n\nMoving SSH private key for control repo..."
    mkdir /etc/puppetlabs/puppetserver/ssh
    mv /provision_data/id-control_repo.rsa /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa
    
    # Run Puppet Agent twice 
    echo -e "\n\nRunning Puppet Agent for first time...fingers crossed."
    hash -r
    
    

#    /opt/puppetlabs/bin/puppet agent -t
#    /opt/puppetlabs/bin/puppet agent -t
fi
   # echo "\n\nTesting Puppet's Access to BitBucket Repository"
# /opt/puppetlabs/bin/puppet-access login admin password netsmart --lifetime 10y
# /opt/puppetlabs/bin/puppet-code deploy --dry-run
# /opt/puppetlabs/bin/puppet-code deploy lab --wait