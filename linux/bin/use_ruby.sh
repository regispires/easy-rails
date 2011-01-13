#!/bin/bash
export PATH="$PWD/ruby/bin":"$PWD/bin":"$PWD/sqlite":"$PATH"
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
