function LL = logLike_PoissPoiss(data,lambda,sigmasq)
%LOGLIKELIHOOD_POISSPOISS calculates the log likelihood of observing data
%given lambda and the Poisson*Poisson noise model

if iscell(data) && iscell(lambda)
    LL = cellfunNonUniformOutput(@(data,lambda,sigmasq) (-1).*lambda+(-1).*sigmasq+(data+sigmasq).*log(lambda+sigmasq),data,lambda,sigmasq);
    idxIsNan = cellfunNonUniformOutput(@(x) isnan(x),LL);
    for ii = 1:numel(idxIsNan)
       LL{ii}(idxIsNan{ii}) = []; 
    end
    LL = cellfun(@(x) sum(x(:)), LL);
    LL = sum(LL(:));
else
    LL = (-1).*lambda+(-1).*sigmasq+(data+sigmasq).*log(lambda+sigmasq); %+(-1).*log(gamma(data+sigmasq+1));
    LL(isnan(LL)) = [];
    LL = sum(LL(:));
end

