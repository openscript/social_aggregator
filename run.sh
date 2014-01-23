#!/bin/sh

if which ruby >/dev/null; then
    ruby Aggregator.rb -e production
else
    echo Please install ruby.
fi