#!/usr/bin/bash

cd ../analysis

for i in {0..42}; do
    mkdir tree$i
    cd tree$i
    cp ../../code/stepping_stones.mb ./
    sed -e "s/TREEN/tree$i/g" -i stepping_stones.mb
    ln -s ../../data/alignment_and_trees.nexus alignment_and_trees.nexus
    mpirun -n 20 --oversubscribe mb stepping_stones.mb
    cd ..
done

