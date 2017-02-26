function [ stack ] = importLSM(zeissLSMfilePath )
%IMPORTLSM Summary of this function goes here
%   Detailed explanation goes here

stackTemp = tiffread(zeissLSMfilePath);
stack = zeros([size(stackTemp(1).data),numel(stackTemp)]);

for ii = 1:numel(stackTemp)
   stack(:,:,ii) = stackTemp(ii).data; 
end
end

