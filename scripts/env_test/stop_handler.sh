#!/bin/sh

pgrep gc_waf_runscrip | xargs sudo kill -9
pgrep fio.py | xargs sudo kill -9
killall python
killall nmon
killall deloldfiles.sh
