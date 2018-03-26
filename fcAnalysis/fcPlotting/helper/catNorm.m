function [ catted ] = catNorm(varargin)
%CATNORM catenate data and norm
catted = [];
for ii =1:numel(varargin)
    if isscalar(varargin{ii})
       continue; 
    end
    catted = [catted norm0to1(varargin{ii}) ];
end
end

