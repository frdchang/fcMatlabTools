function [probData] = calcPoissGauss(data,lambda,sigma)
%POISSGAUSS returns the probability of seeing data given lambda sigma and
%zero offset, for now it is not vectorized.
if isscalar(lambda) && ~isscalar(data)
   lambda = lambda*ones(size(data)); 
end
probData = arrayfun(@localCalcPoissGauss,data,lambda,sigma);

end

function probData = localCalcPoissGauss(data,lambda,sigma)

if sigma == inf || sigma == -inf
   probData = 0;
   return;
end
gaussDomSize = 6;

if lambda<0
    lambda = 0;
end

sigmaSteps = round(gaussDomSize*(sigma));
gaussDOM = -sigmaSteps:sigmaSteps;
shiftDOM = data+gaussDOM;
shiftDOM = round(shiftDOM);
gauss = normpdf(shiftDOM,data,sigma);
gauss = gauss/sum(gauss(:));
poiss = contPoissPDF(shiftDOM,lambda);
poiss(shiftDOM<0) = 0;
poiss(isnan(poiss)) = 0;
% no negative values

probData = sum(gauss.*poiss);

end