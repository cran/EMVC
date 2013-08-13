\name{EMVC}
\alias{EMVC}
\title{Entropy Minimization over Variable Clusters (EMVC) algorithm}
\description{
Implementation of the EMVC algorithm. Takes an n-by-p data matrix and a c-by-p binary annotation matrix and generates an optimized, i.e., 
filtered, version of the annotation matrix by minimizing the entropy between each variable group 
and the categorical random variable representing membership of each
variable in clusters output by either k-means clustering or horizontal cuts of a dendrogram generated via
agglomerative hierarchical clustering with correlation distance. Annotations are never added during optimization, just removed. 
}
\usage{
    EMVC(data, annotations, bootstrap.iter=20, k.range=NA, clust.method="kmeans", 
        kmeans.nstart=1, kmeans.iter.max=10, hclust.method="average", 
        hclust.cor.method="spearman")
}
\arguments{
\item{data}{Input data matrix, observations-by-variables. Must be specified. Cannot contain missing values.}
\item{annotations}{Binary annotation matrix, variable groups-by-variables. Must be specified.}
\item{bootstrap.iter}{Number of bootstrap iterations. Defaults to 20. If set to 1, will return the results from a single optimization run on the input data matrix (i.e., no bootstrapping will be performed).}
\item{clust.method}{Method used to generate variable clusters. Either "kmeans" or "hclust". Defaults to "kmeans".}
\item{k.range}{Range of k-means k values or dendrogram cut sizes. Must be specified.}
\item{kmeans.nstart}{Only relevant if clust.method is "kmeans". K-means nstart value. Defaults to 5.}
\item{kmeans.iter.max}{Only relevant if clust.method is "kmeans".Max number of iterations for k-means. Defaults to 20.}
\item{hclust.method}{Only relevant if clust.method is "hclust". Will be supplied as the "method" argument to the R function \code{hclust}. 
Defaults to "average".}
\item{hclust.cor.method}{Only relevant if clust.method is "hclust". 
Will be supplied as the "method" argument to the R \code{cor} function. Defaults to "spearman". 
Represents the correlation method used to compute the dissimilarity matrix for \code{hclust}. 
Entries in the dissimilarity matrix will take the form (1-correlation)/2.}
}
\value{
Optimized version of the annotation matrix. Contains the average proportion of
cluster sizes in which a given annotation was kept during optimization. 
If bootstrapping is enabled, the optimized matrix will contain the average proportions over all bootstrap resampled datasets.
}
\seealso{
      \code{\link{filterAnnotations}}.      
}
\examples{
   ## Create random sparse annotation matrix for 50 variable groups 
   ## and 100 variables
   annotations = matrix(rbinom(5000,1,.1), nrow=50, ncol=100)

   ## Number of initial annotations
   sum(annotations)

   ## Create random gene expression matrix for 50 observations and 100 variables 
   data = matrix(rnorm(5000), nrow=50, ncol=100)
 
   ## Execute EMVC using k-means
   EMVC.results = EMVC(data=data, annotations=annotations, 
                       bootstrap.iter=30, k.range=2:10, clust.method="kmeans", 
                       kmeans.nstart=3, kmeans.iter.max=10)

   ## Filter the results at .9 threshold
   filtered.opt.annotations = filterAnnotations(EMVC.results, .9)
   
   ## Number of optimized annotations at .9 threshold, should be close to 0 since the
   ## variable groups and data are random (i.e., no random annotations avoid 
   ## optimization-based filtering most of the time)
   sum(filtered.opt.annotations)   
   
   ## Filter the results at .1 threshold
   filtered.opt.annotations = filterAnnotations(EMVC.results, .1)
   
   ## Number of optimized annotations at .1 threshold, should be close to 
   ## the initial number of annotations since the variable groups and data are random 
   ## (i.e., no random variables are consistently filtered by the EMVC algorithm)
   sum(filtered.opt.annotations)      
}
\keyword{file}