#!/bin/bash

# Define some handy functions for other bash scripts in this directory

xcat () {
    fasta=$1
    if [ "${fasta##*.}" == "xz" ]; then
        xzcat $fasta
    elif [ "${fasta##*.}" == "gz" ]; then
        zcat $fasta
    else
        cat $fasta
    fi
}
export -f xcat

fastaNames () {
    xcat $1 \
    | grep ^\> | sed -re 's/^>//;'
}
export -f fastaNames

fastaSeqCount () {
    xcat $1 \
    | grep ^\> | wc -l
}
export -f fastaSeqCount

cleanGenbank () {
    sed -re 's@Severe acute respiratory syndrome coronavirus 2 SARS-CoV-2/@@;' $* \
    | sed -re 's@Severe acute respiratory syndrome coronavirus 2 isolate SARS[ -]Co[Vv]-2/(human|homo ?sapiens)/@@;' \
    | sed -re 's@Mutant Severe acute respiratory syndrome coronavirus 2 clone SARS-CoV-2[_-]@@;' \
    | sed -re 's@Severe acute respiratory syndrome coronavirus 2( isolate)?( 2019_nCoV)?@@;' \
    | sed -re '/^[A-Z]+$/bx; s@[A-Za-z0-9]+ [a-z]*protein.*@@; :x;' \
    | sed -re 's@(( genomic)? RNA)?, ((nearly )?complete|partial) genome$@@;' \
    | sed -re 's@genome assembly(, complete genome)?: monopartite$@@;' \
    | sed -re 's@ (1 |nasopharyngeal )?genome assembly, chromosome: .*$@@;' \
    | sed -re 's@, complete sequence@@;' \
    | sed -re 's@humans, [A-Za-z]+,( [0-9]+ Years old)?( Adult)?/@@' \
    | sed -re 's@hCo[vV]-19/@@;' \
    | sed -re 's@SARS?-CoV-?2/([Hh]umai?ns?|[Hh]o[mw]o ?sapiens?)/@@;' \
    | sed -re 's@SARS-CoV-2/(environment|ENV)/@env/@;' \
    | sed -re 's@SARS-CoV-2/Felis catus/@cat/@;' \
    | sed -re 's@SARS-CoV-2/Panthera leo/@lion/@;' \
    | sed -re 's@SARS-CoV-2/Panthera tigris/@tiger/@;' \
    | sed -re 's@SARS-CoV-2/@@;' \
    | sed -re 's@BetaCoV/@@;' \
    | sed -re 's@Homo sapines/@@;' \
    | sed -re 's@ \| @ \|@; s@ $@@; s@  @ @;' \
    | sed -re 's@ \|@\t@;'
# Got rid of this:   s/ ([^|])/_\1/g;
}
export -f cleanGenbank

cleanCncb () {
    sed -re "s@^BetaCoV/@@;
             s@^hCoV-19/@@;
             s@^SARS-CoV-2/@@;
             s@^human/@@;
             s@ *\| *@\t@;"
}
export -f cleanCncb

