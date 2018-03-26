function myImage = openImage_applyFuncTo(varargin)
%OPENIMAGE_APPLYFUNCTO opens the image at filePath
if numel(varargin) == 1
    myImage = {importStack(varargin{1})};
else
    myImage = {cellfunNonUniformOutput(@(x) importStack(x),varargin)};

end

end

