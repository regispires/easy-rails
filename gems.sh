#!/bin/bash
source ./config.sh
# Update RubyGems and sources
#gem update --system $GEM_OPTIONS # Not working with Ruby 1.9.2
gem sources -a http://gems.github.com

# Install gems
echo Installing gems...
# Installs mongrel prerelease gem (compatible with Ruby 1.9.2)
gem install mongrel --pre $GEM_OPTIONS
# Database gems
gem install sqlite3-ruby $GEM_OPTIONS # sqlite3-ruby requires libsqlite3-dev
gem install mysql2 $GEM_OPTIONS       # mysql2 requires libmysqlclient-dev
gem install pg $GEM_OPTIONS           # pg requires libpq-dev

# Install latest Rails version
echo Installing Rails gems...
gem install rails $GEM_OPTIONS
echo Rails gems installed successfully.
echo Gems installed successfully.

# Remove old gems
echo Removing old gems...
gem cleanup -q
echo Old gems removed successfully.

