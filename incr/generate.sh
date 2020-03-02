#!/usr/bin/env bash

mkdir -p sol
mkdir -p cubes

function yalsat_gen {
    > $3
    for i in `seq 1 $2`; do
        out=`yalsat $1 $RANDOM`
        if grep -q 's SATISFIABLE' <<< "$out"; then
            sol=`echo "$out" | grep '^v' | tr -d '\nv' | sed 's/^ //'`
            echo $sol >> $3
        fi
    done
}

function filter {
    nvar=`head -n 1 "../partial/bp/M$1.cnf" | cut -d " " -f 3`
    julia filter.jl "sol/M$1-.sol" $nvar $2 ../partial/bp/M$1.cnf | shuf > cubes/M$1.cubes
}

function gen_batch {
    f="M$1-"
    fs=sol/"$f".sol
    for j in `seq 1 $3`; do
        yalsat_gen cnf/"$f".cnf "$2" "$fs.$j" &
    done
    wait
    for j in `seq 1 $3`; do
        cat "$fs.$j" >> "$fs"
        rm "$fs.$j"
    done
    filter $1 $(wc -l "$fs" | cut -d " " -f1)
}

echo "args: $@"
for i in `seq $1 $2`; do
    echo "M$i-"
    > sol/"M$i-".sol
    k=0
    r_prev=0
    filt=0
    while [ $k -lt $5 ]; do
        echo "iteration: $k"
        gen_batch $i $3 $4
        r=$(wc -l cubes/M$i.cubes | cut -d " " -f 1)
        filt=$(($r_prev - $r))
        echo "prev remaining: $r_prev"
        echo "filtered: $filt"
        echo "remaining: $r"
        echo ""
        if [ $k -gt 0 ] && [ $(echo "$filt/$r_prev < 0.01" | bc -l) -eq 1 ]; then
            break;
        fi
        r_prev=$r
        ((k++))
    done
    wc -l sol/"M$i-".sol
done
