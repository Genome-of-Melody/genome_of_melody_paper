# Genome of Melody: Applying bioinformatics to study the evolution of Gregorian chant

Dataset including 560 introit melodies.

In general, each sequential step in this process should be run as ordered (e.g., `000_*`, then `01_*`, then `02_*`, up to `04_*`). Each directory contains usually three subdirectories: `code`, `data`, and `analysis`. Procedures are coded in the `code` directory, using input from the `data` directory, and placing intermediate files also in `data`. The final analysis is then using elements of data as input and returning results in `analysis`. Sometimes, output elements from a given analysis are the input for a subsequent analysis, and the code uses either symbolic links or copy of files from one analysis into the other.

## Datasets

The `000_dataset_cleaning/source_data` folder contains the source Introits dataset used in experiments.
They are present as CantusCorpus-style CSV files.

So far, no additional cleaning has been performed.


## Preprocessing

In order to obtain inputs for the bioinformatics pipeline, we need to further preprocess
the melodies. For phylogeny buidling, melodies should contain only notes and neume/syllable/word
separators using the standard volpiano dashes. All barlines and other non-note characters
should be removed. (The preprocessing steps in phylogeny building then takes care of the separators:
in some settings we might prefer to retain them.) This is done by the `000_dataset_cleaning/code/clean_christmas.py` script
(use flags `-cbnder` for the full cleaning).

In order to get valid inputs for alignment, we then must create FASTA files 
(with sigla as sequence names) individually for all
the chants. This step is implemented by the `000_dataset_cleaning/code/build_src_fasta.py` script.
It then should be run with the CSV input file `000_dataset_cleaning/source_data/2024-05-27_annotated-melodies_COMPLETED-2024-12-05_autocleaned_transposed_longest-retained_small-filtered.csv`.
Then, the names of all sigla must be normalized for analysis via the `000_dataset_cleaning/01_rename_sources.sh` script to avoid issues with analytical tools.


The list of sigla that are retained (because these sources contain enough
of all the Cantus IDs that we are analysing):

```
A-Gu : Ms 0807
CH-ROM : Ms. liturg. FiD 5
D-B : Ms mus 40078
D-HEu : Cod. Sal. X,007
D-KNd : Ms 1001b
D-LEu : Ms Thomas 391
F-CA : Ms 0061 (62)
F-G : Ms 0084 (Ms. 395 Rés.)
F-NS : Ms 0004
F-Pa : Ms 0197
F-Pn : Ms Lat 00833
F-Pn : Ms Lat 17307
F-Pn : NAL 01235
F-Pn : NAL 01414
F-PR : Ms 0012
F-SEm : Ms 018
I-BGc : MA 150 (Psi III.8)
I-BGc : MA 239 (Gamma III.18)
NL-Uu : Hs. 0415
PL-Wn rps 12722 V
PL-WRu I F 414
PL-WRu I F 416
V-CVbav : Ross.0076
```

### Notes on excluding certain sources

From the "most complete" version of the dataset, which maximizes the total number of melodies,
we exclude some sources that do not share nearly all of the repertoire, so that the absence
of repertoire does not have an opportunity to significantly bias the resulting phylogeny.

Here we discuss which sigla were excluded and what the impact of their exclusion on the dataset is.

**PL-Wn Rps 12496 IV** Clear exclude -- only 3 Cantus IDs present.

**F-Pn : Ms Lat 00904** Only 14 out of 20 Cantus IDs present.

Because of the unclear evolutionary relationship of this tradition to Gregorian chant, we excluded these Old Roman sources from experiments: **CH-Cobodmer C 0074**, **V-CVbav Archivio di San Pietro F.22**, and **V-CVbav Vat.lat.05319**. 

**F-Pn : Ms Lat 00903** The entire source is very early, with 5-line Aquitanian staff notation that predates the Guidonian standard (one of the attempts to notate exact pitch that was not as successful as the Guidonian 4-line staff), which makes it an outlier by nearly 100 years. Due to the way ages of tips may interact with the root selection and DTE steps of the pipeline, we decided to exclude this source from experiments; this does not discard much useful information in terms of the research questions, since we already have two French Benedictine sources in the dataset.

On the other hand, we opted to retain **V-CVbav Ross.0076**, even though it only contains 16/20
introits. It does represent an interesting geographical point -- Adriatic Italy, on the way
to Dalmatia.



### Transposition

