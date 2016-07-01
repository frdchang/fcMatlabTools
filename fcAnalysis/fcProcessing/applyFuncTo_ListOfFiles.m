function [] = applyFuncTo_ListOfFiles(listOfFiles,openFileFunc,openFileFuncParams,myFunc,myFuncParams,saveFunc,saveFuncParams,varargin)
%APPLYFUNCTO_LISTOFFILES will apply a function to a list of files
%
% listOfFiles:          a cell list of all the files to be processed
% openFileFunc:         function that opens the file and extracts relevant
%                       variables.
%                       eg. [stack] = openImages4applyFunc(filePath)
% openFileFuncParams:   parameters to be passed to openFileFunc
% myFunc:               function to be applied to the opened file
% myFuncParams:         parameters for that function
% saveFunc:             function that directs how to save the output, it
%                       will be passed the filelocation, the function that
%                       called it, the parameters for that function, the
%                       function output and the saveFunc params.  given
%                       this information, you can specify how to save the
%                       output
% saveFuncParams:       params for that function

%--parameters--------------------------------------------------------------
params.doParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

numFiles = numel(listOfFiles);

if params.doParallel
    
else
    for ii = 1:numFiles
        display(ii);
        extractedVariables = openFileFunc(listOfFiles{ii},openFileFuncParams{:});
        funcOutput         = myFunc(extractedVariables{:},myFuncParams{:});
        saveFunc(listOfFiles{ii},myFunc,myFuncParams,funcOutput,saveFuncParams{:});
    end
end
