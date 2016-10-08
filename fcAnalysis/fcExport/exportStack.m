function [] = exportStack(filename,stack)
%EXPORTSTACK Summary of this function goes here
%   Detailed explanation goes here

if isinteger(stack)
   exportSingleTifStack(filename,stack); 
else
   exportSingleFitsStack(filename,stack);
end
end

