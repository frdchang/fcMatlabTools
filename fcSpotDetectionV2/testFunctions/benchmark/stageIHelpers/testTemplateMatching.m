function [ estimated ] = testTemplateMatching(  electrons,psfs,varargin)
%TESTTEMPLATEMATCHING Summary of this function goes here
%   Detailed explanation goes here
if iscell(psfs{1})
    psfs = cellfunNonUniformOutput(@genKernelFromSep,psfs);
end
for ii = 1:numel(electrons)
     data = electrons{ii};
     data = padarray(data,size(psfs{ii}),'replicate');
     [~,output,~] = template_matching(psfs{ii},data);
     estimated.testTemplateMatching{ii}= unpadarray(output,size(electrons{ii}));

% [~,estimated.testTemplateMatching{ii},~] = template_matching(psfs{ii},electrons{ii});
end
end

