# Mycielski
Mycielski graph formulas, PR proofs, and the code accompanying the SAT 2020 paper [*Mycielski graphs and PR proofs*](https://www.cs.cmu.edu/~eyolcu/research/mycielski-graphs-pr-proofs.pdf).

## Contents
- `cnf/` includes the formulas. `Mk.cnf` and `Mk+.cnf` encode the colorability of Mₖ with k-1 colors and k colors, respectively.
- `proof/` includes the PR proofs. `Mk.dpr` and `Mk.pr` are with and without deletion, respectively.
- `partial/` includes the formulas extended with clauses from parts of the proofs as described in the paper.
- `incr/` includes the code for the experiments described in Section 5.3 of the paper.
- `incr/icnf/` includes the MYCₖ+PR formulas with negations of the clauses in R2 included as assumptions for incremental solving.
- `icadical/` includes a modified version of CaDiCaL for incremental SAT solving. Thanks to Armin Biere for his implementation.

## Instructions
Make sure to have the following in your path.

*Requirements:* [Julia](https://julialang.org/) (v1.3), [dpr-trim](https://github.com/marijnheule/dpr-trim), [allsat](https://github.com/marijnheule/allsat), [CaDiCaL](https://github.com/arminbiere/cadical) (commit 92d7289), [YalSAT](http://fmv.jku.at/yalsat/yalsat-03v.zip), ICaDiCaL (included in this repository).

### Verifying the proofs
- **[optional]** `./proof.sh` to generate the proofs from scratch.
- `./verify.sh` to check both sets of proofs against the formulas for k from 3 to 10.

### Experiments with CDCL
- **[optional]** `./partial.sh` to generate the extended formulas from scratch.
- `./count.sh k` to count the number of satisfying assignments for formulas extended from MYCₖ.
- `./cadical.sh k t` to test CaDiCaL on these formulas with a timeout of `t` seconds.

### Experiments with cubes
- Change the directory to `incr`.
- **[optional]** `./gen_all.sh` to generate the cubes from scratch. By default this script uses 20 workers, you may change the fourth argument it passes to `generate.sh` to use a different number.
- `./run_all.sh` to perform the experiments for the configurations described in the paper.
- `./report.sh` to generate a summary of the results.
