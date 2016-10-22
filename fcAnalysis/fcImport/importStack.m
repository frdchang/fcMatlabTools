function stack = importStack(filename)
%IMPORTSTACK imports either tif or fits stack.

[~,~,ext] = fileparts(filename);
if exists(filename) == 0
   stack = [];
   return;
end
switch ext
    case {'.fit','.fits'}
        stack = importFits(filename);
    case {'.tif','.TIF'}
         stack = importSingleTiffStack(filename);
    otherwise
       
        try
            stack = importSingleTiffStack(filename);
        catch
           try
               stack = importFits(filename);
           catch
               error('do not recognize file extension'); 
           end
        end
end

stack = double(stack);

end

