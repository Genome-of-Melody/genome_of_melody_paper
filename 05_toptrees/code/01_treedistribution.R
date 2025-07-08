library(tbea)
library(ape)

tsample1 <- read.nexus("../data/concatenated.nexus.run1.t")
tsample2 <- read.nexus("../data/concatenated.nexus.run2.t")
tsample3 <- read.nexus("../data/concatenated.nexus.run3.t")
tsample4 <- read.nexus("../data/concatenated.nexus.run4.t")
tsample5 <- read.nexus("../data/concatenated.nexus.run5.t")

# combine independent runs after removing 500 trees as burn-in
tsample = c(tsample1[502:2501],
            tsample2[502:2501],
            tsample3[502:2501],
            tsample4[502:2501],
            tsample5[502:2501])

rm(tsample1, tsample2, tsample3, tsample4, tsample5)

class(tsample) <- "multiPhylo"

# calculate topological frequencies
tpf <- topoFreq(tsample, output="trees")

# summarize median branch length
sumtrees <- summaryBrlen(tpf$trees, method="median")

# sort the frequencies in decreasing order
decreasingIdx <- order(tpf$fabs, decreasing=TRUE)

# relfreqs for the top 10 trees
tpf$frel[decreasingIdx[1:10]]

# how much of the trees is accounted for by these 10 trees?
# more than half
sum(tpf$frel[decreasingIdx[1:10]])

# save to pdf the top 10 trees
pdf("../analysis/toptrees.pdf", width=10, height=10)
for (i in 1:10) {
    plot(sumtrees[[decreasingIdx[i]]],
         type="unrooted",
         lab4ut="axial",
         cex=0.6,
         no.margin=FALSE,
         main=paste("Tree ",
                    i,
                    "\nRelative frequency = ",
                    tpf$frel[decreasingIdx[i]], sep=""))
}
dev.off()
