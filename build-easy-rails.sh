#!/bin/bash
# Requires packages: build-essential patch zlib1g-dev libssl-dev libreadline5-dev
#                    libsqlite3-dev libpq-dev libmysqlclient-dev
source ./config.sh

# Creating directories
if [ ! -d "$DOWNLOAD_DIR" ]; then
	mkdir "$DOWNLOAD_DIR"
fi
if [ ! -d "$TARGET_DIR" ]; then
	mkdir "$TARGET_DIR"
fi
if [ ! -d "$TARGET_DIR/bin" ]; then
	mkdir "$TARGET_DIR/bin"
fi
if [ ! -d "$TARGET_DIR/ruby" ]; then
	mkdir "$TARGET_DIR/ruby"
fi
if [ ! -d "$TARGET_DIR/doc" ]; then
	mkdir "$TARGET_DIR/doc"
fi
if [ ! -d "$TARGET_DIR/sqlite" ]; then
	mkdir "$TARGET_DIR/sqlite"
fi
if [ ! -d "$TARGET_DIR/rails_apps" ]; then
	mkdir "$TARGET_DIR/rails_apps"
fi
chmod a+w "$TARGET_DIR/rails_apps"

# Downloading files
echo Downloading files...
if [ ! -f "$DOWNLOAD_DIR/ruby-$RUBY_VERSION.tar.gz" ]; then
	wget ftp://ftp.ruby-lang.org/pub/ruby/ruby-$RUBY_VERSION.tar.gz -P "$DOWNLOAD_DIR"
fi

#if [ ! -f "$DOWNLOAD_DIR/rubygems-$RUBYGEMS_VERSION.tgz" ]; then
#	wget http://production.cf.rubygems.org/rubygems/rubygems-$RUBYGEMS_VERSION.tgz -P "$DOWNLOAD_DIR"
#fi

if [ ! -f "$DOWNLOAD_DIR/sqlite-autoconf-$SQLITE_VERSION.tar.gz" ]; then
	wget http://www.sqlite.org/sqlite-autoconf-$SQLITE_VERSION.tar.gz -P "$DOWNLOAD_DIR"
fi

# Arrow keys are not working with Sqlite linux binaries
#if [ ! -f "$DOWNLOAD_DIR/sqlite-shell-linux-x86-$SQLITE_VERSION.zip" ]; then
#	wget http://www.sqlite.org/sqlite-shell-linux-x86-$SQLITE_VERSION.zip -P "$DOWNLOAD_DIR"
#fi
echo -e "Files downloaded successfully.\n"

