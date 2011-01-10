@echo off
call config.bat
PATH %TARGET_DIR%\ruby\bin;%SOURCE_DIR%\windows\bin;%PATH%

rem Creating directories
if not exist "%DOWNLOAD_DIR%"        md "%DOWNLOAD_DIR%"
if not exist "%TARGET_DIR%\bin"       md "%TARGET_DIR%\bin"
if not exist "%TARGET_DIR%\sqlite"    md "%TARGET_DIR%\sqlite"
if not exist "%TARGET_DIR%\rails_apps" md "%TARGET_DIR%\rails_apps"

rem Downloading files
echo Downloading files...
if not exist "%DOWNLOAD_DIR%\ruby-%RUBY_VERSION%-i386-mingw32.7z"         (wget http://rubyforge.org/frs/download.php/73723/ruby-%RUBY_VERSION%-i386-mingw32.7z -P "%DOWNLOAD_DIR%" && if ERRORLEVEL 1 GOTO Problem)
if not exist "%DOWNLOAD_DIR%\ruby-%RUBY_VERSION%-doc-chm.7z"              (wget http://rubyforge.org/frs/download.php/73724/ruby-%RUBY_VERSION%-doc-chm.7z -P "%DOWNLOAD_DIR%" && if ERRORLEVEL 1 GOTO Problem)
if not exist "%DOWNLOAD_DIR%\sqlite-shell-win32-x86-%SQLITE_VERSION%.zip" (wget http://www.sqlite.org/sqlite-shell-win32-x86-%SQLITE_VERSION%.zip                      -P "%DOWNLOAD_DIR%" && if ERRORLEVEL 1 GOTO Problem)
if not exist "%DOWNLOAD_DIR%\sqlite-dll-win32-x86-%SQLITE_VERSION%.zip"   (wget http://www.sqlite.org/sqlite-dll-win32-x86-%SQLITE_VERSION%.zip                        -P "%DOWNLOAD_DIR%" && if ERRORLEVEL 1 GOTO Problem)
if not exist "%DOWNLOAD_DIR%\Sc%SCITE_VERSION%.exe"                       (wget http://prdownloads.sourceforge.net/scintilla/Sc%SCITE_VERSION%.exe                     -P "%DOWNLOAD_DIR%" && if ERRORLEVEL 1 GOTO Problem)
echo Files downloaded successfully.

echo Copying Easy-Rails files...
echo %VERSION% > "%TARGET_DIR%\version.txt"
copy "%SOURCE_DIR%\windows\*.txt" "%TARGET_DIR%" > NUL
copy "%SOURCE_DIR%\windows\*.bat" "%TARGET_DIR%" > NUL
copy "%SOURCE_DIR%\windows\bin\*.bat" "%TARGET_DIR%\bin" > NUL
copy "%DOWNLOAD_DIR%\Sc%SCITE_VERSION%.exe" "%TARGET_DIR%\bin\scite.exe" > NUL
echo Easy-Rails files copied successfully.

echo Extracting Ruby binaries...
7z x -y "%DOWNLOAD_DIR%\ruby-%RUBY_VERSION%-i386-mingw32.7z" -o"%TARGET_DIR%" > NUL
if ERRORLEVEL 1 (del "%DOWNLOAD_DIR%\ruby-%RUBY_VERSION%-i386-mingw32.7z" && GOTO Problem)
if exist "%TARGET_DIR%\ruby" rd /s /q "%TARGET_DIR%\ruby"
rename "%TARGET_DIR%\ruby-%RUBY_VERSION%-i386-mingw32" ruby
echo Ruby binaries extracted successfully.

echo Extracting Ruby docs...
if not exist "%TARGET_DIR%\ruby\doc"       md "%TARGET_DIR%\ruby\doc"
7z x -y "%DOWNLOAD_DIR%\ruby-%RUBY_VERSION%-doc-chm.7z" -o"%TARGET_DIR%\ruby\doc" > NUL
if ERRORLEVEL 1 (del "%DOWNLOAD_DIR%\ruby-%RUBY_VERSION%-doc-chm.7z" && GOTO Problem)
echo Ruby docs extracted successfully.

echo Extracting shared libs
7z x -y "%SOURCE_DIR%\windows\libs.7z" -o"%TARGET_DIR%\ruby\bin" > NUL
if ERRORLEVEL 1 GOTO Problem
echo Shared libs extracted successfully.

rem Update RubyGems and sources
cd "%SOURCE_DIR%"
call gems.bat

rem Update ruby scripts
echo Updating Ruby scripts...
echo %TARGET_DIR%| sed "s|\\|/|g" > "%TEMP%\targetdir.tmp"
FOR /F "tokens=*" %%i in ('type "%TEMP%\targetdir.tmp"') do set TARGET_DIR2=%%i
find "%TARGET_DIR%\ruby\bin" -iname "*.bat" -exec sed -i "3s|%TARGET_DIR2%/ruby/bin/||g" {} ;
del "%TEMP%\targetdir.tmp"
del "%TARGET_DIR%\ruby\bin\sed*."
echo Ruby scripts updated successfully.

rem SQLite files
echo Extracting SQLite files...
7z x -y "%DOWNLOAD_DIR%\sqlite-shell-win32-x86-%SQLITE_VERSION%.zip" -o"%TARGET_DIR%\sqlite" > NUL
if ERRORLEVEL 1 (del "%DOWNLOAD_DIR%\sqlite-shell-win32-x86-%SQLITE_VERSION%.zip" && GOTO Problem)
7z x -y "%DOWNLOAD_DIR%\sqlite-dll-win32-x86-%SQLITE_VERSION%.zip"   -o"%TARGET_DIR%\sqlite" > NUL
if ERRORLEVEL 1 (del "%DOWNLOAD_DIR%\sqlite-dll-win32-x86-%SQLITE_VERSION%.zip" && GOTO Problem)
echo SQLite files extracted successfully.

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
echo Creating easy-rails self-extracting file...
%TARGET_DRIVE%
cd "%TARGET_DIR%"
cd ..
7z a -sfx7z.sfx "easy-rails-%VERSION%.exe" "%TARGET_DIR%" > NUL
if ERRORLEVEL 1 GOTO Problem
echo Easy-rails self-extracting file created successfully.

echo Creating easy-rails md5sum...
md5sum.exe "easy-rails-%VERSION%.exe" > "easy-rails-%VERSION%.md5"
if ERRORLEVEL 1 GOTO Problem
echo Easy-rails md5sum created successfully.
%SOURCE_DRIVE%
cd "%SOURCE_DIR%"

GOTO :EOF

:Problem
echo Operation could not be completed.
GOTO :EOF

:EOF
