function [ data ] = setNaNsToZero( data )
%SETNANSTOZERO Summary of this function goes here
%   Detailed explanation goes here

data(isnan(data)) = 0;
end

