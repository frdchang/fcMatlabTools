function [probData] = calcPoissGauss(data,lambda,sigma)
%POISSGAUSS returns the probability of seeing data given lambda sigma and
%zero offset, for now it is not vectorized.

probData = arrayfun(@localCalcPoissGauss,data,lambda,sigma);

end

function probData = localCalcPoissGauss(data,lambda,sigma)
gaussDomSize = 6;

sigmaSteps = round(gaussDomSize*(sigma+lambda));
gaussDOM = -sigmaSteps:sigmaSteps;
shiftDOM = data+gaussDOM;
shiftDOM = round(shiftDOM);
gauss = normpdf(shiftDOM,0,sigma);
gauss = gauss/sum(gauss(:));
poiss = contPoissPDF(shiftDOM,lambda);
% no negative values

probData = sum(gauss.*poiss);

end