echo Copying Easy-Rails files...
echo $VERSION > "$TARGET_DIR/version.txt"
cp "$SOURCE_DIR"/linux/*.txt "$TARGET_DIR"
cp "$SOURCE_DIR"/linux/*.sh  "$TARGET_DIR"
cp "$SOURCE_DIR"/linux/bin/*.sh "$TARGET_DIR/bin"
echo -e "Easy-Rails files copied successfully.\n"

# Compiling and installing Ruby
echo Extracting Ruby source files...
cd "$DOWNLOAD_DIR"
tar xzf "$DOWNLOAD_DIR/ruby-$RUBY_VERSION.tar.gz"
if [ $? -ne 0 ]; then 
    echo Operation could not be completed.
	rm "$DOWNLOAD_DIR/ruby-$RUBY_VERSION.tar.gz"
	exit 1
fi

echo -e "Ruby source files extracted successfully.\n"

echo Compiling Ruby...
cd "ruby-$RUBY_VERSION"
#./configure --prefix="$TARGET_DIR/ruby" --build=i686-linux --enable-install-doc
if [ $? -ne 0 ]; then 
    echo Operation could not be completed.
	exit 1
fi
echo Configure completed. Starting compilation...

#make
if [ $? -ne 0 ]; then 
    echo Operation could not be completed.
	exit 1
fi
echo -e "Ruby compiled successfully.\n"

echo Installing Ruby...
make install
if [ $? -ne 0 ]; then 
    echo Operation could not be completed.
	exit 1
fi
echo -e "Ruby installed successfully.\n"

# Install RubyGems
#echo Extracting RubyGems...
#cd "$DOWNLOAD_DIR"
#tar xzf "$DOWNLOAD_DIR/rubygems-$RUBYGEMS_VERSION.tgz"
#if [ $? -ne 0 ]; then 
#    echo Operation could not be completed.
#	rm "$DOWNLOAD_DIR/rubygems-$RUBYGEMS_VERSION.tgz"
#	exit 1
#fi
#echo -e "RubyGems extracted successfully.\n"

#echo Installing RubyGems...
#cd "$DOWNLOAD_DIR/rubygems-$RUBYGEMS_VERSION"
#ruby setup.rb --prefix="$TARGET_DIR/ruby" --no-format-executable "$GEM_OPTIONS"
#if [ $? -ne 0 ]; then 
#    echo Operation could not be completed.
#	exit 1
#fi
#echo -e "RubyGems installed successfully.\n"
#cd "$DOWNLOAD_DIR"

# Update gem script
sed -i "1s|#!$TARGET_DIR/ruby/bin/ruby|#!/usr/bin/env ruby|g" "$TARGET_DIR/ruby/bin/gem"

# Update RubyGems and sources
cd "$SOURCE_DIR"
./gems.sh

# Update ruby scripts
echo Updating Ruby scripts...
find "$TARGET_DIR/ruby/bin" -type f -exec sed -i "1s|#!$TARGET_DIR/ruby/bin/ruby|#!/usr/bin/env ruby|g" {} \;
echo Ruby scripts updated successfully.

# SQLite files
#echo Extracting SQLite binary files...
#unzip -q -o "$DOWNLOAD_DIR/sqlite-shell-linux-x86-$SQLITE_VERSION.zip" -d "$TARGET_DIR/sqlite"
#if [ $? -ne 0 ]; then 
#    echo Operation could not be completed.
#	rm "$DOWNLOAD_DIR/sqlite-shell-linux-x86-$SQLITE_VERSION.zip"
#	exit 1
#fi
#echo -e "SQLite binary files extracted successfully.\n"

# Compiling SQLite
echo Extracting SQLite source files...
cd "$DOWNLOAD_DIR"
tar xzf "$DOWNLOAD_DIR/sqlite-autoconf-$SQLITE_VERSION.tar.gz"
if [ $? -ne 0 ]; then 
    echo Operation could not be completed.
	rm "$DOWNLOAD_DIR/sqlite-autoconf-$SQLITE_VERSION.tar.gz"
	exit 1
fi

echo -e "SQLite source files extracted successfully.\n"

echo Compiling SQLite...
cd "sqlite-autoconf-$SQLITE_VERSION"
./configure
if [ $? -ne 0 ]; then 
    echo Operation could not be completed.
	exit 1
fi
echo Configure completed. Starting compilation...

make
if [ $? -ne 0 ]; then 
    echo Operation could not be completed.
	exit 1
fi
cp sqlite3 "$TARGET_DIR/sqlite"
echo -e "SQLite compiled successfully.\n"

# Change easy-rails scripts execution mode
chmod a+x "$TARGET_DIR/ruby_console.sh" "$TARGET_DIR"/bin/*

# Generate readme.txt
echo Generating readme.txt file...
echo ----------------    >  "$TARGET_DIR/readme.txt"
echo Easy Rails $VERSION >> "$TARGET_DIR/readme.txt"
echo ----------------    >> "$TARGET_DIR/readme.txt"
cat "$SOURCE_DIR/linux/readme.txt" >> "$TARGET_DIR/readme.txt"
echo Easy Rails $VERSION uses: >> "$TARGET_DIR/readme.txt"
ruby -v   >> "$TARGET_DIR/readme.txt"
rails -v  >> "$TARGET_DIR/readme.txt"
echo -n Sqlite3 >> "$TARGET_DIR/readme.txt"
"$TARGET_DIR/sqlite/sqlite3" -version >> "$TARGET_DIR/readme.txt"
echo >> "$TARGET_DIR/readme.txt"
echo Easy Rails $VERSION also comes installed with the following Gems: >> "$TARGET_DIR/readme.txt"
gem list >> "$TARGET_DIR/readme.txt"
echo readme.txt generated successfully.

# Easy-rails compressed file and md5sum
echo Creating easy-rails compressed file...
cd "$TARGET_DIR"
cd ..
tar czf "easy-rails-linux-$VERSION.tar.gz" easy-rails
if [ $? -ne 0 ]; then 
    echo Operation could not be completed.
	exit 1
fi
echo Easy-rails compressed file created successfully.

echo Creating easy-rails md5sum...
md5sum "easy-rails-linux-$VERSION.tar.gz" > "easy-rails-linux-$VERSION.md5"
if [ $? -ne 0 ]; then 
    echo Operation could not be completed.
	exit 1
fi
echo Easy-rails md5sum created successfully.
cd "$SOURCE_DIR"

