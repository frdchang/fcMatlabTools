function [ benchStruct ] = procBenchMarkStageI(benchStruct,varargin)
%PROCESSBENCHSTRUCT 

%--parameters--------------------------------------------------------------
params.default1     = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

benchConditions = benchStruct.conditions;
psfs            = benchStruct.psfs;
Kmatrix         = benchStruct.Kmatrix;

numConditions = numel(benchConditions);
conditions    = cell(size(benchConditions));
parfor ii = 1:numConditions
    display(['iteration ' num2str(ii) ' of ' num2str(numConditions)]);
    currConditions  = benchConditions{ii};
    currFileList    = currConditions.fileList;
    currCamVarList  = currConditions.cameraVarList;
    currA           = currConditions.A;
    currB           = currConditions.B;
    currD           = currConditions.D;
    myFuncOutSave       = cell(numel(currFileList),1);
    for jj = 1:numel(currFileList)
        display(['A:' num2str(currA) ' B:' num2str(currB) ' D:' num2str(currD) ' i:' num2str(jj) ' of ' num2str(numel(currFileList))]);
        stack                       = importStack(currFileList{jj});
        camVar                      = load(currCamVarList{jj});
        cameraVarianceInElectrons   = camVar.cameraParams.cameraVarianceInADU.*(camVar.cameraParams.gainElectronPerCount.^2);
        electrons                   = returnElectrons(stack,camVar.cameraParams);
        %-----APPY MY FUNC-------------------------------------------------
        estimated                   = findSpotsStage1V2(electrons,psfs,cameraVarianceInElectrons,'kMatrix',Kmatrix);
        %-----SAVE MY FUNC OUTPUT------------------------------------------
        myFuncOutSave{jj}           = genProcessedFileName(currFileList{jj},@findSpotsStage1V2);
        makeDIRforFilename(myFuncOutSave{jj});
        parForSave(myFuncOutSave{jj},estimated);
    end
    conditions{ii}.A                     = currA;
    conditions{ii}.B                     = currB;
    conditions{ii}.D                     = currD;
    conditions{ii}.findSpotsStage1V2     = myFuncOutSave;
    conditions{ii}.dataFiles             = currFileList;
    conditions{ii}.camVarFile            = currCamVarList;
end

benchStruct.findSpotsStage1V2  = conditions;
savePath = conditions{1,1}.findSpotsStage1V2{1};
savePath = grabProcessedRest(savePath);
savePath = traversePath(savePath{1},1);
saveFile = [savePath filesep 'benchStruct'];
makeDIRforFilename(saveFile);
save(saveFile,'benchStruct');
display(['saving:' saveFile]);

