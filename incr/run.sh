#!/usr/bin/env bash

source util.sh

echo "args: $@"

cnf=$(cat "$1")
remaining_cubes=$(cat "$2")

i=0
total=$(echo "$remaining_cubes" | wc -l)
refuted=0
r_prev=1
lim=$3
workers=$5
while [ $i -lt $4 ]; do
    echo "iteration: $i"
    echo "running icadical"
    echo "lim: $lim"
    refuted_ids=$(find_refuted_ids_parallel "$cnf" "$remaining_cubes" "$lim" "$workers")
    r=$(echo "$refuted_ids" | wc -l)
    [ $r -eq 1 ] && r=0
    ((refuted+=r))
    printf "refuted: %d, progress: %d/%d\n\n" "$r" "$refuted" "$total"
    if [ ! -z "$refuted_ids" ]; then
        refuted_cubes=$(select_cubes "$refuted_ids" "$remaining_cubes")
        learned_clauses=$(cubes_clauses "$refuted_cubes")
        cnf="$cnf\n$learned_clauses"
    fi
    if [ $(echo "$r/$r_prev < 0.5" | bc -l) -eq 1 ]; then
        break;
    fi
    r_prev=$r
    remaining_ids=$(diff <(seq 1 $(echo "$remaining_cubes" | wc -l | cut -d ' ' -f1)) <(echo "$refuted_ids") | grep '^<' | cut -d ' ' -f2)
    remaining_cubes=$(select_cubes "$remaining_ids" "$remaining_cubes")
    if [ -z "$remaining_cubes" ]; then
        break;
    fi
    ((i++))
done

echo -e "$cnf" | cadical - -f --report=false
