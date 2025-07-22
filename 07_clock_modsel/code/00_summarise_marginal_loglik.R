# fetch marginal likelihood for each combination of trees and clocks

tree5_independent <- grep(pattern="Mean:", x=readLines("../independent/analysis/tree5/steppingstones.log"), value=TRUE)
tree5_autocorrelated <- grep(pattern="Mean:", x=readLines("../autocorrelated/analysis/tree5/steppingstones.log"), value=TRUE)

tree18_independent <- grep(pattern="Mean:", x=readLines("../independent/analysis/tree18/steppingstones.log"), value=TRUE)
tree18_autocorrelated <- grep(pattern="Mean:", x=readLines("../autocorrelated/analysis/tree18/steppingstones.log"), value=TRUE)

tree24_independent <- grep(pattern="Mean:", x=readLines("../independent/analysis/tree24/steppingstones.log"), value=TRUE)
tree24_autocorrelated <- grep(pattern="Mean:", x=readLines("../autocorrelated/analysis/tree24/steppingstones.log"), value=TRUE)

# convert them to numeric and clean up grep results

tree5_logliks <- c(tree5_independent, tree5_autocorrelated)
tree5_logliks <- as.numeric(gsub(pattern="          Mean:   ", replacement="",  x=tree5_logliks))

tree18_logliks <- c(tree18_independent, tree18_autocorrelated)
tree18_logliks <- as.numeric(gsub(pattern="          Mean:   ", replacement="",  x=tree18_logliks))

tree24_logliks <- c(tree24_independent, tree24_autocorrelated)
tree24_logliks <- as.numeric(gsub(pattern="          Mean:   ", replacement="",  x=tree24_logliks))

# calculate the model posterior probabilities

tree5_bayesfactors <- exp(tree5_logliks - max(tree5_logliks))
tree5_clock_posterior <- tree5_bayesfactors/sum(tree5_bayesfactors)

tree18_bayesfactors <- exp(tree18_logliks - max(tree18_logliks))
tree18_clock_posterior <- tree18_bayesfactors/sum(tree18_bayesfactors)

tree24_bayesfactors <- exp(tree24_logliks - max(tree24_logliks))
tree24_clock_posterior <- tree24_bayesfactors/sum(tree24_bayesfactors)

# construct a table with the results

results_tab <- data.frame(tree=c("tree 5", "tree 5", "tree 18", "tree 18", "tree 24", "tree 24"),
                          clock=c("independent", "autocorrelated", "independent", "autocorrelated", "independent", "autocorrelated"),
                          loglik=c(tree5_logliks, tree18_logliks, tree24_logliks),
                          bayes.factors=round(c(tree5_bayesfactors, tree18_bayesfactors, tree24_bayesfactors), digits=2),
                          post.prob=round(c(tree5_clock_posterior, tree18_clock_posterior, tree24_clock_posterior), digits=2))

# write table to file

write.table(x=results_tab, file="../analysis/clock_model_selection.tsv", sep="\t", row.names=FALSE, col.names=TRUE)
