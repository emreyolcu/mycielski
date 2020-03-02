#!/usr/bin/env bash

cd logs

lims=(100)
ps=(1 12 25 50)

for i in `seq 7 10`; do
    echo -e "$i\n"
    echo -e "Samples\n"
    grep sol gen-$i.log
    grep real gen-$i.log
    echo -e "\nRuns\n"
    for p in ${ps[@]}; do
        for lim in ${lims[@]}; do
            echo "-- lim: $lim, p: $p"
            f="run-$i-$lim-$p.log"
            iter=$(grep '^iteration' $f | tail -n 1 | cut -d ' ' -f2)
            iter=$((iter+1))
            cdclsec=$(grep '^c total real time' $f | cut -d ':' -f2 | tr -s ' ' | cut -d ' ' -f2)
            totaltime=$(grep '^real' $f | cut -d$'\t' -f2)
            min=$(echo $totaltime | cut -d 'm' -f1)
            sec=$(echo $totaltime | cut -d 'm' -f2 | sed 's/.$//')
            totalsec=$(echo "$min*60 + $sec" | bc)
            cdclperc=$(echo "scale=3; 100*$cdclsec/$totalsec" | bc)
            phr=$(echo "$min/60" | bc)
            pmin=$(echo "$min%60" | bc)
            echo "time: ${phr}h ${pmin}m ${sec}s"
            echo "cdcl: $cdclperc"
            echo "iter: $iter"
        done
    done
    echo "------------------------------------"
done
