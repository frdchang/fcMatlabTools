function [data] = xyMaxProjND(data,varargin)
%XYMAXPROJND given an nd dataset will return the xy maximum projection

sizeData = size(data);

for i = 3:1:numel(sizeData)
    data = max(data,[],i);
end


end

