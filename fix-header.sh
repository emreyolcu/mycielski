#!/usr/bin/env bash

cls=$(grep -v '^c\|^p cnf' "$1")
nvars=$(echo "$cls" | sed -e 's/-//g' -e 's/ 0$//g' | tr ' ' '\n' | sort -n | tail -1)
ncls=$(echo "$cls" | wc -l | awk '{print $1}')

cat <(echo "p cnf $nvars $ncls") <(echo "$cls")
