rem Update RubyGems and sources
call gem sources -a http://gems.github.com

rem Install gems
echo Installing gems...
rem Installs mongrel prerelease gem
call gem install mongrel --pre "%GEM_OPTIONS%"
rem Database gems
call gem install sqlite3-ruby "%GEM_OPTIONS%"
call gem install mysql2 "%GEM_OPTIONS%"
call gem install pg -v 0.9.0 "%GEM_OPTIONS%"
rem Install latest Rails version
echo Installing Rails gems...
call gem install rails "%GEM_OPTIONS%"
echo Rails gems installed successfully.
echo Gems installed successfully.

rem Remove old gems
echo Removing old gems...
call gem cleanup -q
echo Old gems removed successfully.
