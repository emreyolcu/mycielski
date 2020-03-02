#!/usr/bin/env bash

cd partial

rm -rf b/* p/* bp/* bpr/* bprr/*
mkdir -p b p bp bpr bprr

cp ../cnf/* b
cp ../cnf/* p
cp ../cnf/* bp
cp ../cnf/* bpr
cp ../cnf/* bprr

for i in `seq 3 10`; do
    echo $i
    nc=$((i - 1))
    julia ../clauses.jl $i $nc bc >> b/M$i.cnf
    julia ../clauses.jl $i $i  bc >> b/M$i+.cnf

    julia ../clauses.jl $i $nc pr >> p/M$i.cnf
    julia ../clauses.jl $i $i  pr >> p/M$i+.cnf

    julia ../clauses.jl $i $nc bc,pr >> bp/M$i.cnf
    julia ../clauses.jl $i $i  bc,pr >> bp/M$i+.cnf

    julia ../clauses.jl $i $nc bc,pr,rup1 >> bpr/M$i.cnf
    julia ../clauses.jl $i $i  bc,pr,rup1 >> bpr/M$i+.cnf

    julia ../clauses.jl $i $nc bc,pr,rup1,rup2 >> bprr/M$i.cnf
    julia ../clauses.jl $i $i  bc,pr,rup1,rup2 >> bprr/M$i+.cnf
done

echo "Fixing headers"
for f in {b,p,bp,bpr,bprr}/*; do
    tmpfile=$(mktemp)
    ../fix-header.sh $f > $tmpfile
    cat $tmpfile > $f
done
