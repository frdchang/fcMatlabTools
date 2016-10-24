function [] = initMatlabParallel()
%INITMATLABPARALLEL Summary of this function goes here
%   Detailed explanation goes here

poolobj = gcp('nocreate');

if isempty(poolobj)
   parpool(); 
else
    
end


