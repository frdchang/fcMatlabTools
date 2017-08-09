function [ tracked ] = extractTrajs( peaks)
%EXTRACTTRAJS Summary of this function goes here
%   Detailed explanation goes here
nframe = numel(peaks);

% append timepoints to peaks
peaks = updateTimePoints(peaks);
% initialize tracks given first time point
tracked = num2cell(peaks{1},2);
% append tracks
for t=2:nframe
    [nextidx,homeidx] = getConnections(tracked);
    % connect tracks
    for ii = 1:numel(homeidx)
       tracked{homeidx(ii)} = [tracked{homeidx(ii)} ;peaks{t}(nextidx(ii),:)];
    end
    
    % append left overs
    leftOverIdx = find(peaks{t}(:,7)<0);
    for ii = 1:numel(leftOverIdx)
       tracked{end+1} = peaks{t}(leftOverIdx(ii),:); 
    end
    
    
end

end

function peaks = updateTimePoints(peaks)
for t = 1:numel(peaks)
    currPeaks = peaks{t};
    time = t*ones(size(currPeaks,1),1);
    peaks{t} = [time currPeaks];
end

end

function [nextidx,homeidx] = getConnections(tracked)
idx = [];
for ii = 1:numel(tracked)
    idx(end+1) = tracked{ii}(end,7);
end
nextidx = idx(idx>0);
homeidx = find(idx>0);
end

%     X = [peaks{t-1}(oldindPos,1), peaks{t}(curind,1)];
%     Y = [peaks{t-1}(oldindPos,2), peaks{t}(curind,2)];
%     Z = [peaks{t-1}(oldindPos,3), peaks{t}(curind,3)];
%     A = [peaks{t-1}(oldindPos,4), peaks{t}(curind,4)];
%     B = [peaks{t-1}(oldindPos,5), peaks{t}(curind,5)];
%
%