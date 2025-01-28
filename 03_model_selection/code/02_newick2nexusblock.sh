#!/usr/bin/bash

# use phyx to convert from multiline newick to a nexus file, and the remove the first line
# so that the content of the output can be then concatenated to the data nexus file
pxt2nex -t ../data/rooted_trees.tre | tail -n +2 > ../data/treesblock.nexus; rm phyx.logfile

ln -s ../../02_tree_inference/analysis/concatenated.nexus ../data/concatenated.nexus

cat ../data/concatenated.nexus > ../data/alignment_and_trees.nexus
cat ../data/treesblock.nexus >> ../data/alignment_and_trees.nexus
