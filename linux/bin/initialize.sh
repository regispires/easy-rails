#!/bin/bash
export PATH="$PWD/bin:$PWD/ruby/bin":"$PWD/sqlite":"$PATH"
export GEM_HOME="$PWD/ruby/lib/ruby/gems/1.8"
export RUBY_HOME="$PWD/ruby"
export RUBYLIB="$PWD/ruby/lib:$PWD/ruby/lib/ruby:$PWD/ruby/lib/ruby/1.8:$PWD/ruby/lib/ruby/1.8/i686-linux:$PWD/ruby/lib/ruby/site_ruby:$PWD/ruby/lib/ruby/site_ruby/1.8:$PWD/ruby/lib/ruby/site_ruby/1.8/i686-linux"
export RUBYOPT=
export PS1="\[\033[31m\]EasyRails\[\033[0m\]:\w\$ "
export LD_LIBRARY_PATH="$PWD/sqlite/libs/":"$LD_LIBRARY_PATH"
alias ls='ls --color=auto'
echo Easy Rails Linux `cat version.txt`
echo -n "SQLite "
sqlite3 -version
ruby -v
rails -v
cd rails_apps
