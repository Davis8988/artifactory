@echo off

set package_name=dohq_artifactory_elbit

:: CD to root (where setup.py is located)
pushd "%~dp0..\.."

:: Print instructions
echo.
echo This script will:
echo  - Update 'setuptools' and 'wheel' packages
echo  - Remove "%cd%\dist" dir
echo  - Compile %package_name% dist
echo.

:: Ask if sure
CHOICE /C YN /M "Are you sure"
if %errorlevel% equ 2 echo Aborting.. && exit 0

:: Do Not Change
set compile_error_msg=Error - Failed to compile "%package_name%" dist

title Compile %package_name% dist
:: Check python in system-path
where python || echo. && echo Error - Missing python.exe && echo Did you install python? is it in the system-path? && pause && exit 1

:: Check setup.py exist
if not exist "setup.py" echo. && echo Error - Missing of unreachable: "%cd%\setup.py" && echo Cannot compile "%package_name%" dist && pause && exit 1

:: Update setuptools & wheel
echo Updating 'setuptools' and 'wheel'
python -m pip install --user --upgrade setuptools wheel

:: Clean before compile
if exist "dist" rmdir /q /s "dist" || rmdir /q /s "dist"
if exist "dist" echo. && echo Error - Failed to remove "%cd%\dist" dir. Should be done manually && re-run this script after dir: "%cd%\dist" is removed && pause && exit 1

:: Compile dist
echo Compiling "%package_name%" dist
python setup.py sdist bdist_wheel
if %errorlevel% neq 0 echo. && echo %compile_error_msg% && echo Check log above.. && pause && exit 1

:: Validate
if not exist "dist\*.tar.gz" echo. && echo %compile_error_msg% && echo Missing "%cd%\dist\*.tar.gz" after compilation && pause && exit 1
if not exist "dist\*.whl" echo. && echo %compile_error_msg% && echo Missing "%cd%\dist\*.whl" after compilation && pause && exit 1

:: Cleanup
echo Cleaning..
if exist "%package_name%.egg-info\*" rmdir /q /s "%package_name%.egg-info" || rmdir /q /s "%package_name%.egg-info"
if exist "%cd%\build\*" rmdir /q /s "%cd%\build" || rmdir /q /s "%cd%\build"

:: Finish
echo.
echo Finished compiling "%package_name%" to: 
echo "%cd%\dist"
ping 127.0.0.1 -n 2 > nul
echo bye..

