#!/usr/bin/bash
mkdir ../analysis

cd ../analysis
#ln -s ../../02_tree_inference/data/concatenated.nexus ../data/concatenated.nexus

# uncomment if divtime should be estimated on more than one tree
#for i in {tree,numbers,separated,by,commas}; do
#for i in '5'; do 4-10, 19-20, 29-30, 32-42
for i in {29..31}; do
    if [[ $i -eq 5 || $i -eq 18 || $i -eq 24 ]]; then
        continue
    fi
    mkdir tree$i
    cd tree$i
    # sample from prior
    mkdir prior
    cd prior
    cp ../../../code/mcmc_sampling.mb ./
    sed -e "s/TREEN/tree$i/g" -i mcmc_sampling.mb
    sed -e "s/TOGGLEDATA/no/g" -i mcmc_sampling.mb
    ln -s ../../../../03_model_selection/data/alignment_and_trees.nexus alignment_and_trees.nexus
    mpirun -n 8 --oversubscribe mb mcmc_sampling.mb
    cd ..
    # sample from posterior
    mkdir posterior
    cd posterior
    cp ../../../code/mcmc_sampling.mb ./
    sed -e "s/TREEN/tree$i/g" -i mcmc_sampling.mb
    sed -e "s/TOGGLEDATA/yes/g" -i mcmc_sampling.mb
    ln -s ../../../../03_model_selection/data/alignment_and_trees.nexus alignment_and_trees.nexus
    mpirun -n 8 --oversubscribe mb mcmc_sampling.mb
    cd ../..
done

