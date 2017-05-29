function D2probData = D2PoissGaussDLambda2(data,lambda,sigma)
%D2POISSGAUSSDLAMBDA2 Summary of this function goes here
%   Detailed explanation goes here

if sigma == inf || sigma == -inf
   D2probData = nan;
   return;
end
gaussDomSize = 6;

sigmaSteps = round(gaussDomSize*(sigma+lambda));
gaussDOM = -sigmaSteps:sigmaSteps;
shiftDOM = data+gaussDOM;
shiftDOM = round(shiftDOM);
gauss = normpdf(shiftDOM,data,sigma);
gauss = gauss/sum(gauss(:));
poiss = D2PoissDLambda2PDF(shiftDOM,lambda);
poiss(isnan(poiss)) = 0;
% no negative values

D2probData = sum(gauss.*poiss);

% plot(shiftDOM,gauss);hold on;plot(shiftDOM,poiss);plot(data,0,'rx');plot(lambda,0,'go');legend('gauss','poiss','data','lambda');
% plot(shiftDOM,contPoissPDF(shiftDOM,lambda));
% gaussDomSize = 4;
% 
% sigmaSteps = round(gaussDomSize*sigma);
% gaussDOM = -sigmaSteps:sigmaSteps;
% gauss = normpdf(gaussDOM,0,sigma);
% gauss = gauss/sum(gauss(:));
% poiss = D2PoissDLambda2PDF(data+gaussDOM,lambda);
% D2probData = sum(gauss.*poiss);


end

