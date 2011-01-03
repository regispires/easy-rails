@echo off
PATH %CD%\ruby\bin;%CD%\bin;%CD%\sqlite;%PATH%
set RUBYOPT=
set /p VERSION=< version.txt
FOR /F "tokens=*" %%i in ('sqlite3 -version') do set SQLITE_VERSION=%%i 
cd rails_apps
echo Easy Rails %VERSION%
echo SQLite %SQLITE_VERSION%
set VERSION=
set SQLITE_VERSION=
ruby -v
rails -v
