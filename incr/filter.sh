#!/usr/bin/env bash

mkdir -p cubes

for i in `seq $1 $2`; do
    nvar=`head -n 1 "../partial/bp/M$i.cnf" | cut -d " " -f 3`
    julia filter.jl "sol/M$i-.sol" $nvar $3 ../partial/bp/M$i.cnf | shuf > cubes/M$i.cubes
done
