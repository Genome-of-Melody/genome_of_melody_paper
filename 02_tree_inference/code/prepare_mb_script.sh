#!/bin/bash

# Input file and output file paths
INPUT_FILE="../../01_alignment_concatenation/analysis/partitions.txt"
OUTPUT_FILE="02_tree_inference.mb"

# Header for the MRBayes script
cat <<EOL > $OUTPUT_FILE
begin mrbayes;
[Script documentation carried out using comments]

[log the analysis]
log start filename=concatenated.log;
[read the matrix concatenated.nexus]
execute concatenated.nexus;

[close analysis at end]
set autoclose=yes;
[This command shows the status of all the taxa, according to the documentation]
taxastat;

[definition of individual partitions per marker come from partitions.txt]
EOL

# Initialize an array to store the markers for the partition definition
declare -a markers

# Process each line from the input file to generate partition definitions
while IFS=, read -r prefix marker_range; do
  # Clean up the marker name and range (trim spaces and remove the 'AA' prefix)
  marker=$(echo $marker_range | cut -d' ' -f1 | sed 's/_src.fasta.aligned.fasta.prenexus.nexus//g')
  range=$(echo $marker_range | cut -d' ' -f3)
  
  # Output the charset definition
  echo "charset $marker = $range;" >> $OUTPUT_FILE

  # Add the marker to the partition definition list
  markers+=($marker)
done < $INPUT_FILE

# Get the number of markers (partitions)
num_partitions=${#markers[@]}

# Generate the partition definition
partition_line="partition chants=$num_partitions:$(IFS=,; echo "${markers[*]}");"
echo -e "\n[definition of the single partition]" >> $OUTPUT_FILE
echo $partition_line >> $OUTPUT_FILE

# Footer for the MRBayes script
cat <<EOL >> $OUTPUT_FILE

[specification of substitution models]
set partition=chants;
lset applyto=(all) coding=all rates=invgamma; [Mkv+I+G, nstates is automatic for the standard datatype]

[allow rate categories to vary among partitions]
prset applyto=(all) ratepr=variable;

[a diffuse compound gamma prior on branch lengths with mean tree length = 0.362]
prset brlenspr = unconstrained: gammadir(1, 2.76, 1, 1);

[Note: This hyperprior is segfaulting mrbayes: a symdirichlet hyperprior on the stationary frequencies]
[prset applyto=(all) symdirihyperpr=fixed(1.0);]

[show the model just specified for each partition]
showmodel;

[set up the MCMC, with this setting the analysis will need not less than 16 threads]
mcmcp nruns=5 ngen=5000000 nchains=10 samplefreq=2000 printfreq=2000;
[run the MCMC]
mcmc;

[summarize the posterior trees]
sumt nruns=5 relburnin=yes burninfrac=0.20;
plot;

[summarize parameter posteriors]
sump;

log stop;
end;
EOL

echo "MRBayes script has been generated and saved to $OUTPUT_FILE"
