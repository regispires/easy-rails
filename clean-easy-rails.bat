@echo off
call config.bat
echo Removing directories...
if exist "%SOURCE_DIR%\ruby-%RUBY_VERSION%" rd /s /q "%SOURCE_DIR%\ruby-%RUBY_VERSION%"
if exist "%SOURCE_DIR%\rubygems-%RUBYGEMS_VERSION%" rd /s /q "%SOURCE_DIR%\rubygems-%RUBYGEMS_VERSION%"
rem if exist "%DOWNLOAD_DIR%" rd /s /q "%DOWNLOAD_DIR%"
if exist "%TARGET_DIR%" rd /s /q "%TARGET_DIR%"
echo Directories removed successfully.
