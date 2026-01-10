#!/bin/bash

# Create the vagrant user (if it doesn't exist) and set up passwordless sudo
# (Note: password setup can be more complex, this is a basic example)
if ! id "vagrant" >/dev/null 2>&1; then
   useradd -m vagrant
   # Optional: set a default password for the user, e.g., 'vagrant'
   # echo "vagrant:vagrant" | chpasswd
fi

# Enable passwordless sudo for the vagrant user
echo 'vagrant' | sudo -S sh -c "echo  'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant"
sudo chmod 0440 /etc/sudoers.d/vagrant

# Install the insecure Vagrant public key
mkdir -pm 700 /home/vagrant/.ssh
sudo -S apt update
sudo -S apt install -y curl
curl -Lo /home/vagrant/.ssh/authorized_keys 'https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub'
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
