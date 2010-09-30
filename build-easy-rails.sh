#!/bin/bash
SOURCE_DIR="$PWD"
TARGET_DIR=/opt/easy-rails
SQLITE=3.6.16
RUBYGEMS=rubygems-1.3.5
RUBY=ruby-1.8.7-p174

# Creating directories
sudo mkdir "$TARGET_DIR"
sudo mkdir "$TARGET_DIR/bin"
sudo mkdir "$TARGET_DIR/sqlite"
sudo mkdir "$TARGET_DIR/sqlite/libs"
sudo mkdir "$TARGET_DIR/rails_apps"
sudo chmod a+w "$TARGET_DIR/rails_apps"

# Copying files
sudo cp linux/initialize.sh "$RUBYGEMS.zip" "$TARGET_DIR/bin/"
sudo cp linux/ruby_console.sh linux/*.txt "$TARGET_DIR"
sudo cp -r extra/* "$TARGET_DIR"
sudo cp linux/sqlite*.bin.gz "$TARGET_DIR/sqlite/"
sudo cp linux/sqlite*.so.gz "$TARGET_DIR/sqlite/libs/"

# Uncompressing SQLite
sudo gunzip -f "$TARGET_DIR/sqlite/sqlite3-$SQLITE.bin.gz"
sudo gunzip -f "$TARGET_DIR/sqlite/libs/sqlite-$SQLITE.so.gz"

# Creating SQLite symbolic links
cd "$TARGET_DIR/sqlite"
sudo ln -s "sqlite3-$SQLITE.bin" sqlite3
cd "$TARGET_DIR/sqlite/libs"
sudo ln -s sqlite-$SQLITE.so libsqlite3.so

# Compiling and installing Ruby
cd "$SOURCE_DIR/linux"
sudo tar jxvf "$RUBY.tar.bz2"
cd "$RUBY"
sudo ./configure --prefix "$TARGET_DIR/ruby/"
sudo make
sudo make install
sudo make install-doc

# Running Ruby Console
cd "$TARGET_DIR"
./ruby_console.sh

