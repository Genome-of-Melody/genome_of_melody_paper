#!/usr/bin/bash

cd ../analysis

for i in `ls ../data/*.fasta`; do
    mafft --text --textmatrix ../code/00_textmatrix_complete --globalpair --maxiterate 10000 $i > `basename $i`.aligned.fasta
done

