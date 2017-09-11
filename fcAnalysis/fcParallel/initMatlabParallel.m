function [] = initMatlabParallel(varargin)
%INITMATLABPARALLEL Summary of this function goes here
%   Detailed explanation goes here

poolobj = gcp('nocreate');

if isempty(poolobj)
    if ~isempty(varargin)
        parpool(varargin{1});
    else
        parpool();
    end
    
else
    
end


