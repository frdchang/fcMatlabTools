function [ estimated ] = logConv(electrons,psfs,varargin)
%LOGCONV Summary of this function goes here
%   Detailed explanation goes here

% the 3D sigmas are from these settings that should be in genBenchmark
% params.psfFuncArgs      = {{'lambda',514e-9,'onlyPSF',false},{'lambda',610e-9,'onlyPSF',false}};
% psfs        = cellfunNonUniformOutput(@(x) params.psfFunc(x{:}),params.psfFuncArgs);

psfs1 = [0.851594945672866;0.851594945693638;0.847455759928694];
psfs2 = [0.988514633034135;0.988514632883964;0.993139588899949];

sizePsfs = cellfunNonUniformOutput(@getPatchSize,psfs);
psfs = {psfs1,psfs2};

for ii = 1:numel(electrons)
    data = electrons{ii};
    data = padarray(data,size(psfs{ii}),'replicate');
    output = convFFTND(data,LOG3D(psfs{ii}.^2,sizePsfs{ii}));
    estimated.logConv{ii} = unpadarray(output,size(electrons{ii}));
end






