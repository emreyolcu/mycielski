find_refuted_ids () {
    echo -e "$1" | icadical -f -c "$2" | grep -oP 'c CUBE \K\w+(?= UNSAT.*)'
}

find_refuted_ids_parallel () {
    ncubes=$(echo "$2" | wc -l | cut -d ' ' -f1)
    size=$(echo $(echo "$ncubes/$4" | bc))
    files=()
    for i in `seq 1 $size $ncubes`; do
        begin=$i
        end=$(($i + $size))
        cnfwcubes=$(cat <(echo "$1") <(echo "$2" | awk -v b="$begin" -v e="$end" 'NR>=b&&NR<e'))
        offset=$(($i - 1))
        tmpfile=$(mktemp)
        files+=("$tmpfile")
        find_refuted_ids "$cnfwcubes" "$3" | sed "s/$/+$offset/" | bc > $tmpfile &
    done
    wait
    for f in "${files[@]}"; do
        cat $f
    done
}

select_cubes () {
    awk 'FNR==NR{a[$1]=$2FS$3; next} ($1 in a){print $0,a[$1]}' \
        <(echo "$1") \
        <(echo "$2" | nl -w1 -s' ') | cut -d ' ' -f2-
}

cubes_clauses () {
    echo "$1" | sed -e 's/a//' -e 's/ /-/' -e 's/ / -/' | sed 's/--//'
}