Some melodies were recorded in some manuscripts in versions transposed by a fifth up or down, compared
to the majority of other sources. This is a known phenomenon from chant history that stems from the effort
to avoid flats in written form of chant. Since this is only a writing convention, not a sung one,
we transpose these melodies to be directly comparable to the majority position on the gamut, so as not
to introduce spurious written differences between melodies that would not be reflected in sung practice.

The list of transposed chants is documented in `000_dataset_cleaning/source_data/manual/transpositions_needed.txt`.

**Curious cases:**

Exaudi Domine (g00785) from V-CVbav : Vat.lat.05319 ends with a semitone `c-b`, which when transposed
a fifth to the gamut position of the rest of the Exaudi melodies translates to a unique `f-e` rather
than `g-f`. Other "Old Roman" sources also have `g-f`. However, this is not a transcription error;
the red staffline is clearly marked F in the manuscript, and the proto-diastematic notation clearly
uses four ptiches below the staff, in the preceding melisma `cedcdcb` as well. We thus retain this oddity.

Tibi dixit (g00733) from the same source has the same phenomenon, again very clearly a `b` is used
at the end and in the preceding melismas. If there is an implied flat, it is really only that -- implied.
(Because of the lack of clarity on flats, we set the substitution cost between 'i' and 'j' in the MSA
to 0 anyway.) Implied flats happen in Old Roman chant. But, here the issue is gnarlier. If we transpose
up a fifth and add a flat to the ending, we get two quite direct tritones in a melisma around the middle:
`...cdfd-E-dc-Bb-d-E-fededc...`. If we do not flatten this B, we get tritones between the B natural and
the fs, but the descending tritone becomes much less jarring. In the end, because we purposefully do not
consider flats in the alignment substitution model, we transpose the melody as if the flats were added
(so the written B becomes an F), and rely on the fact that the mdoel will treat the consequent tritones
`b-a-g-f` in the same way as if the Bs were flat. (This makes no sense for V-CVbav Vat.lat.05319, because
that would imply also all the Es in the melody would be flattened, but it does make the flat choice in
the transposed melody less consequential for the alignment.) The alternative is to treat the Fs as F sharp.
This is the literal transposition of this melody, and frankly most satisfying artistically. Again, F sharps
would be treated the same as F in the alignment (precisely because of such uncertainties). What this case shows
is that the choice of position on the gamut in 05319 is certainly not arbitrary. In any case, this is
an interesting melody for the examination of modality in Old Roman sources.


### Retaining longest versions.

Some sources have multiple versions of the same melody transcribed. While it would be a fascinating experiment
to look at the measure of variability in just one place at one time, for the purposes of phylogeny building,
we always retain the longest transcription (as some of these may be just partial records of the melody).

This affects the following introits and sources:

- `g00331` -- CH-ROM : Ms. liturg. FiD 5, D-KNd : Ms 1001b, F-Pa : Ms 0197, F-Pn : Ms Lat 00833, F-Pn : Ms Lat 17307,
              F-Pn : NAL 01414, I-BGc : MA 239 (Gamma III.18), PL-WRu I F 416, F-Pn : Ms Lat 00904
- `g00648` -- F-Pn : Ms Lat 00833
- `g00742` -- I-BGc : MA 239 (Gamma III.18)
- `g00785` -- CH-ROM : Ms. liturg. FiD 5, F-Pn : NAL 01414
- `g00789` -- F-Pn : Ms Lat 00833
- `g01178` -- D-KNd : Ms 1001b, F-Pa : Ms 0197, F-Pn : Ms Lat 00833, F-Pn : Ms Lat 00904, F-SEm : Ms 018 



## Running the phylogeny/DTE/ASR pipeline

### Bayesian tree inference

Multiple sequence alignment was carried out using the code in the folders `01_alignment_concatenation/code` and `02_tree_inference/code`. We use the fasta-formated sequences from the previous step in order to align using `mafft` with a custom score matrix (`00_textmatrix_complete`) which is done by script `01_alignment_concatenation/code/00_alignment.sh` and `01_alignment_concatenation/code/01_concatenation.sh`. Some reformatting is necessary before the files can be used for Bayesian inference, and these are carried out by `phyx` also in the same Python notebook.

Tree inference is carried out by `mrbayes_volpiano` as triggered by the script `02_tree_inference/code/02_run_tree_inference.sh`, which uses the `mrbayes_volpiano` script `01_tree_inference.mb`. This step uses the concatenated alignment `00_tree_inference/data/concatenated.nexus` and returns the analysis output to `02_tree_inference/analysis`.

## Model selection on alternative rooting points

