## likelihood functions for birth-death & Yule model with incomplete sampling
## written by Liam J. Revell 2017, 2018, 2019, 2020, 2021
## based on likelihood functions in Stadler (2012)

lik.bd<-function(theta,t,rho=1,N=NULL){
    lam<-theta[1]
    mu<-if(length(theta)==2) theta[2] else 0
    if(is.null(N)) N<-length(t)+1
    p0ti<-function(rho,lam,mu,t)
        1-rho*(lam-mu)/(rho*lam+(lam*(1-rho)-mu)*exp(-(lam-mu)*t))
    p1ti<-function(rho,lam,mu,t)
        rho*(lam-mu)^2*exp(-(lam-mu)*t)/(rho*lam+(lam*(1-rho)-mu)*exp(-(lam-mu)*t))^2
    lik<-2*log(p1ti(rho,lam,mu,t[1]))-2*log(1-p0ti(rho,lam,mu,t[1]))
    for(i in 2:length(t)) lik<-lik+log(lam)+log(p1ti(rho,lam,mu,t[i]))
    -(lik+lfactorial(N-1))
}

## model-fitting function for birth-death model

fit.bd<-function(tree,b=NULL,d=NULL,rho=1,...){
	if(!is.ultrametric(tree)){
		cat("tree fails is.ultrametric.\n")
		cat("If you believe your tree actually is ultrametric ")
		cat("use force.ultrametric & try again.\n")
		stop()
	}
    init<-vector(length=2)
    if(hasArg(init.b)) init.b<-list(...)$init.b
    else init.b<-1.1*qb(tree)
    if(hasArg(init.d)) init.d<-list(...)$init.d
    else init.d<-0.1*qb(tree)
	if(hasArg(iter)) iter<-list(...)$iter
	else iter<-10
    if(!is.binary(tree)) tree<-multi2di(tree,random=FALSE)
    T<-sort(branching.times(tree),decreasing=TRUE)
	fit<-nlminb(c(init.b,init.d),lik.bd,t=T,rho=rho,lower=rep(0,2),
		upper=rep(Inf,2))
	if(!is.finite(fit$objective)){
		count<-0
		while(!is.finite(fit$objective)&&count<iter){
			fit<-nlminb(runif(n=2,0,2)*c(init.b,init.d),lik.bd,t=T,rho=rho,
				lower=rep(0,2),upper=rep(Inf,2))
			count<-count+1
		}
	}
    obj<-list(b=fit$par[1],d=fit$par[2],rho=rho,logL=-fit$objective,
        opt=list(counts=fit$counts,convergence=fit$convergence,
        message=fit$message),model="birth-death",
		lik=function(theta) -lik.bd(theta,t=T,rho=rho))
    class(obj)<-"fit.bd"
    obj
}

## fit Yule model

fit.yule<-function(tree,b=NULL,d=NULL,rho=1,...){
	if(hasArg(interval)) interval<-list(...)$interval
	else interval<-c(0,2*qb(tree)/rho)
    if(!is.binary(tree)) tree<-multi2di(tree,random=FALSE)
    T<-sort(branching.times(tree),decreasing=TRUE)
	fit<-optimize(lik.bd,interval,t=T,rho=rho)
	obj<-list(b=fit$minimum,d=0,rho=rho,logL=-fit$objective,
		opt=list(convergence=0),model="Yule",
		lik=function(theta) -lik.bd(c(theta,0),t=T,rho=rho))
    class(obj)<-"fit.bd"
    obj
}

## S3 print method for object class 'fit.bd'

SIGNIF<-function(x,dd){
	tens<-if(abs(x)>1) ceiling(log10(abs(x))) else 0
	signif(x,dd+tens)
}

print.fit.bd<-function(x,...){
    if(hasArg(digits)) digits<-list(...)$digits
    else digits<-4
	cat(paste("\nFitted",x$model,"model:\n\n"))
    cat(paste("ML(b/lambda) =",SIGNIF(x$b,digits),"\n"))
    if(x$model=="birth-death") 
		cat(paste("ML(d/mu) =",SIGNIF(x$d,digits),"\n"))
    cat(paste("log(L) =",SIGNIF(x$logL,digits),"\n"))
    cat(paste("\nAssumed sampling fraction (rho) =",SIGNIF(x$rho,digits),"\n"))
    if(x$opt$convergence==0) cat("\nR thinks it has converged.\n\n")
    else cat("\nR thinks optimization may not have converged.\n\n")
}

## S3 logLik method

logLik.fit.bd<-function(object,...){
	logLik<-object$logL
	attr(logLik,"df")<-if(object$model=="birth-death") 2 else 1
	logLik
}

## helper function

qb<-function(tree) (Ntip(tree)-2)/sum(tree$edge.length)

