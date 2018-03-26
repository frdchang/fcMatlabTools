function [ estimated ] = testTemplateMatching(  electrons,psfs,varargin)
%TESTTEMPLATEMATCHING Summary of this function goes here
%   Detailed explanation goes here
if iscell(psfs{1})
    psfs = cellfunNonUniformOutput(@genKernelFromSep,psfs);
end
for ii = 1:numel(electrons)
    [~,estimated.testTemplateMatching{ii},~] = template_matching(psfs{ii},electrons{ii});
end
end

