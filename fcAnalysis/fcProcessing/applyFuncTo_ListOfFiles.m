function inputsOutputs = applyFuncTo_ListOfFiles(listOfFiles,openFileFunc,openFileFuncParams,myFunc,myFuncParams,saveFunc,saveFuncParams,varargin)
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
params.hashOptions    = struct('Format', 'base64', 'Method', 'MD5');
params.hashLength     = 5;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

numApplications = numel(listOfFiles);

if numApplications == 0
    warning('no files to apply func to!');
    return;
end

% generate hash for data inputs and param inputs
if isempty(myFuncParams)
    hashMyFuncParams = {};
else
    hashMyFuncParams = DataHash(myFuncParams,params.hashOptions);
    hashMyFuncParams = hashMyFuncParams(end-params.hashLength:end);
end

outputFiles = cell(numApplications,1);

if params.doParallel
    parfor ii = 1:numApplications
        display(['      applyFuncTo_ListOfFiles(' func2str(myFunc) ' ' num2str(ii) ' of ' num2str(numApplications) ')']);
        extractedVariables  = openFileFunc(listOfFiles{ii},openFileFuncParams{:});
        funcOutput          = cell(nargout(myFunc),1);
        [funcOutput{:}]     = myFunc(extractedVariables{:},myFuncParams{:});
        outputFiles{ii}     = saveFunc(listOfFiles{ii},funcOutput,myFunc,hashMyFuncParams,saveFuncParams{:});
    end
else
    for ii = 1:numApplications
        display(['      applyFuncTo_ListOfFiles(' func2str(myFunc) ' ' num2str(ii) ' of ' num2str(numApplications) ')']);
        extractedVariables  = openFileFunc(listOfFiles{ii},openFileFuncParams{:});
        funcOutput          = cell(nargout(myFunc),1);
        [funcOutput{:}]     = myFunc(extractedVariables{:},myFuncParams{:});
        outputFiles{ii}     = saveFunc(listOfFiles{ii},funcOutput,myFunc,hashMyFuncParams,saveFuncParams{:});
    end
end

inputsOutputs.inputFiles    = listOfFiles;
inputsOutputs.outputFiles   = outputFiles;
inputsOutputs.myFuncParams  = myFuncParams;
inputsOutputs.myFunc        = myFunc;
