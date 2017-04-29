function LL = logLike_PoissGauss(data,lambda,sigmasq)
%LOGLIKELIHOOD_POISSPOISS calculates the log likelihood of observing data
%given lambda and the Poisson*Gauss noise model


if iscell(data) && iscell(lambda) && iscell(sigmasq)
    sigma = cellfunNonUniformOutput(@(sigmasq) sqrt(sigmasq),sigmasq);
    probData = cellfunNonUniformOutput(@(data,lambda,sigma) log(calcPoissGauss(data,lambda,sigma)),data,lambda,sigma);
    LL = cellfun(@(probData) sum(probData(:)),probData);
    LL = sum(LL(:));
else
    sigma = sqrt(sigmasq);
    probData = calcPoissGauss(data,lambda,sigma);
    LL = sum(probData(:));
end



