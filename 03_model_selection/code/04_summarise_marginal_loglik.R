# the file marginal_logliks is prepared manually by grepping the output of stepping stones and the using emacs for text manipulation
logliks <- read.delim("../analysis/marginal_logliks.tsv", header=TRUE)

bayes_factors <- exp(logliks$loglik - max(logliks$loglik))
model_posterior <- bayes_factors/sum(bayes_factors)

df <- data.frame(logliks, bayes_factors, model_posterior)

df_sorted <- df[order(-df$model_posterior), ]

write.table(df_sorted, "../analysis/model_posterior_probabilities.tsv", sep="\t", row.names=FALSE)

pdf("../analysis/model_posterior_probability.pdf", width=35, height=10)
barplot(height=df_sorted$model_posterior, names.arg=df_sorted$model, ylab="Model posterior probability")
dev.off()
