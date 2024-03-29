function [ benchStruct ] = procBenchMarkStageIIDirect(benchStruct,varargin)
%PROCBENCHMARKSTAGEII
%--parameters--------------------------------------------------------------
params.doN          = inf;
params.doPlotEveryN = inf;
params.DLLDLambda  = @DLLDLambda_PoissPoiss;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% check if findSpotsStage1 has been done
if ~isfield(benchStruct,'findSpotsStage1V2')
    error('NEED TO RUN STAGE 1 first');
end

% if ~isfield(benchStruct,'selectCandidates')
%     error('NEED TO RUN select Candidates first');
% end

psfObjs         = benchStruct.psfObjs;
psfs            = benchStruct.psfs;
Kmatrix         = benchStruct.Kmatrix;
trueCoor        = benchStruct.centerCoor;
sizeKern        = getPatchSize(psfs{1});
stageIConds     = benchStruct.findSpotsStage1V2;
benchCC         = benchStruct.conditions;

numConditions = numel(stageIConds);
conditions    = cell(size(stageIConds));
display('procBenchMarkStageIIDirect() starting...');
setupParForProgress(numConditions);
parfor ii = 1:numConditions
    incrementParForProgress();
%     display(['iteration ' num2str(ii) ' of ' num2str(numConditions)]);
    currStageI      = stageIConds{ii};
    thetaTrue       = benchCC{ii}.bigTheta;
    % generate sequence of thetas from thetaTrue and num spots to fit
    numSpots        = numSpotsInTheta(thetaTrue);
    % get stage I stuff
    currStageIFiles = currStageI.findSpotsStage1V2;
    currFileList    = currStageI.dataFiles;
    currCamVarList  = currStageI.camVarFile;
    currA           = currStageI.A;
    currB           = currStageI.B;
    currD           = currStageI.D;
    % get select candidates stuff
    %     currSelectFiles = selectConds{ii}.selectCandidatesFile;
    doNum = min(params.doN,numel(currFileList));
    myFuncOutSave   = cell(doNum,1);
    MLEs            = cell(doNum,1);
    if currA == 0
        continue;
    end
    currMask = [];
    for jj = 1:doNum
%         display(['A:' num2str(currA) ' B:' num2str(currB) ' D:' num2str(currD) ' i:' num2str(jj) ' of ' num2str(doNum)]);
        stack                       = importStack(currFileList{jj});
        camVar                      = load(currCamVarList{jj});
        cameraVarianceInElectrons   = camVar.cameraParams.cameraVarianceInADU.*(camVar.cameraParams.gainElectronPerCount.^2);
        [~,photonData]              = returnElectrons(stack,camVar.cameraParams);
        estimated                   = load(currStageIFiles{jj});
        estimated                   = estimated.x;
        myTheta0s                   = genSequenceOfThetas(thetaTrue,estimated);
        
       [ currMask,stats ] = createMaskHelper( stack,sizeKern,thetaTrue);
      
        carvedDatas                 = carveOutWithMask(photonData,currMask,[0,0,0]);
        carvedEstimates             = carveOutWithMask(estimated,currMask,[0,0,0],'spotKern','convFunc');
        carvedCamVar                = carveOutWithMask(cameraVarianceInElectrons,currMask,[0,0,0]);
        carvedMask                  = carveOutWithMask(currMask,currMask,[0,0,0]);
        carvedRectSubArrayIdx       = stats(1).SubarrayIdx;
        carvedEstimates.spotKern    = estimated.spotKern;
        %-----APPY MY FUNC-------------------------------------------------
        MLEs{jj}{1}                 = doMultiEmitterFitting(carvedMask,carvedRectSubArrayIdx,carvedDatas,carvedEstimates,carvedCamVar,Kmatrix,psfObjs,'theta0',myTheta0s,'numSpots',numSpots,'doPlotEveryN',params.doPlotEveryN,'DLLDLambda',params.DLLDLambda);
        %-----SAVE MY FUNC OUTPUT------------------------------------------
        myFuncOutSave{jj}           = genProcessedFileName(currStageIFiles{jj},@directFitting);
        makeDIRforFilename(myFuncOutSave{jj});
        parForSave(myFuncOutSave{jj},MLEs{jj});
        
    end
    conditions{ii}.currMask         = currMask;
    conditions{ii}.A                = currA;
    conditions{ii}.B                = currB;
    conditions{ii}.D                = currD;
    conditions{ii}.MLEsByDirect     = MLEs;
    conditions{ii}.bigTheta         = thetaTrue;
    conditions{ii}.saveFiles        = myFuncOutSave;
end
display('procBenchMarkStageIIDirect() finished...');

benchStruct.directFitting  = conditions;
savePath = genProcessedFileName(stageIConds{1}.findSpotsStage1V2{1},@directFitting);
savePath = grabProcessedRest(savePath);
savePath = traversePath(savePath{1},1);
saveFile = [savePath filesep 'benchStruct'];
makeDIRforFilename(saveFile);
save(saveFile,'benchStruct','-v7.3');
display(['saving:' saveFile]);
display('procBenchMarkStageIIDirect() saved...');








