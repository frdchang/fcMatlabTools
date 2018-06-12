function estimated = testPhaseCorrelation(electrons,psfs,varargin)
%TESTTEMPLATEMATCHING Summary of this function goes here
%   Detailed explanation goes here

gaussianFilterSigma = 1.9;
 

if iscell(psfs{1})
    psfs = cellfunNonUniformOutput(@genKernelFromSep,psfs);
end
for ii = 1:numel(electrons)
    data = electrons{ii};
    data = padarray(data,size(psfs{ii}),'replicate');
    output = phaseCorrelation(data,psfs{ii},gaussianFilterSigma);
    estimated.testPhaseCorrelation{ii}= unpadarray(output,size(electrons{ii}));
end
end

