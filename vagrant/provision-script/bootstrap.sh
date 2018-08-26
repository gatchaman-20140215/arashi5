#! /bin/bash

systemctl stop firewalld
systemctl disable firewalld

yum -y install git readline-devel zlib-devel bison flex openssl-devel gcc-c++

yum install -y wget

su - vagrant -c '/bin/bash /vagrant/vagrant/provision-script/rbenv.sh'
