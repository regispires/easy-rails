#!/bin/bash
VERSION=0.9.6
RUBY_VERSION=1.8.7-p302
RUBYGEMS_VERSION=1.3.7
SQLITE_VERSION=3070400
RAILS_VERSION=2.3.10

SOURCE_DIR="$PWD"
TARGET_DIR="$HOME/easy-rails"
DOWNLOAD_DIR="$SOURCE_DIR/downloads"

PATH="$TARGET_DIR/ruby/bin":"$PATH"
GEM_HOME="$TARGET_DIR/ruby/lib/ruby/gems/1.8"
RUBY_HOME="$TARGET_DIR/ruby"
export RUBYLIB="$TARGET_DIR/ruby/lib"
RUBYOPT=

# Creating directories
mkdir -p "$DOWNLOAD_DIR"
mkdir -p "$TARGET_DIR/bin"
mkdir -p "$TARGET_DIR/ruby"
mkdir -p "$TARGET_DIR/sqlite"
mkdir -p "$TARGET_DIR/rails_apps"
chmod a+w "$TARGET_DIR/rails_apps"

# Downloading files
echo Downloading files...
if [ ! -f "$DOWNLOAD_DIR/ruby-$RUBY_VERSION.tar.gz" ]
then
	wget ftp://ftp.ruby-lang.org/pub/ruby/ruby-$RUBY_VERSION.tar.gz -P "$DOWNLOAD_DIR"
fi

if [ ! -f "$DOWNLOAD_DIR/rubygems-$RUBYGEMS_VERSION.zip" ]
then
	wget http://production.cf.rubygems.org/rubygems/rubygems-$RUBYGEMS_VERSION.zip -P "$DOWNLOAD_DIR"
fi

if [ ! -f "$DOWNLOAD_DIR/sqlite-shell-linux-x86-$SQLITE_VERSION.zip" ]
then
	wget http://www.sqlite.org/sqlite-shell-linux-x86-$SQLITE_VERSION.zip -P "$DOWNLOAD_DIR"
fi
echo -e "Files downloaded successfully.\n"

echo Copying Easy-Rails files...
echo $VERSION > "$TARGET_DIR/version.txt"
cp "$SOURCE_DIR"/linux/*.* "$TARGET_DIR"
cp "$SOURCE_DIR"/linux/bin/*.* "$TARGET_DIR/bin"
echo -e "Easy-Rails files copied successfully.\n"

# Compiling and installing Ruby
echo Extracting Ruby source files...
cd "$SOURCE_DIR"
tar xzvf "$DOWNLOAD_DIR/ruby-$RUBY_VERSION.tar.gz"
echo -e "Ruby source files extracted successfully.\n"

echo Compiling Ruby...
cd "ruby-$RUBY_VERSION"
./configure --prefix="$TARGET_DIR/ruby" --build=i686-linux --enable-install-doc
make
echo -e "Ruby compiled successfully.\n"

echo Installing Ruby...
make install
echo -e "Ruby installed successfully.\n"

# Install RubyGems
unzip -q -o "$DOWNLOAD_DIR/rubygems-$RUBYGEMS_VERSION.zip" -d "$SOURCE_DIR"
cd "$SOURCE_DIR/rubygems-$RUBYGEMS_VERSION"
ruby setup.rb --prefix="$TARGET_DIR/ruby" --no-format-executable -V --no-ri --no-rdoc
cd ..

# Update gem script
sed -i "1s|#!$TARGET_DIR/ruby/bin/ruby|#!/usr/bin/env ruby|g" "$TARGET_DIR/ruby/bin/gem"

# Update RubyGems and sources
gem update -V --system --no-ri --no-rdoc
gem sources -V -a http://gems.github.com

# Install gems
gem install rails   -v $RAILS_VERSION -V
gem install mongrel -V
# Database
gem install mysql -V
# gem install pg -V # Main postgresql gem. written in C.
gem install postgres-pr -V # Accessing PostgreSQL from pure Ruby
gem install sqlite3-ruby -V # sqlite3-ruby requires libsqlite3-dev (sudo apt-get install libsqlite3-dev)
# Pagination
# gem install will_paginate -V --no-ri --no-rdoc
# Authentication
# gem install devise -V --no-ri --no-rdoc
# gem install authlogic -V --no-ri --no-rdoc
# Authorization
# gem install cancan -V --no-ri --no-rdoc
# gem install declarative_authorization -V --no-ri --no-rdoc
# Upload management
# gem install paperclip -V --no-ri --no-rdoc
# Calendar date picker
# gem install calendar_date_select -V --no-ri --no-rdoc
# Test
# gem install rspec-rails -V --no-ri --no-rdoc
# gem install cucumber-rails -V --no-ri --no-rdoc
# gem install metric_fu -V --no-ri --no-rdoc
# gem install webrat -V --no-ri --no-rdoc
# Debug
# gem install rails-footnotes -V --no-ri --no-rdoc
# gem install ruby-debug -V --no-ri --no-rdoc
# Code smells
# gem install reek -V --no-ri --no-rdoc
# Admin
# gem install rails-admin -V --no-ri --no-rdoc
# Forms
# gem install simple_form -V --no-ri --no-rdoc
# responders to dry up your Rails 3 app
# gem install responders -V --no-ri --no-rdoc

# Remove old gems
gem cleanup -q -V

# Update ruby scripts
find "$TARGET_DIR/ruby/bin" -type f -exec sed -i "1s|#!$TARGET_DIR/ruby/bin/ruby|#!/usr/bin/env ruby|g" {} \;

# SQLite files
unzip -q -o "$DOWNLOAD_DIR/sqlite-shell-linux-x86-$SQLITE_VERSION.zip" -d "$TARGET_DIR/sqlite"
echo -e "SQLite files extracted successfully.\n"

# Change easy-rails scripts execution mode
chmod a+x "$TARGET_DIR/ruby_console.sh" "$TARGET_DIR"/bin/*

