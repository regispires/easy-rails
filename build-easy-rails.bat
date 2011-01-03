@echo off
call config.bat
PATH %TARGET_DIR%\ruby\bin;%SOURCE_DIR%\windows\bin;%PATH%

rem Creating directories
if not exist "%DOWNLOAD_DIR%"        md "%DOWNLOAD_DIR%"
if not exist "%TARGET_DIR%\bin"       md "%TARGET_DIR%\bin"
if not exist "%TARGET_DIR%\ruby"      md "%TARGET_DIR%\ruby"
if not exist "%TARGET_DIR%\sqlite"    md "%TARGET_DIR%\sqlite"
if not exist "%TARGET_DIR%\rails_apps" md "%TARGET_DIR%\rails_apps"

rem Downloading files
echo Downloading files...
if not exist "%DOWNLOAD_DIR%\ruby-%RUBY_VERSION%-i386-mswin32.zip"        (wget ftp://ftp.ruby-lang.org/pub/ruby/binaries/mswin32/ruby-%RUBY_VERSION%-i386-mswin32.zip -P "%DOWNLOAD_DIR%" && if ERRORLEVEL 1 GOTO Problem)
if not exist "%DOWNLOAD_DIR%\sqlite-shell-win32-x86-%SQLITE_VERSION%.zip" (wget http://www.sqlite.org/sqlite-shell-win32-x86-%SQLITE_VERSION%.zip                      -P "%DOWNLOAD_DIR%" && if ERRORLEVEL 1 GOTO Problem)
if not exist "%DOWNLOAD_DIR%\sqlite-dll-win32-x86-%SQLITE_VERSION%.zip"   (wget http://www.sqlite.org/sqlite-dll-win32-x86-%SQLITE_VERSION%.zip                        -P "%DOWNLOAD_DIR%" && if ERRORLEVEL 1 GOTO Problem)
if not exist "%DOWNLOAD_DIR%\Sc%SCITE_VERSION%.exe"                       (wget http://prdownloads.sourceforge.net/scintilla/Sc%SCITE_VERSION%.exe                     -P "%DOWNLOAD_DIR%" && if ERRORLEVEL 1 GOTO Problem)
if not exist "%DOWNLOAD_DIR%\rubygems-%RUBYGEMS_VERSION%.zip"             (wget http://production.cf.rubygems.org/rubygems/rubygems-%RUBYGEMS_VERSION%.zip             -P "%DOWNLOAD_DIR%" && if ERRORLEVEL 1 GOTO Problem)
echo Files downloaded successfully.

echo Copying Easy-Rails files...
echo %VERSION% > "%TARGET_DIR%\version.txt"
copy "%SOURCE_DIR%\windows\*.txt" "%TARGET_DIR%" > NUL
copy "%SOURCE_DIR%\windows\*.bat" "%TARGET_DIR%" > NUL
copy "%SOURCE_DIR%\windows\bin\*.bat" "%TARGET_DIR%\bin" > NUL
copy "%DOWNLOAD_DIR%\Sc%SCITE_VERSION%.exe" "%TARGET_DIR%\bin\scite.exe" > NUL
echo Easy-Rails files copied successfully.

echo Extracting Ruby files...
unzip -q -o "%DOWNLOAD_DIR%\ruby-%RUBY_VERSION%-i386-mswin32.zip" -d "%TARGET_DIR%\ruby"
if ERRORLEVEL 1 (del "%DOWNLOAD_DIR%\ruby-%RUBY_VERSION%-i386-mswin32.zip" && GOTO Problem)
echo Ruby files extracted successfully.

echo Extracting shared libs
unzip -q -o "%SOURCE_DIR%\windows\libs.zip" -d "%TARGET_DIR%\ruby\bin"
if ERRORLEVEL 1 GOTO Problem
echo Shared libs extracted successfully.

rem Install RubyGems
unzip -q -o "%DOWNLOAD_DIR%\rubygems-%RUBYGEMS_VERSION%.zip" -d "%SOURCE_DIR%"
if ERRORLEVEL 1 (del "%DOWNLOAD_DIR%\rubygems-%RUBYGEMS_VERSION%.zip" && GOTO Problem)
cd "%SOURCE_DIR%\rubygems-%RUBYGEMS_VERSION%"
ruby setup.rb --no-format-executable --no-ri --no-rdoc

rem Update RubyGems and sources
cd "%SOURCE_DIR%"
call gems.bat

rem Update ruby scripts
echo Updating Ruby scripts...
echo %TARGET_DIR%| sed "s|\\|/|g" > "%TEMP%\targetdir.tmp"
FOR /F "tokens=*" %%i in ('type targetdir.tmp') do set TARGET_DIR2=%%i
find "%TARGET_DIR%\ruby\bin" -iname "*.bat" -exec sed -i "3s|%TARGET_DIR2%/ruby/bin/||g" {} ;
del "%TEMP%\targetdir.tmp"
del "%TARGET_DIR%\ruby\bin\sed*."
echo Ruby scripts updated successfully.

rem SQLite files
echo Extracting SQLite files...
unzip -q -o "%DOWNLOAD_DIR%\sqlite-shell-win32-x86-%SQLITE_VERSION%.zip" -d "%TARGET_DIR%\sqlite"
if ERRORLEVEL 1 (del "%DOWNLOAD_DIR%\sqlite-shell-win32-x86-%SQLITE_VERSION%.zip" && GOTO Problem)
unzip -q -o "%DOWNLOAD_DIR%\sqlite-dll-win32-x86-%SQLITE_VERSION%.zip"   -d "%TARGET_DIR%\sqlite"
if ERRORLEVEL 1 (del "%DOWNLOAD_DIR%\sqlite-dll-win32-x86-%SQLITE_VERSION%.zip" && GOTO Problem)
echo SQLite files extracted successfully.

rem Mongrel Ctrl+C issue in Windows
echo Solving Mongrel Ctrl+C issue...
if exist "%MONGREL_LIB_DIR%\mongrel.rb.original" copy "%MONGREL_LIB_DIR%\mongrel.rb.original" "%MONGREL_LIB_DIR%\mongrel.rb"
if exist "%MONGREL_LIB_DIR%\mongrel.rb" (sed -i.original "s/yield server  if block_given?/yield server  if block_given?;trap(\"INT\") { server.stop };$mongrel_sleeper_thread = Thread.new { loop { sleep 1 } }/g" "%MONGREL_LIB_DIR%\mongrel.rb" && echo Mongrel Ctrl+C issue solved.) else (echo mongrel.rb not found.)

rem Generate readme.txt
echo Generating readme.txt file...
echo ----------------      >  "%TARGET_DIR%\readme.txt"
echo Easy Rails %VERSION% >> "%TARGET_DIR%\readme.txt"
echo ----------------      >> "%TARGET_DIR%\readme.txt"
type "%SOURCE_DIR%\windows\readme.txt" >> "%TARGET_DIR%\readme.txt"
echo Easy Rails %VERSION% uses: >> "%TARGET_DIR%\readme.txt"
ruby -v   >> "%TARGET_DIR%\readme.txt"
call rails -v  >> "%TARGET_DIR%\readme.txt"
FOR /F "tokens=*" %%i in ('"%TARGET_DIR%\sqlite\sqlite3" -version') do set SQLITE_VERSION2=%%i 
echo Sqlite3 %SQLITE_VERSION2% >> "%TARGET_DIR%\readme.txt"
echo Scite %SCITE_VERSION% >> "%TARGET_DIR%\readme.txt"
echo. >> "%TARGET_DIR%\readme.txt"
echo Easy Rails %VERSION% also comes installed with the following Gems: >> "%TARGET_DIR%\readme.txt"
call gem list >> "%TARGET_DIR%\readme.txt"
echo readme.txt generated successfully.

rem Easy-rails self-extracting file and md5sum
echo Generating easy-rails self-extracting file...
%TARGET_DRIVE%
cd "%TARGET_DIR%"
cd ..
7z a -sfx7z.sfx "easy-rails-%VERSION%.exe" "%TARGET_DIR%" > NUL
if ERRORLEVEL 1 GOTO Problem
echo Easy-rails self-extracting file generated successfully.
echo Generating easy-rails md5sum...
md5sum.exe "easy-rails-%VERSION%.exe" > "easy-rails-%VERSION%.md5"
if ERRORLEVEL 1 GOTO Problem
echo Easy-rails md5sum generated successfully.
%SOURCE_DRIVE%
cd "%SOURCE_DIR%"

GOTO End

:Problem
echo Operation could not be completed.
GOTO End

:End
