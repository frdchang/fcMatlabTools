function [ isit ] = isNaturalNum( A )
%ISNATURALNUM Summary of this function goes here
%   Detailed explanation goes here

isit = A == round(A);
isit = isit & A>0;
end

