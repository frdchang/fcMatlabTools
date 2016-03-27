function LL = logLike_PoissPoiss(data,lambda,sigmasq)
%LOGLIKELIHOOD_POISSPOISS calculates the log likelihood of observing data
%given lambda and the Poisson*Poisson noise model

LL = (-1).*lambda+(-1).*sigmasq+(data+sigmasq).*log(lambda+sigmasq); %+(-1).*log(gamma(data+sigmasq+1));
LL = sum(LL(:));
end