Bayesian model selection using stepping stones is carried out on the maximum clade credibility tree, which is calculated in `03_model_selection/code/00_calculate_maxcredtree.sh` using `phyx` and `treeannotator`.

Then all the possible rooting positions on the MCC tree are generated by `03_model_selection/code/01_reroot_trees.R` using the packages `ape` and `phytools` in `R`. The script `03_model_selection/code/` takes the tree file generated in this step and concatenates it to a general nexus file with both the concatenated alignment from `02_tree_inference/data` and an intermediate file with the tree block including all possible rooted trees.

The script `03_model_selection/code/03_run_stepping_stones.sh` runs the analysis on the input files in `03_model_selection/data` and the template script `03_model_selection/code/stepping_stones.mb` for each of the 25 possible trees and saves the output in a dedicated directory name with the tree ID.

Collection of marginal lnL data are done grepping the log files and keeping the tree ID directory name and the lnL value with:

```bash
grep -a "Mean: " ../analysis/*/*log
```

These values are then stored manually into the file `03_model_selection/analysis/marginal_logliks.tsv`. This is the input for the script `03_model_selection/code/04_summarise_marginal_loglik.R` which generates a barplot with the model posterior probabilities for each tree and saves it to `03_model_selection/analysis/model_posterior_probability.pdf`

The results suggest that the `tree18` is the best one with a model posterior probability higher than 0.5. This is the input for the subsequent analyses.

## Divergence time estimation

This analysis is carried out by `mrbayes_volpiano` using the script `04_divtime/code/00_run_mcmc_sampling.sh`, which in turn uses the concatenated alingment and trees from `03_model_selection/data/alignment_and_trees.nexus`, and then runs an analysis under the prior and under the posterior using the template script `04_divtime/code/mcmc_sampling.mb`.

The age information used as calibration densities is found in Table S1 below:

Table S1. Calibration densities (CD) used in DTE. Time scale is in both years before the present (YBP, as used by `mrbayes_volpiano`) as well as in anno Domini (AD). Single time values represent fixed values whereas intervals represent Uniform(min,max) calibration densities.


| Node                         | CD (YBP)   | CD (AD)    |
|------------------------------|------------|------------|
| A-Gu : Ms 0807               | 1100--1199 |  825--924  |
|CH-ROM : Ms. liturg. FiD 5    | 1200--1299 |  725--824  |
|D-B : Ms mus 40078            | 1100--1199 |  825--924  |
|D-HEu : Cod. Sal. X,007       | 1200--1299 |  725--824  |
|D-KNd : Ms 1001b              | 1299       |  725       |
|D-LEu : Ms Thomas 391         | 1200--1299 |  725--824  |
|F-CA : Ms 0061 (62)           | 1133--1166 |  858--891  |
|F-G : Ms 0084 (Ms. 395 Rés.)  | 1100--1199 |  825--924  |
|F-NS : Ms 0004                | 1100--1199 |  825--924  |
|F-Pa : Ms 0197                | 1270--1297 |  727--754  |
|F-Pn : Ms Lat 00833           | 1175--1200 |  824--849  |
|F-Pn : Ms Lat 17307           | 1100--1199 |  825--924  |
|F-Pn : NAL 01235              | 1100--1199 |  825--924  |
|F-Pn : NAL 01414              | 1100--1199 |  825--924  |
|F-PR : Ms 0012                | 1200--1299 |  725--824  |
|F-SEm : Ms 018                | 1200--1299 |  725--824  |
|I-BGc : MA 150 (Psi III.8)    | 1100--1199 |  825--924  |
|I-BGc : MA 239 (Gamma III.18) | 1091--1100 |  924--933  |
|NL-Uu : Hs. 0415              | 1400--1499 |  525--624  |
|PL-Wn rps 12722 V             | 1300--1399 |  625--724  |
|PL-WRu I F 414                | 1200--1299 |  725--824  |
|PL-WRu I F 416                | 1300--1399 |  625--724  |
|V-CVbav : Ross.0076           | 1200--1299 |  725--824  |
| Root                         | 1124--1324 | 700--900   |

The result for this analysis is stored in `04_divtime/analysis/tree18` (we evaluated this analysis for each tree from the previous step, see `04_divtime/analysis/tree*`).

The summarised tree file `04_divtime/analysis/tree18/posterior/alignment_and_trees.nexus.con.tre` is then read by `figtree` in order to produce the Figure 1. This is carried out incorporating an offset of -408, reversing the time axis, and then plotting the HPD interval for the node ages and colouring branches with median IgrBranch rates. The tree is then plotted in units of years before present.
