#!/usr/bin/bash

cd ../analysis

# fasta to nexus conversion and cleaning
for i in `ls *.aligned.fasta`; do pxs2nex -s $i -o $i.prenexus; done
for i in `ls *prenexus`; do sed 's/PROTEIN/STANDARD/g' $i > $i.nexus; rm $i; done

# concatenation and formatting of concatenated file
pxcat -s `ls *.nexus` -o concatenated.fasta -p partitions.txt
pxs2nex -s concatenated.fasta -o concatenated.prenexus; rm phyx.logfile
sed 's/PROTEIN/STANDARD/g' concatenated.prenexus > concatenated.nexus; rm concatenated.prenexus
