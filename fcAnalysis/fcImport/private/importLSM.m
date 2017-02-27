function [ stack ] = importLSM(zeissLSMfilePath )
%IMPORTLSM Summary of this function goes here
%   Detailed explanation goes here

stackTemp = tiffread(zeissLSMfilePath);
if iscell(stackTemp(1).data)
    numChannels = numel(stackTemp(1).data);
    stack = cell(numChannels,1);
    for ii = 1:numel(stackTemp)
        for jj = 1:numChannels
           stack{jj}(:,:,ii) = stackTemp(ii).data{jj}; 
        end
    end
    
else
    stack = zeros([size(stackTemp(1).data),numel(stackTemp)]);
    
    for ii = 1:numel(stackTemp)
        stack(:,:,ii) = stackTemp(ii).data;
    end
end


