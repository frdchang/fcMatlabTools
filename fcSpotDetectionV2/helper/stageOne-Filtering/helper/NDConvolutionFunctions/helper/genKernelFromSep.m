function [ kern ] = genKernelFromSep( separableKern )
%GENKERNELFROMSEP Summary of this function goes here
%   Detailed explanation goes here

kern = convn(separableKern{1},separableKern{2});

for ii = 3:numel(separableKern)
   kern = convn(kern,separableKern{ii}); 
end
end

