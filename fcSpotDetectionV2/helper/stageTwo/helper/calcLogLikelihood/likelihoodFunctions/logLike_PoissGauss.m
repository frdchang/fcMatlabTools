function LL = logLike_PoissGauss(data,lambda,sigmasq)
%LOGLIKELIHOOD_POISSPOISS calculates the log likelihood of observing data
%given lambda and the Poisson*Gauss noise model


if iscell(data) && iscell(lambda) && iscell(sigmasq)
    sigma = cellfunNonUniformOutput(@(sigmasq) sqrt(sigmasq),sigmasq);
    probData = cellfunNonUniformOutput(@(data,lambda,sigma) log(calcPoissGauss(data,lambda,sigma)),data,lambda,sigma);
    idxIsNan = cellfunNonUniformOutput(@(x) isnan(x),probData);
    for ii = 1:numel(idxIsNan)
       probData{ii}(idxIsNan{ii}) = []; 
    end
    
    LL = cellfun(@(probData) sum(probData(:)),probData);
    LL = sum(LL(:));
else
    sigma = sqrt(sigmasq);
    probData = log(calcPoissGauss(data,lambda,sigma));
    probData(isnan(probData)) = [];
    LL = sum(probData(:));
end



