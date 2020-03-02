#!/usr/bin/env bash

i=$1

echo "d $i"
allsat_release cnf/M$i+.cnf | grep 'c found'
echo "bc $i"
allsat_release partial/b/M$i+.cnf | grep 'c found'
echo "pr $i"
allsat_release partial/p/M$i+.cnf | grep 'c found'
echo "bc-pr $i"
allsat_release partial/bp/M$i+.cnf | grep 'c found'
