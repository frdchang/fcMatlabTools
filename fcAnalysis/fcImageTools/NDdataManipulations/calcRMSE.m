function [ myRMSE ] = calcRMSE( data1,data2 )
%CALCRMSE Summary of this function goes here
%   Detailed explanation goes here

error = (data1-data2).^2;
myRMSE = sqrt(mean(error(:)));
end

