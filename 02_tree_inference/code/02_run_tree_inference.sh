#!/usr/bin/bash
./prepare_mb_script.sh

cd ../analysis

ln -s ../code/02_tree_inference.mb 02_tree_inference.mb
ln -s ../../01_alignment_concatenation/analysis/concatenated.nexus concatenated.nexus

mpirun -n 50 --oversubscribe mb 02_tree_inference.mb
