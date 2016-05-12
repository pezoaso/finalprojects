#! /usr/bin/env bash

data='/users/sofiapezoa/desktop/molb7621_finalproj/new'
hescbam=$data/wgEncodeBroadHistoneH1hescH3k9acStdAlnRep1.bam
chromsizes='/users/sofiapezoa/desktop/molb7621_finalproj/hg19.chrom.sizes'
tss=$data/tss.plusminus.1000bp.5bp.windows.bed
nhabam=$data/wgEncodeBroadHistoneNhaH3K09acAlnRep1.bam


# peak calling for H3k9ac chipseq with hesc and nha cells
# first the HESC
macs2 callpeak -t $hescbam

bedtools genomecov -i NA_summits.bed -g $chromsizes -bg > hESCh3k9.bg
bedGraphtoBigWig hESCh3k9.bg $chromsizes hESCh3k9.bw
# dont beed bw

#map to tss
bedtools map -a $tss -b hESCh3k9.bg \
    -c 4 -o mean -null 0 > hESCh3k9.tss.coverage.bedg

sort -t$'\t' -k5,5n hESCh3k9.tss.coverage.bedg \
    | bedtools groupby -i - -g 5 -c 6 -o sum > hESCh3k9.counts.txt

# now the nha cells
macs2 callpeak -t $nhabam

bedtools genomecov -i NA_summits.bed -g $chromsizes -bg > nhah3k9.bg
bedtools map -a $tss -b nhah3k9.bg \
    -c 4 -o mean -null 0 > nhah3k9.tss.coverage.bedg

sort -t$'\t' -k5,5n nhah3k9.tss.coverage.bedg \
    | bedtools groupby -i - -g 5 -c 6 -o sum > nhah3k9.counts.txt



