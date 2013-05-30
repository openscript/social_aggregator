@echo off

where /Q jruby

if %ERRORLEVEL% NEQ 0 (
	echo Please install jruby and add it to the system variable!
	pause
	exit
)

if %ERRORLEVEL% EQU 0 (
	echo Starting social aggregator . . .
	jruby aggregator.rb -e production
)