systemctl disable firewalld
setenforce 0
cd /provision_data
tar -xf puppet-enterprise-2018.1.0-el-7-x86_64.tar.gz
cd puppet-enterprise-2018.1.0-el-7-x86_64
./puppet-enterprise-installer -y -c /provision_data/pe.conf
echo "\n\nPuppet Enterprise Installation Complete!! Woohoo!"
echo "\n\nMoving SSH private key for control repo..."
mkdir /etc/puppetlabs/puppetserver/ssh
mv /provision_data/id-control_repo.rsa /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa
echo "\n\nRunning Puppet Agent for first time...fingers crossed."
hash -r
/opt/puppetlabs/bin/puppet agent -t

echo "\n\nTesting Puppet's Access to BitBucket Repository"
/opt/puppetlabs/bin/puppet-access login admin password netsmart --lifetime 10y
/opt/puppetlabs/bin/puppet-code deploy --dry-run
/opt/puppetlabs/bin/puppet-code deploy lab --wait