function [ estimated ] = regularConv( electrons,psfs,varargin)
%REGULARCONV Summary of this function goes here
%   Detailed explanation goes here
for ii = 1:numel(electrons)
    data = electrons{ii};
    data = padarray(data,size(psfs{ii}),'replicate');
    output = convFFTND(data,psfs{ii});
    estimated.regularConv{ii} = unpadarray(output,size(electrons{ii}));
end

end

