@echo off
call config.bat
echo Removing directories and files...
if exist "%SOURCE_DIR%\ruby-%RUBY_VERSION%" rd /s /q "%SOURCE_DIR%\ruby-%RUBY_VERSION%"
if exist "%SOURCE_DIR%\rubygems-%RUBYGEMS_VERSION%" rd /s /q "%SOURCE_DIR%\rubygems-%RUBYGEMS_VERSION%"
if exist "%DOWNLOAD_DIR%" rd /s /q "%DOWNLOAD_DIR%"
if exist "%TARGET_DIR%" rd /s /q "%TARGET_DIR%"
if exist "%TARGET_DIR%\..\easy-rails-%VERSION%.exe" del "%TARGET_DIR%\..\easy-rails-%VERSION%.exe"
if exist "%TARGET_DIR%\..\easy-rails-%VERSION%.md5" del "%TARGET_DIR%\..\easy-rails-%VERSION%.md5"
echo Directories and files removed successfully.

