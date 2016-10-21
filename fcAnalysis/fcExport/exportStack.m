function filename = exportStack(filename,stack)
%EXPORTSTACK Summary of this function goes here
%   Detailed explanation goes here

if isinteger(stack)
   filename = [filename '.tif'];
   exportSingleTifStack(filename,stack); 
else
    filename = [filename '.fits'];
   exportSingleFitsStack(filename,stack);
end
end

