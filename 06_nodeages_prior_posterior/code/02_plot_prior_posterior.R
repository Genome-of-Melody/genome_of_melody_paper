library(tbea)

#to do: prepare better figure labels and main text

#trees 5, 18, and 24

# tree 5
# prior
tree5_prior_median <- read.csv("../analysis/tree5/prior_age_median.txt", header=FALSE)
tree5_prior_hpd <- read.csv("../analysis/tree5/prior_age_hpd.txt", header=FALSE)

# posterior
tree5_posterior_median <- read.csv("../analysis/tree5/posterior_age_median.txt", header=FALSE)
tree5_posterior_hpd <- read.csv("../analysis/tree5/posterior_age_hpd.txt", header=FALSE)

# plot
extra.space <-10
bar.lty <- 1
bar.lwd <- 1
identity.lwd <- 1
identity.lty <- 1

pdf("../analysis/tree5_prior_posterior.pdf")
plot(x=tree5_prior_median$V1,
     y=tree5_posterior_median$V1,
     xlim = c((min(tree5_prior_hpd[,1]) - extra.space),
     (max(tree5_prior_hpd[,2]) + extra.space)),
     ylim = c((min(tree5_posterior_hpd[,1]) - extra.space),
     (max(tree5_posterior_hpd[,2]) + extra.space)),
     main="Prior-posterior comparison\nTree 5",
     xlab="Prior age",
     ylab="Posterior age")

for (j in 1:nrow(tree5_prior_median)) {
    segments(x0 = tree5_prior_median$V1[j],
             x1 = tree5_prior_median$V1[j],
             y0 = tree5_prior_hpd[j, 1],
             y1 = tree5_prior_hpd[j, 2],
             lty=bar.lty,
             lwd=bar.lwd)
}

for (j in 1:nrow(tree5_posterior_median)) {
    segments(y0 = tree5_posterior_median$V1[j],
             y1 = tree5_posterior_median$V1[j],
             x0 = tree5_posterior_hpd[j, 1],
             x1 = tree5_posterior_hpd[j, 2],
             lty=bar.lty,
             lwd=bar.lwd)
}

# Add the y = x line
abline(a = 0, b = 1, lwd=identity.lwd, lty=identity.lty)
# overlay the points to the lines in the plot
points(tree5_posterior_median$V1 ~ tree5_prior_median$V1, pch=21, bg="red")
dev.off()

# tree 18
# prior
tree18_prior_median <- read.csv("../analysis/tree18/prior_age_median.txt", header=FALSE)
tree18_prior_hpd <- read.csv("../analysis/tree18/prior_age_hpd.txt", header=FALSE)

# posterior
tree18_posterior_median <- read.csv("../analysis/tree18/posterior_age_median.txt", header=FALSE)
tree18_posterior_hpd <- read.csv("../analysis/tree18/posterior_age_hpd.txt", header=FALSE)

# plot
extra.space <-10
bar.lty <- 1
bar.lwd <- 1
identity.lwd <- 1
identity.lty <- 1

pdf("../analysis/tree18_prior_posterior.pdf")
plot(x=tree18_prior_median$V1,
     y=tree18_posterior_median$V1,
     xlim = c((min(tree18_prior_hpd[,1]) - extra.space),
     (max(tree18_prior_hpd[,2]) + extra.space)),
     ylim = c((min(tree18_posterior_hpd[,1]) - extra.space),
     (max(tree18_posterior_hpd[,2]) + extra.space)),
     main="Prior-posterior comparison\nTree 18",
     xlab="Prior age",
     ylab="Posterior age")

for (j in 1:nrow(tree18_prior_median)) {
    segments(x0 = tree18_prior_median$V1[j],
             x1 = tree18_prior_median$V1[j],
             y0 = tree18_prior_hpd[j, 1],
             y1 = tree18_prior_hpd[j, 2],
             lty=bar.lty,
             lwd=bar.lwd)
}

for (j in 1:nrow(tree18_posterior_median)) {
    segments(y0 = tree18_posterior_median$V1[j],
             y1 = tree18_posterior_median$V1[j],
             x0 = tree18_posterior_hpd[j, 1],
             x1 = tree18_posterior_hpd[j, 2],
             lty=bar.lty,
             lwd=bar.lwd)
}

# Add the y = x line
abline(a = 0, b = 1, lwd=identity.lwd, lty=identity.lty)
# overlay the points to the lines in the plot
points(tree18_posterior_median$V1 ~ tree18_prior_median$V1, pch=21, bg="red")
dev.off()

# tree 24
# prior
tree24_prior_median <- read.csv("../analysis/tree24/prior_age_median.txt", header=FALSE)
tree24_prior_hpd <- read.csv("../analysis/tree24/prior_age_hpd.txt", header=FALSE)

# posterior
tree24_posterior_median <- read.csv("../analysis/tree24/posterior_age_median.txt", header=FALSE)
tree24_posterior_hpd <- read.csv("../analysis/tree24/posterior_age_hpd.txt", header=FALSE)

# plot
extra.space <-10
bar.lty <- 1
bar.lwd <- 1
identity.lwd <- 1
identity.lty <- 1

pdf("../analysis/tree24_prior_posterior.pdf")
plot(x=tree24_prior_median$V1,
     y=tree24_posterior_median$V1,
     xlim = c((min(tree24_prior_hpd[,1]) - extra.space),
     (max(tree24_prior_hpd[,2]) + extra.space)),
     ylim = c((min(tree24_posterior_hpd[,1]) - extra.space),
     (max(tree24_posterior_hpd[,2]) + extra.space)),
     main="Prior-posterior comparison\nTree 24",
     xlab="Prior age",
     ylab="Posterior age")

for (j in 1:nrow(tree24_prior_median)) {
    segments(x0 = tree24_prior_median$V1[j],
             x1 = tree24_prior_median$V1[j],
             y0 = tree24_prior_hpd[j, 1],
             y1 = tree24_prior_hpd[j, 2],
             lty=bar.lty,
             lwd=bar.lwd)
}

for (j in 1:nrow(tree24_posterior_median)) {
    segments(y0 = tree24_posterior_median$V1[j],
             y1 = tree24_posterior_median$V1[j],
             x0 = tree24_posterior_hpd[j, 1],
             x1 = tree24_posterior_hpd[j, 2],
             lty=bar.lty,
             lwd=bar.lwd)
}

# Add the y = x line
abline(a = 0, b = 1, lwd=identity.lwd, lty=identity.lty)
# overlay the points to the lines in the plot
points(tree24_posterior_median$V1 ~ tree24_prior_median$V1, pch=21, bg="red")

dev.off()
