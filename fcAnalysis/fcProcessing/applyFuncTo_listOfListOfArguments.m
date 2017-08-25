
function inputsOutputs = applyFuncTo_listOfListOfArguments(listOflistOfArguments,openFileFunc,openFileFuncParams,myFunc,myFuncParams,saveFunc,saveFuncParams,varargin)
%APPLYFUNCTO_LISTOFFILES will apply a function to a list of files
%
% listOfListOfArguments:a list of argument lists
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

numApplications = numel(listOflistOfArguments);

if numApplications == 0
    warning('no files to apply func to!');
    inputsOutputs = [];
    return;
end

% generate hash for data inputs and param inputs
if isempty(myFuncParams)
    hashMyFuncParams = {};
else
    hashMyFuncParams = DataHash(cellfunNonUniformOutput(@(x) gather(x),myFuncParams),params.hashOptions);
    hashMyFuncParams = removeFileSep(hashMyFuncParams);
    hashMyFuncParams = hashMyFuncParams(end-params.hashLength:end);
end

outputFiles = cell(numApplications,1);

% funcOutputs = cell(numApplications,1);
%     for ii = 1:numApplications
%         disp(['----------applyFuncTo_ListOfFiles(' func2str(myFunc) ' ' num2str(ii) ' of ' num2str(numApplications) ')--------------------']);
%         extractedVariables  = openFileFunc(listOflistOfArguments{ii}{:},openFileFuncParams{:});
%         numFuncOutput       = nargout(myFunc);
%         funcArgs            = {extractedVariables{:},myFuncParams{:}};
%         funcOutputs{ii}     = batch(myFunc,numFuncOutput,funcArgs,'pool',params.numWorkers);
%     end
%     
%             outputFiles{ii}     = saveFunc(listOflistOfArguments{ii},funcOutput,myFunc,hashMyFuncParams,saveFuncParams{:});
if params.doParallel
    initMatlabParallel();
    parfor ii = 1:numApplications
        display(['----------applyFuncTo_ListOfFiles(' func2str(myFunc) ' ' num2str(ii) ' of ' num2str(numApplications) ')--------------------']);
        extractedVariables  = openFileFunc(listOflistOfArguments{ii}{:},openFileFuncParams{:});
        funcOutput          = cell(nargout(myFunc),1);
        [funcOutput{:}]     = myFunc(extractedVariables{:},myFuncParams{:});
        outputFiles{ii}     = saveFunc(listOflistOfArguments{ii},funcOutput,myFunc,hashMyFuncParams,saveFuncParams{:});
    end
else
    for ii = 1:numApplications
        display(['----------applyFuncTo_ListOfFiles(' func2str(myFunc) ' ' num2str(ii) ' of ' num2str(numApplications) ')--------------------']);
        extractedVariables  = openFileFunc(listOflistOfArguments{ii}{:},openFileFuncParams{:});
        funcOutput          = cell(nargout(myFunc),1);
        [funcOutput{:}]     = myFunc(extractedVariables{:},myFuncParams{:});
        outputFiles{ii}     = saveFunc(listOflistOfArguments{ii},funcOutput,myFunc,hashMyFuncParams,saveFuncParams{:});
    end
end
outputFiles = vertcat(outputFiles{:});

inputsOutputs.inputFiles    = table(listOflistOfArguments,'VariableNames',{inputname(1)});
inputsOutputs.outputFiles   = outputFiles;
inputsOutputs.myFuncParams  = myFuncParams;
inputsOutputs.myFunc        = myFunc;
