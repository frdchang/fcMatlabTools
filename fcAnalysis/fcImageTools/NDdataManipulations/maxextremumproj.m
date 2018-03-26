function [ proj ] = maxextremumproj(I,ndir )
%MAXEXTREUMUMPROJ Summary of this function goes here
%   Detailed explanation goes here

if size(I, 3)<2
%     error(['Input image is not a volume. Works only on images where ', ...
%         'the third dimension size is greater than one.']);
proj = I;
else
proj(:, :) = max(I, [], ndir);
end

minproj(:,:) = min(I,[],ndir);

proj(proj<=0) = minproj(proj<=0);

