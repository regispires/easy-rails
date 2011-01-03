rem Update RubyGems and sources
call gem update  --system "%GEM_OPTIONS%"
call gem sources -a http://gems.github.com

rem Install gems
echo Installing gems...
call gem install mongrel "%GEM_OPTIONS%"
rem Database gems
call gem install sqlite3-ruby "%GEM_OPTIONS%"
call gem install mysql "%GEM_OPTIONS%"
call gem install postgres-pr "%GEM_OPTIONS%"
echo Gems installed successfully.

rem Remove old gems
echo Removing old gems...
call gem cleanup -q
echo Old gems removed successfully.

rem Install Rails %RAILS_VERSION%
echo Installing Rails %RAILS_VERSION%...
call gem install rails -v %RAILS_VERSION% "%GEM_OPTIONS%"
echo Rails %RAILS_VERSION% installed successfully.

rem Install latest Rails version
echo Installing latest Rails version
call gem install rails "%GEM_OPTIONS%"
echo Rails latest version installed successfully.
