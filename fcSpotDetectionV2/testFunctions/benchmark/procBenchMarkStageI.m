function [ benchStruct ] = procBenchMarkStageI(benchStruct,myFunc,varargin)
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
disp('procBenchMarkStageI() starting...');
setupParForProgress(numConditions);
parfor ii = 1:numConditions
    incrementParForProgress();
%     display(['iteration ' num2str(ii) ' of ' num2str(numConditions)]);
    currConditions  = benchConditions{ii};
    currFileList    = currConditions.fileList;
    currCamVarList  = currConditions.cameraVarList;
    currA           = currConditions.A;
    currB           = currConditions.B;
    currD           = currConditions.D;
    myFuncOutSave       = cell(numel(currFileList),1);
    for jj = 1:numel(currFileList)
%         display(['procBenchMarkStageI() A:' num2str(currA) ' B:' num2str(currB) ' D:' num2str(currD) ' i:' num2str(jj) ' of ' num2str(numel(currFileList))]);
        stack                       = importStack(currFileList{jj});
        camVar                      = load(currCamVarList{jj});
        cameraVarianceInElectrons   = camVar.cameraParams.cameraVarianceInADU.*(camVar.cameraParams.gainElectronPerCount.^2);
        electrons                   = returnElectrons(stack,camVar.cameraParams);
        %-----APPY MY FUNC-------------------------------------------------
        estimated                   = myFunc(electrons,psfs,cameraVarianceInElectrons,'kMatrix',Kmatrix);
        %-----SAVE MY FUNC OUTPUT------------------------------------------
        myFuncOutSave{jj}           = genProcessedFileName(currFileList{jj},myFunc);
        makeDIRforFilename(myFuncOutSave{jj});
        parForSave(myFuncOutSave{jj},estimated);
    end
    conditions{ii}.A                     = currA;
    conditions{ii}.B                     = currB;
    conditions{ii}.D                     = currD;
    conditions{ii}.(func2str(myFunc))     = myFuncOutSave;
    conditions{ii}.dataFiles             = currFileList;
    conditions{ii}.camVarFile            = currCamVarList;
end
disp('procBenchMarkStageI() finished...');

benchStruct.(func2str(myFunc))  = conditions;
savePath = conditions{1,1}.(func2str(myFunc)){1};
savePath = grabProcessedRest(savePath);
savePath = traversePath(savePath{1},1);
saveFile = [savePath filesep 'benchStruct'];
makeDIRforFilename(saveFile);
save(saveFile,'benchStruct');
disp(['saving:' saveFile]);
disp('procBenchMarkStageI() saved...');

