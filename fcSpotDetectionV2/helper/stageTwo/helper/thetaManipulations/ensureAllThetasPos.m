function [ posTheta0 ] = ensureAllThetasPos( theta0 )
%ENSUREALLTHETASPOS Summary of this function goes here
%   Detailed explanation goes here

numericThet0s = flattenTheta0s(theta0);
numericThet0s(numericThet0s<0) = 0;
posTheta0 = updateTheta0s(theta0,numericThet0s);

end

