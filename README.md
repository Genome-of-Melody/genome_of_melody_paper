# Genome of Melody: Applying bioinformatics to study the evolution of Gregorian chant

Dataset including 560 introit melodies.

In general, each sequential step in this process should be run as ordered (e.g., `000_*`, then `00_*`, then `01_*`, up to `04_*`). Each directory contains usually three subdirectories: `code`, `data`, and `analysis`. Procedures are coded in the `code` directory, using input from the `data` directory, and placing intermediate files also in `data`. The final analysis is then using elements of data as input and returning results in `analysis`. Sometimes, output elements from a given analysis are the input for a subsequent analysis, and the code uses either symbolic links or copy of files from one analysis into the other.

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

The list of sigla that are retained (because these sources contain enough
of all the Cantus IDs that we are analysing):

```
A-Gu : Ms 0807
CH-Cobodmer : C 0074
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
F-Pn : Ms Lat 00903
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
V-CVbav : Vat.lat.05319
```

### Notes on excluding certain sources

**NOTE: so far the sources have NOT been excluded from the dataset.**

From the "most complete" version of the dataset, which maximizes the total number of melodies,
we exclude some sources that do not share nearly all of the repertoire, so that the absence
of repertoire does not have an opportunity to significantly bias the resulting phylogeny.

Here we discuss which sigla were excluded and what the impact of their exclusion on the dataset is.

**PL-Wn Rps 12496 IV** Clear exclude -- only 3 Cantus IDs present.

**F-Pn : Ms Lat 00904** Only 14 out of 20 Cantus IDs present.

**V-CVbav : Archivio di San Pietro F.22** While this is an Old Roman manuscript and therefore
valuable to the dataset, it only contains 13 of the 20 Cantus IDs, and there are two other
Old Roman sources present that do not have this issue of missing repertoire.

On the other hand, we opted to retain **V-CVbav Ross.0076**, even though it only contains 16/20
introits. It does represent an interesting geographical point -- Adriatic Italy, on the way
to Dalmatia.

(We should perform an experiment where these sigla are not excluded and observe
if it influences the resulting topology in any way.)


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

Multiple sequence alignment was carried out using the notebook `00_tree_inference/code/00_alignment.ipynb`. We use the fasta-formated sequences from the previous step in order to align using `mafft` with a custom score matrix (`00_textmatrix_complete`). Some reformatting is necessary before the files can be used for Bayesian inference, and these are carried out by `phyx` also in the same Python notebook.

Tree inference is carried out by `mrbayes_volpiano` as triggered by the script `00_tree_inference/code/01_run_tree_inference.sh`, which uses the `mrbayes_volpiano` script `01_tree_inference.mb`. This step uses the concatenated alignment `00_tree_inference/data/concatenated.nexus` and returns the analysis output to `00_tree_inference/analysis`.

## Model selection on alternative rooting points

Bayesian model selection using stepping stones is carried out on the maximum clade credibility tree, which is calculated in `01_model_selection/code/00_calculate_maxcredtree.sh` using `phyx` and `treeannotator`.

Then all the possible rooting positions on the MCC tree are generated by `01_model_selection/code/01_reroot_trees.R` using the packages `ape` and `phytools` in `R`. The script `01_model_selection/code/` takes the tree file generated in this step and concatenates it to a general nexus file with both the concatenated alignment from `00_tree_inference/data` and an intermediate file with the tree block including all possible rooted trees.

The script `01_model_selection/code/03_run_stepping_stones.sh` runs the analysis on the input files in `01_model_selection/data` and the template script `01_model_selection/code/stepping_stones.mb` for each of the 25 possible trees and saves the output in a dedicated directory name with the tree ID.

Collection of marginal lnL data are done grepping the log files and keeping the tree ID directory name and the lnL value with:

```bash
grep -a "Mean: " ../analysis/*/*log
```

These values are then stored manually into the file `01_model_selection/analysis/marginal_logliks.tsv`. This is the input for the script `01_model_selection/code/04_summarise_marginal_loglik.R` which generates a barplot with the model posterior probabilities for each tree and saves it to `01_model_selection/analysis/model_posterior_probability.pdf`

**TODO: This will be a different tree for introits.**
The results suggest that the `tree7` is the best one with a model posterior probability higher than 0.7. This is the input for the subsequent analyses.

## Divergence time estimation

This analysis is carried out by `mrbayes_volpiano` using the script `02_divtime/code/00_run_mcmc_sampling.sh`, which in turn uses the concatenated alingment and trees from `01_model_selection/data/alignment_and_trees.nexus`, and then runs an analysis under the prior and under the posterior using the template script `02_divtime/code/mcmc_sampling.mb`.

The age information used as calibration densities is found in Table S1 below:

Table S1. Calibration densities (CD) used in DTE. Time scale is in both years before the present (YBP, as used by `mrbayes_volpiano`) as well as in anno Domini (AD). Single time values represent fixed values whereas intervals represent Uniform(min,max) calibration densities.

*TODO* This table must be redone from Christmas to Introits soruces.

| Node              | CD (YBP)   | CD (AD)    |
|-------------------|------------|------------|
| A VOR Cod 259 I   | 654        | 1370       |
| A Wn 1799         | 724--824   | 1200--1300 |
| CDN Hsmu M2149 L4 | 474        | 1550       |
| CH E 611          | 624--724   | 1300--1400 |
| CZ HKm II A 4     | 554        | 1470       |
| CZ PLm 504 C 004  | 408        | 1616       |
| CZ Pn XV A 10     | 624--674   | 1350--1400 |
| CZ Pu I D 20      | 624--674   | 1350--1400 |
| CZ Pu XVII E 1    | 474--524   | 1500--1550 |
| D KA Aug LX       | 624--924   | 1100--1400 |
| D KNd 1161        | 799--849   | 1175--1225 |
| F Pn lat 12044    | 874--924   | 1100--1150 |
| F Pn lat 15181    | 674--724   | 1300--1350 |
| NL Uu 406         | 624--924   | 1100--1400 |
| Root              | 1124--1324 | 700--900   |

The result for this analysis is stored in `02_divtime/analysis/tree7`.

The summarised tree file `02_divtime/analysis/tree7/posterior/alignment_and_trees.nexus.con.tre` is then read by `figtree` in order to produce the Figure 1. This is carried out incorporating an offset of -408, reversing the time axis, and then plotting the HPD interval for the node ages and colouring branches with median IgrBranch rates. The tree is then plotted in units of years before present.
