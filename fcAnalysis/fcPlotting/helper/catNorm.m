function [ catted ] = catNorm(varargin)
%CATNORM catenate data and norm
catted = [];
for ii =1:numel(varargin)
    catted = [norm0to1(varargin{ii}) catted];
end
end

