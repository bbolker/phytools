\name{phyl.pca}
\alias{phyl.pca}
\alias{biplot.phyl.pca}
\alias{scores}
\alias{scores.phyl.pca}
\alias{as.princomp}
\alias{as.princomp.phyl.pca}
\title{Phylogenetic principal components analysis}
\usage{
phyl.pca(tree, Y, method="BM", mode="cov", ...)
\method{biplot}{phyl.pca}(x, ...)
scores(object, ...)
\method{scores}{phyl.pca}(object, ...)
as.princomp(x, ...)
\method{as.princomp}{phyl.pca}(x, ...)
}
\arguments{
	\item{tree}{phylogeny as an object of class \code{"phylo"}.}
	\item{Y}{data matrix with traits in columns.}
	\item{method}{method to obtain the correlation structure: can be \code{"BM"} or \code{"lambda"}.}
	\item{mode}{is the mode for the PCA: can be \code{"cov"} or \code{"corr"}.}
	\item{x}{object of class \code{"phyl.pca"} for \code{biplot} and \code{as.princomp} methods.}
	\item{object}{object of class \code{"phyl.pca"} for \code{scores} method.}
	\item{...}{for S3 plotting method \code{biplot.phyl.pca}, other arguments to be passed to \code{\link{biplot}}.}
}
\description{
	This function performs phylogenetic PCA (e.g., Revell 2009; \emph{Evolution}).
}
\details{
	If \code{method="lambda"} then \eqn{\lambda} will be optimized on the interval (0,1) using \code{\link{optimize}}. Optimization method can be set using the option \code{opt} which can take values \code{"ML"}, \code{"REML"}, or \code{"fixed"}. If the last of these is selected than the user should also specify a value of \eqn{\lambda} to use via the argument \code{lambda}. 
	
	S3 methods (\code{print}, \code{summary}, and \code{biplot}) are modified from code provided by Joan Maspons and are based on the same methods for objects of class \code{"prcomp"}. Function \code{biplot} now permits the argument \code{choices} to be supplied, which should be a vector of length two indicated the two PC axes to be plotted.
	
	S3 method \code{scores} extracts or computes (for a matrix of \code{newdata}) PC scores given an object of class \code{"phyl.pca"}.
}
\value{
	An object of class \code{"phyl.pca"} consisting of a list with some or all of the following components:
	\item{Eval}{diagonal matrix of eigenvalues.}
	\item{Evec}{matrix with eigenvectors in columns.}
	\item{S}{matrix with scores.}
	\item{L}{matrix with loadings.}
	\item{lambda}{fitted value of \eqn{\lambda} (\code{method="lambda"} only).}
	\item{logL}{log-likelihood for \eqn{\lambda} model (\code{method="logL"} only).}
}
\references{
	Revell, L. J. (2009) Size-correction and principal components for interspecific comparative studies. \emph{Evolution}, \bold{63}, 3258-3268.

	Revell, L. J. (2012) phytools: An R package for phylogenetic comparative biology (and other things). \emph{Methods Ecol. Evol.}, \bold{3}, 217-223.
}
\author{Liam Revell \email{liam.revell@umb.edu}, Joan Maspons}
\seealso{
	\code{\link{phyl.cca}}, \code{\link{phyl.resid}}
}
\examples{
## load data from Mahler et al. (2010)
data(anoletree)
data(anole.data)
## run phylogenetic PCA
anole.pca<-phyl.pca(anoletree,anole.data)
print(anole.pca)
## plot results
plot(anole.pca)
biplot(anole.pca)
}
\keyword{phylogenetics}
\keyword{maximum likelihood}
\keyword{comparative method}
\keyword{statistics}
