function [] = closeMatlabParallel()
%CLOSEMATLABPARALLEL Summary of this function goes here
%   Detailed explanation goes here

poolobj = gcp('nocreate');
delete(poolobj);
end

