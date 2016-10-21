function [] = initMatlabParallel()
%INITMATLABPARALLEL Summary of this function goes here
%   Detailed explanation goes here

poolobj = gcp('nocreate');

if isempty(poolobj)
   display('starting parallel resource');
   parpool(); 
else
    
end


