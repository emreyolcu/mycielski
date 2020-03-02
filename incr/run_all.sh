#!/usr/bin/env bash

mkdir -p logs/

lims=(100)
ps=(1 12 25 50)

for i in `seq 7 10`; do
    echo "Running M$i"
    for lim in ${lims[@]}; do
        for p in ${ps[@]}; do
            echo "lim: $lim, p: $p"
            (time ./run.sh ../partial/bp/M$i.cnf cubes/M$i.cubes $lim 50 $p 2>&1 | tee logs/run-$i-$lim-$p.log) 2>> logs/run-$i-$lim-$p.log
        done
    done
    echo "Done with M$i"
done
