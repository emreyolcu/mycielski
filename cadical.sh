#!/usr/bin/env bash

i=$1
tout=$2

if [[ "Darwin" == `uname` ]]; then
    prog="gtimeout"
else
    prog="timeout"
fi

echo "d $i"
$prog $tout cadical cnf/M$i.cnf | grep 'c total real time\|c UNKNOWN'
echo "bc $i"
$prog $tout cadical partial/b/M$i.cnf | grep 'c total real time\|c UNKNOWN'
echo "bc-pr $i"
$prog $tout cadical partial/bp/M$i.cnf | grep 'c total real time\|c UNKNOWN'
echo "bc-pr-rup1 $i"
$prog $tout cadical partial/bpr/M$i.cnf | grep 'c total real time\|c UNKNOWN'
echo "bc-pr-rup1-rup2 $i"
$prog $tout cadical partial/bprr/M$i.cnf | grep 'c total real time\|c UNKNOWN'
