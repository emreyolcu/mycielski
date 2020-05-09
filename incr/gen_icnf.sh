#!/usr/bin/env bash

mkdir -p icnf/

for i in `seq 7 10`; do
    f=icnf/M${i}r2.icnf
    echo "p inccnf" > $f
    tail -n +2 ../partial/bp/M$i.cnf >> $f
    julia ../clauses.jl $i $((i - 1)) rup2 | tr -d '-' | sed 's/^/a /' >> $f
done
