function LL = logLike_PoissGauss(data,lambda,sigmasq)
%LOGLIKELIHOOD_POISSPOISS calculates the log likelihood of observing data
%given lambda and the Poisson*Gauss noise model
sigma = sqrt(sigmasq);
probData = calcPoissGauss(data,lambda,sigma);
LL = sum(probData(:));
end

