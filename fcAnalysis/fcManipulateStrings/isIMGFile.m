function [ isImg ] = isIMGFile( file )
%ISIMGFILE checks if the file or cell of files is either a tif or fits

imgext = {'.tif','.TIF','.fits'};
if iscell(file)
    file = flattenCellArray(file);
    file = cellfunNonUniformOutput(@(x) strcmp(returnFileExt(x),imgext),file);
    file = cellfun(@any,file);
    isImg = all(file);
else
    isImg = any(strcmp(returnFileExt(file),imgext));
end


