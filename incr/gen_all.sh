#!/usr/bin/env bash

mkdir -p logs/

for i in `seq 7 10`; do
    echo "Generating solutions for M$i"
    (time ./generate.sh $i $i 50 20 50 2>&1 | tee logs/gen-$i.log) 2>> logs/gen-$i.log
done
