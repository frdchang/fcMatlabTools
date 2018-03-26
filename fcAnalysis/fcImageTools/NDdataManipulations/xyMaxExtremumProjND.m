function [projectedData ] = xyMaxExtremumProjND(data,varargin)
%MAXEXTREMUMPROJ will apply a maximum extremum projection away from 0


sizeData = size(data);
maxdata = data;
for i = 3:1:numel(sizeData)
    maxdata = max(maxdata,[],i);
end

mindata = data;
for i = 3:1:numel(sizeData)
    mindata = min(mindata,[],i);
end

projectedData = maxdata;
projectedData(maxdata <= 0 ) = mindata(maxdata<=0);

