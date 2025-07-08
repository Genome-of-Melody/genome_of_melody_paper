#!/usr/bin/bash

for i in {5,18,24}; do
    cd ../analysis
    mkdir tree$i
    # fetch median and hpd for ages from the prior
    grep -o "age_median=[+.0-9a-z]*" ../../04_divtime/analysis/tree$i/prior/alignment_and_trees.nexus.con.tre > tree$i/prior_age_median.txt
    # clean median formatting, keep numbers only
    sed -i 's/age_median=//g' tree$i/prior_age_median.txt
    grep -o "age_95%HPD={[,+.0-9a-z]*}" ../../04_divtime/analysis/tree$i/prior/alignment_and_trees.nexus.con.tre  > tree$i/prior_age_hpd.txt
    # clean hpd formatting, keep numbers only separated by a comma
    sed -i 's/age_95%HPD={//g' tree$i/prior_age_hpd.txt
    sed -i 's/}//g' tree$i/prior_age_hpd.txt
    # fetch median and hpd for ages from the posterior
    grep -o "age_median=[+.0-9a-z]*" ../../04_divtime/analysis/tree$i/posterior/alignment_and_trees.nexus.con.tre > tree$i/posterior_age_median.txt
    # clean median formatting, keep numbers only
    sed -i 's/age_median=//g' tree$i/posterior_age_median.txt
    grep -o "age_95%HPD={[,+.0-9a-z]*}" ../../04_divtime/analysis/tree$i/posterior/alignment_and_trees.nexus.con.tre  > tree$i/posterior_age_hpd.txt
    # clean hpd formatting, keep numbers only separated by a comma
    sed -i 's/age_95%HPD={//g' tree$i/posterior_age_hpd.txt
    sed -i 's/}//g' tree$i/posterior_age_hpd.txt
done


