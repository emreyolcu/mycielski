#!/usr/bin/env bash

for i in `seq 3 10`; do
    echo $i
    time dpr-trim cnf/M$i.cnf proof/M$i.pr
    time dpr-trim cnf/M$i.cnf proof/M$i-d.pr
done
