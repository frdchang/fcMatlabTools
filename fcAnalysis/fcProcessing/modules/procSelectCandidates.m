function [ selectCands ] = procSelectCandidates(stageIOutputs,varargin )
%PROJSELECTCANDIDATES Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.doProcParallel     = true;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

stageIStructs   = grabFromListOfCells(stageIOutputs.outputFiles,{['@(x) x{end}']});
stageIStructs   = convertListToListofArguments(stageIStructs);

selectCands     = applyFuncTo_listOfListOfArguments(stageIStructs,@openData_load,{},@selectCandidates,{varargin{:}},@saveToProcessed_selectCandidates,{},'doParallel',params.doProcParallel);


expFolder = stageIOutputs.expFolder;



saveFile = strcat(expFolder,filesep,'processingState');
saveFile = saveFile{1};
saveFile = [saveFile '.mat'];

if exist(saveFile,'file')==0
    save(saveFile,'selectCands');
else
    save(saveFile,'selectCands','-append');
end


end

