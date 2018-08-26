#! /bin/bash

RUBY_VERSION="2.4.2"

if [ ! -e '/home/vagrant/.rbenv' ]; then
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  source ~/.bash_profile

  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  rbenv install $RUBY_VERSION
  #rbenv rehash
  rbenv global $RUBY_VERSION

  gem install bundle
  gem install wp2txt
fi
