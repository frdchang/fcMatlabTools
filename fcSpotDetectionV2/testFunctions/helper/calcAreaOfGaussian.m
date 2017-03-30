function [ gaussArea ] = calcAreaOfGaussian( sigmaSq )
%CALCAREAOFGAUSSIAN Summary of this function goes here
%   Detailed explanation goes here

gaussArea = sqrt(2*pi) * prod(sqrt(sigmaSq));
end

