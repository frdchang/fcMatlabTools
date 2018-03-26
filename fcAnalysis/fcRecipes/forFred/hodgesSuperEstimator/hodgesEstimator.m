function [ myEst ] = hodgesEstimator(data)
%HODGESESTIMATOR Summary of this function goes here
%   Detailed explanation goes here

myEst = mean(data(:));

if abs(myEst) >= numel(data)^(-1/4)
    
else
    myEst = 0;
end
   
end

