function DprobData = DPoissGaussDLambda(data,lambda,sigma)
%DPOISSGAUSSDLAMBDA Summary of this function goes here
%   Detailed explanation goes here

gaussDomSize = 4;

sigmaSteps = round(gaussDomSize*sigma);
gaussDOM = -sigmaSteps:sigmaSteps;
gauss = normpdf(gaussDOM,0,sigma);
gauss = gauss/sum(gauss(:));
poiss = DPoissDLambdaPDF(data+gaussDOM,lambda);
DprobData = sum(gauss.*poiss);

end

