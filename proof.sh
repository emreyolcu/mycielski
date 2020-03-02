#!/usr/bin/env bash

for i in `seq 3 10`; do
    echo $i
    julia dproof.jl $i $((i-1)) > proof/M$i.dpr
    julia proof.jl $i $((i-1)) > proof/M$i.pr
done
