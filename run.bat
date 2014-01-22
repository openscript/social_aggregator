@echo off

where /Q ruby
set jruby=%ERRORLEVEL%

where /Q jruby
set ruby=%ERRORLEVEL%

if "%jruby%;%ruby%" EQU "1;1" (
	echo "Please install a ruby environment."
)

if %ruby% EQU 0 (
	echo Starting social aggregator . . .
	ruby aggregator.rb -e production
)

if %jruby% EQU 0 (
	echo Starting social aggregator . . .
	jruby aggregator.rb -e production
)