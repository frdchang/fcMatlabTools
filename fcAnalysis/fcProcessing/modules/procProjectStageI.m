function [projFuncOutput] = procProjectStageI(stageIOutput,varargin )
%PROCAPPLYTOIMAGES Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.projFunc     = @maxColoredProj;
params.projFuncArg  = {3};
params.doProcParallel = false;
params.hashOptions    = struct('Format', 'base64', 'Method', 'MD5');
params.hashLength     = 5;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% generate hash for data inputs and param inputs
if isempty(params.projFuncArg)
    hashMyFuncParams = {};
else
    hashMyFuncParams = DataHash(cellfunNonUniformOutput(@(x) gather(x),params.projFuncArg),params.hashOptions);
    hashMyFuncParams = removeFileSep(hashMyFuncParams);
    hashMyFuncParams = hashMyFuncParams(end-params.hashLength:end);
end


projFuncOutput.inputFiles = stageIOutput.outputFiles;
projFuncOutput.outputFiles = table;
tableNames = stageIOutput.outputFiles.Properties.VariableNames;
setupParForProgress(numel(tableNames));
for ii = 1:numel(tableNames)
    currEntry = stageIOutput.outputFiles.(tableNames{ii});
    if ~isIMGFile(currEntry)
        continue;
    end
    currTable = table;
    for jj = 1:numel(currEntry)
        currElement = currEntry{jj};
        if iscell(currElement)
            saveFile = cell(numel(currElement),1);
            for kk = 1:numel(currElement)
                thisFile = currElement{kk};
                thisData = importStack(thisFile);
                outData  = params.projFunc(thisData,params.projFuncArg{:});
                saveProcFile = genProcessedFileName({thisFile},params.projFunc,'paramHash',hashMyFuncParams);
                saveFile{kk} = exportStack(saveProcFile,outData);
            end
        else
            thisFile = currElement;
            thisData = importStack(currElement);
            outData  = params.projFunc(thisData,params.projFuncArg{:});
            saveProcFile = genProcessedFileName({thisFile},params.projFunc,'paramHash',hashMyFuncParams);
            saveFile = exportStack(saveProcFile,outData);
        end
        currTable = vertcat(currTable,table({saveFile},'VariableNames',tableNames(ii)));
    end
    projFuncOutput.outputFiles = horzcat(projFuncOutput.outputFiles,currTable);
    incrementParForProgress();
end


% allFiles = flattenTable(stageIOutput.outputFiles);
% imageFiles = keepCertainStringsUnion(allFiles,{'tif','fits'});
% imageFiles = convertListToListofArguments(imageFiles);
%
% projFuncOutput    = applyFuncTo_listOfListOfArguments(imageFiles,@openImage_applyFuncTo,{},params.projFunc,{params.projFuncArg{:}},@saveToProcessed_images,{},'doParallel',params.doProcParallel);

projFuncOutput = procSaver(stageIOutput,projFuncOutput,[func2str(params.projFunc) 's']);
end

