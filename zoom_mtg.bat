@echo off
Title Start and Kill Internet Explorer
URL="https://zoom.us/..........."
Mode con cols=75 lines=5 & color 0B
echo(
echo                     Launching Internet Explorer ...
Start "" "%ProgramFiles%\Internet Explorer\iexplore.exe" %URL%"
:: Sleep for 10 seconds, you can change the SleepTime variable
set SleepTime=10
Timeout /T %SleepTime% /NoBreak>NUL
Cls & Color 0C
echo(
echo              Please wait ...
Taskkill /IM "iexplore.exe" /F
