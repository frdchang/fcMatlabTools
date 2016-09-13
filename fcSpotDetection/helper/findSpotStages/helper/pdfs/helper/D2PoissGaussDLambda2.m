function D2probData = D2PoissGaussDLambda2(data,lambda,sigma)
%D2POISSGAUSSDLAMBDA2 Summary of this function goes here
%   Detailed explanation goes here


gaussDomSize = 4;

sigmaSteps = round(gaussDomSize*sigma);
gaussDOM = -sigmaSteps:sigmaSteps;
gauss = normpdf(gaussDOM,0,sigma);
gauss = gauss/sum(gauss(:));
poiss = DPoissDLambdaPDF(data+gaussDOM,lambda);
D2probData = sum(gauss.*poiss);


end

