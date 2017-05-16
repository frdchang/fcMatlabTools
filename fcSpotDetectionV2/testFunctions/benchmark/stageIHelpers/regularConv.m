function [ estimated ] = regularConv( electrons,psfs,varargin)
%REGULARCONV Summary of this function goes here
%   Detailed explanation goes here
for ii = 1:numel(electrons)
    estimated.regularConv{ii} = convFFTND(electrons{ii},psfs{ii});
end

end

