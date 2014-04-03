#!/usr/bin/env bash

# ruby, java, git, curl and couchdb
apt-get update
apt-get install aptitude wget curl git tmux vim libxslt-dev libxml2-dev ruby ruby1.9.1-dev libssl-dev couchdb libgd2-noxpm -y

# config ruby gems to https
gem sources -r http://rubygems.org
gem sources -r http://rubygems.org/
gem sources -a https://rubygems.org

# add rbenv
su vagrant -c 'git clone https://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv'
su vagrant -c 'echo export PATH="/home/vagrant/.rbenv/bin:\$PATH" >> /home/vagrant/.profile'
su vagrant -c 'echo eval \"\$\(rbenv init -\)\" >> /home/vagrant/.profile'
su vagrant -c 'git clone https://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build'

# initial config of app
su vagrant -lc 'cd /vagrant && rbenv install $(cat .ruby-version) && rbenv rehash'
su vagrant -lc 'cd /vagrant && gem install rspec && rbenv rehash'

# setup couchdb
curl -X PUT "http://localhost:5984/test"
echo 'echo $(date) > /var/log/rc.log' > /etc/rc.log
echo "service couchdb start >> /var/log/rc.log 2>&1 " >> /etc/rc.local

