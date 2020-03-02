#!/usr/bin/env bash

for i in `seq 3 10`; do
    echo $i
    julia proof.jl $i $((i-1)) > proof/M$i.pr
    julia proof-d.jl $i $((i-1)) > proof/M$i-d.pr
done
