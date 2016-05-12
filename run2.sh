#! /usr/bin/env bash

# make tss.bed file
# mysql will search ucsc genome browser
# awk to select tss based on strand
mysql --user genome --host genome-mysql.cse.ucsc.edu -N -B -D hg19 -e \
   "SELECT chrom, txStart, txEnd, X.geneSymbol, 1, strand FROM \
    knownGene as K, kgXref as X WHERE txStart != txEnd \
    AND X.kgID = K.name" \
    | awk 'BEGIN{OFS=FS="\t"} { if ($6 == "+") \
        { print $1,$2,$2+1,$4,$5,$6 } \
        else if ($6 == "-") \
        { print $1,$3-1,$3,$4,$5,$6 }}' \
    | sort -k1,1 -k2,2n \
    | uniq \
    | grep -v "_" \
     > tss.bed

# uniq will remove duplicates

# flank tss with 1000 bp
bedtools slop -b 1000 -i tss.bed -g hg19.chrom.sizes \
    > tss.plusminus.1000bp.bed

# change resolution
bedtools makewindows -b tss.plusminus.1000bp.bed -w 5 -i srcwinnum \
    | sort -k1,1 -k2,2n \
    | tr "_" "\t" > tss.plusminus.1000bp.5bp.windows.bed
















