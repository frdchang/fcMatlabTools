function filename = exportStack(filename,stack)
%EXPORTSTACK Summary of this function goes here
%   Detailed explanation goes here

% tiffwriteimj(stack,[filename '.tif']);
if isequal(unique(stack),[0 ;1])
stack = uint8(stack);
end
if isinteger(stack)
   filename = [filename '.tif'];
   if size(stack,3) == 3
       imwrite(stack,filename);
   else
       
   exportSingleTifStack(filename,stack); 
   end
else
    filename = [filename '.fits'];
   exportSingleFitsStack(filename,stack);
end
end

