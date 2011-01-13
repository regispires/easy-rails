#!/bin/bash
source ./config.sh
echo Removing directories and files...
if [ -d "$SOURCE_DIR/ruby-$RUBY_VERSION" ]; then
	rm -rf "$SOURCE_DIR/ruby-$RUBY_VERSION"
fi

if [ -d "$SOURCE_DIR/rubygems-$RUBYGEMS_VERSION" ]; then
	rm -rf "$SOURCE_DIR/rubygems-$RUBYGEMS_VERSION"
fi

if [ -d "$DOWNLOAD_DIR" ]; then
	rm -rf "$DOWNLOAD_DIR"
fi

if [ -d "$TARGET_DIR" ]; then
	rm -rf "$TARGET_DIR"
fi

if [ -f "$TARGET_DIR/../easy-rails-$VERSION.tar.gz" ]; then
	rm -rf "$TARGET_DIR/../easy-rails-$VERSION.tar.gz"
fi

if [ -f "$TARGET_DIR/../easy-rails-$VERSION.md5" ]; then
	rm -rf "$TARGET_DIR/../easy-rails-$VERSION.md5"
fi

echo Directories and files removed successfully.

