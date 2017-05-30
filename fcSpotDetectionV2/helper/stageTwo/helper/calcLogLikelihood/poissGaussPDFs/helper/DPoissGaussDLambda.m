function DprobData = DPoissGaussDLambda(data,lambda,sigma)
%DPOISSGAUSSDLAMBDA Summary of this function goes here
%   Detailed explanation goes here

% gaussDomSize = 4;
% 
% sigmaSteps = round(gaussDomSize*sigma);
% gaussDOM = -sigmaSteps:sigmaSteps;
% gauss = normpdf(gaussDOM,0,sigma);
% gauss = gauss/sum(gauss(:));
% poiss = DPoissDLambdaPDF(data+gaussDOM,lambda);
% DprobData = sum(gauss.*poiss);


if sigma == inf || sigma == -inf
   DprobData = 0;
   return;
end
gaussDomSize = 6;
if lambda<0
    lambda = 0;
end
sigmaSteps = round(gaussDomSize*(sigma+lambda));
gaussDOM = -sigmaSteps:sigmaSteps;
shiftDOM = data+gaussDOM;
shiftDOM = round(shiftDOM);
gauss = normpdf(shiftDOM,data,sigma);
gauss = gauss/sum(gauss(:));
poiss = DPoissDLambdaPDF(shiftDOM,lambda);
poiss(isnan(poiss)) = 0;
poiss(shiftDOM<0) = 0;

% no negative values

DprobData = sum(gauss.*poiss);
end

