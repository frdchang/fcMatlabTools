function [ benchStruct ] = procBenchMarkSelectCandidates(benchStruct,varargin)
%PROCESSBENCHSTRUCT 

%--parameters--------------------------------------------------------------
params.default1     = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

benchConditions = benchStruct.conditions;
stageIOutput    = benchStruct.findSpotsStage1V2;
psfs            = benchStruct.psfs;
Kmatrix         = benchStruct.Kmatrix;

numConditions = numel(benchConditions);
conditions    = cell(size(benchConditions));
for ii = 1:numConditions
    display(['iteration ' num2str(ii) ' of ' num2str(numConditions)]);
    currConditions  = benchConditions{ii};
    currStageIOutputs = stageIOutput{ii};
    currFileList    = currConditions.fileList;
    currCamVarList  = currConditions.cameraVarList;
    currA           = currConditions.A;
    currB           = currConditions.B;
    currD           = currConditions.D;
    myFuncOutSave       = cell(numel(currFileList),1);
    for jj = 1:numel(currFileList)
        display(['A:' num2str(currA) ' B:' num2str(currB) ' D:' num2str(currD) ' i:' num2str(jj) ' of ' num2str(numel(currFileList))]);
        estimatedPath               = currStageIOutputs{jj};
        estimated                   = load(estimatedPath);
        %-----APPY MY FUNC-------------------------------------------------
        candidates                   = selectCandidates(estimated,varargin{:});
        %-----SAVE MY FUNC OUTPUT------------------------------------------
        myFuncOutSave{jj}           = genProcessedFileName(estimatedPath,@selectCandidates);
        makeDIRforFilename(myFuncOutSave{jj});
        parForSave(myFuncOutSave{jj},candidates);
    end
    conditions{ii}.A                     = currA;
    conditions{ii}.B                     = currB;
    conditions{ii}.D                     = currD;
    conditions{ii}.selectCandidates      = candidates;
    conditions{ii}.estimatedFiles        = estimatedPath;
end

benchStruct.findSpotsStage1V2  = conditions;
savePath = conditions{1,1}.findSpotsStage1V2{1};
savePath = grabProcessedRest(savePath);
savePath = traversePath(savePath{1},1);
saveFile = [savePath filesep 'benchStruct'];
makeDIRforFilename(saveFile);
save(saveFile,'benchStruct');
display(['saving:' saveFile]);

