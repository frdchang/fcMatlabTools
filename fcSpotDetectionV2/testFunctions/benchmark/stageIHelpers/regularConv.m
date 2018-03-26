function [ estimated ] = regularConv( electrons,psfs,varargin)
%REGULARCONV Summary of this function goes here
%   Detailed explanation goes here
for ii = 1:numel(electrons)
    data = electrons{ii};
    data = padarray(data,getPatchSize(psfs{ii}),'replicate');
    if iscell(psfs{1})
        output = convSeparableND(data,psfs{ii});
    else
            output = convFFTND(data,psfs{ii});

    end
    estimated.regularConv{ii} = unpadarray(output,size(electrons{ii}));
end

end

