function [probData] = calcPoissGauss(data,lambda,sigma)
%POISSGAUSS returns the probability of seeing data given lambda sigma and
%zero offset, for now it is not vectorized so provide one at a time.

gaussDomSize = 4;

sigmaSteps = round(gaussDomSize*sigma);
gaussDOM = -sigmaSteps:sigmaSteps;
gauss = normpdf(gaussDOM,0,sigma);
gauss = gauss/sum(gauss(:));
poiss = poisspdf(data+gaussDOM,lambda);
probData = sum(gauss.*poiss);

end

