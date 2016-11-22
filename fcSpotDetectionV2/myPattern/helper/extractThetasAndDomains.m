function [posCoor,mySigmas,myDomains] = extractThetasAndDomains(obj,theta,domains)
%EXTRACTTHETASANDDOMAINS Summary of this function goes here
%   Detailed explanation goes here

obj.numDims = numel(theta)/2;
posCoor = zeros(1,3);
posCoor(1:obj.numDims) = theta(1:obj.numDims);
mySigmas = theta(obj.numDims+1:end);
myDomains = cell(1,3);
myDomains(1:obj.numDims) = domains;
for ii = obj.numDims+1:3
    posCoor(ii) = 0;
    mySigmas(ii) = inf;
    myDomains{ii} = zeros(size(domains{1}));
end


