#!/usr/bin/env bash
PROJECT_DIR=`pwd`

# Configure libvirt for kolla

# Stop Libvirtd
systemctl stop libvirtd.service
systemctl disable libvirtd.service

# Stop Libvirt-guests
systemctl stop libvirt-guests.service
systemctl disable libvirt-guests.service

# Stop virtlockd
systemctl stop virtlockd.service
systemctl disable virtlockd.service

# Stop virtlockd-admin
systemctl stop virtlockd-admin.service
systemctl disable virtlockd-admin.service

# Open-Iscsi
systemctl stop open-iscsi.service
systemctl dsiable open-iscsi.service

systemctl stop iscsid.service
systemctl disable iscsid.service

# Disable Apparmor libvirt profile
apparmor_parser -R /etc/apparmor.d/usr.sbin.libvirtd


# Change to /opt and get sources
cd /opt
git clone https://opendev.org/openstack/kolla
git clone https://opendev.org/openstack/kolla-ansible

# Install Kolla and Kolla-ansible
pip install -U ansible
pip install ./kolla/
pip install ./kolla-ansible/

# Prep the Kolla configuration directory
mkdir -p /etc/kolla/config

# Copy the base templates
cp -R kolla-ansible/etc/kolla/* /etc/kolla

# Copy the kolla-build.conf to /etc/kolla
cp /usr/local/share/kolla/etc_examples/oslo-config-generator/kolla-build.conf /etc/kolla/

# Get the Working Globals.yml
# wget https://raw.githubusercontent.com/AmpereComputing/openstack-kolla-aio-scripts/master/etc/kolla/globals.yml -O /etc/kolla/globals.yml
cd $PROJECT_DIR
cp ./globals.yml /etc/kolla/globals.yml

# Create /etc/kolla/config/global.conf

cat << EOF > /etc/kolla/config/magnum.conf
# Adjust Magnum configuration to allow for fedora-atomic k8s templates
#[trust]
#cluster_user_trust = True
#cloud_provider_enabled = True
EOF


