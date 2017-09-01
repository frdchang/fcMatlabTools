
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
%
% notes: this function can pass to a cluster, therefore additional
% parameters,e.g. those required for sendFuncsByBatch and setupCluster can
% take parameters.
%
% 'setWallTime','00:20:00','setMemUsage','900','useBatchWorkers',12,'doParallel',true

%--parameters--------------------------------------------------------------
params.doProcParallel  = false;
params.useBatchWorkers = 0;  % if this is greater than zero, then this functin will batch the parallel work

params.hashOptions     = struct('Format', 'base64', 'Method', 'MD5');
params.hashLength      = 5;
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

if params.doProcParallel
    if params.useBatchWorkers > 0
        disp(['----------applyFuncTo_ListOfFiles(batch ' func2str(myFunc) ' of ' num2str(numApplications) ')--------------------']);
        batchFunc   = @(listOfArguments) batchHelper(listOfArguments,openFileFunc,openFileFuncParams,myFunc,myFuncParams,saveFunc,hashMyFuncParams,saveFuncParams);
        outputFiles = sendFuncsByBatch(batchFunc,listOflistOfArguments,params.useBatchWorkers,varargin{:});
        outputFiles = vertcat(outputFiles{:});
    else
        initMatlabParallel();
        parfor ii = 1:numApplications
            disp(['----------applyFuncTo_ListOfFiles(' func2str(myFunc) ' ' num2str(ii) ' of ' num2str(numApplications) ')--------------------']);
            extractedVariables  = openFileFunc(listOflistOfArguments{ii}{:},openFileFuncParams{:});
            funcOutput          = cell(nargout(myFunc),1);
            [funcOutput{:}]     = myFunc(extractedVariables{:},myFuncParams{:});
            outputFiles{ii}     = saveFunc(listOflistOfArguments{ii},funcOutput,myFunc,hashMyFuncParams,saveFuncParams{:});
        end
    end
else
    for ii = 1:numApplications
        disp(['----------applyFuncTo_ListOfFiles(' func2str(myFunc) ' ' num2str(ii) ' of ' num2str(numApplications) ')--------------------']);
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

end



% function output = expandHelper(this,numApplications)
% output = cell(numApplications,1);
% [output{:}] = deal(this);
% output = convertListToListofArguments(output);
% end
