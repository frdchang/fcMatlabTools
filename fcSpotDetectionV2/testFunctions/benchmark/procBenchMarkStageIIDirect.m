function [ benchStruct ] = procBenchMarkStageIIDirect(benchStruct,varargin)
%PROCBENCHMARKSTAGEII
%--parameters--------------------------------------------------------------
params.doN          = inf;
params.doPlotEveryN = inf;
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
sizeKern        = size(psfs{1});
stageIConds     = benchStruct.findSpotsStage1V2;
benchCC         = benchStruct.conditions;

numConditions = numel(stageIConds);
conditions    = cell(size(stageIConds));

parfor ii = 1:numConditions
    display(['iteration ' num2str(ii) ' of ' num2str(numConditions)]);
    currStageI      = stageIConds{ii};
    thetaTrue       = benchCC{ii}.bigTheta;
    % generate sequence of thetas from thetaTrue and num spots to fit
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
    for jj = 1:doNum
        display(['A:' num2str(currA) ' B:' num2str(currB) ' D:' num2str(currD) ' i:' num2str(jj) ' of ' num2str(doNum)]);
        stack                       = importStack(currFileList{jj});
        camVar                      = load(currCamVarList{jj});
        cameraVarianceInElectrons   = camVar.cameraParams.cameraVarianceInADU.*(camVar.cameraParams.gainElectronPerCount.^2);
        [~,photonData]              = returnElectrons(stack,camVar.cameraParams);
        estimated                   = load(currStageIFiles{jj});
        estimated                   = estimated.x;
        % define candidates
        L = zeros(size(stack{1}));
        cellCoor = num2cell(trueCoor);
        L(cellCoor{:}) = 1;
        L = imdilate(L,strel(ones(sizeKern(:)')));
%
%         L = bwlabeln(L>0);
%         stats = regionprops(L,'PixelList','SubarrayIdx','PixelIdxList');
%         candidates.L        = L;
%         % candidates.BWmask   = BWmask;
%         candidates.stats    = stats;
        domains = genMeshFromData(photonData{1});
        if ~iscell(cameraVarianceInElectrons)
            camVars = cell(numel(electrons),1);
            [camVars{:}] = deal(cameraVarianceInElectrons);
        end
        %-----APPY MY FUNC-------------------------------------------------
%           MLEs{jj} = MLEbyIterationV2(psfObjs,estimated.A1,L>0,photonData,theta0,camVars,domains,{{maxThetaInputs,20},{newtonBuild,20}},'doPloteveryN',inf);
          MLEs{jj} = doMultiEmitterFitting(carvedMask,maskedPixelId,datas,estimated,camVar,Kmatrix,objKerns,'theta0',myTheta0s,'numSpots',numSpots,'doPlotEveryN',params.doPlotEveryN);
        %-----SAVE MY FUNC OUTPUT------------------------------------------
        myFuncOutSave{jj}           = genProcessedFileName(currStageIFiles{jj},@MLEbyIterationV2);
        makeDIRforFilename(myFuncOutSave{jj});
        parForSave(myFuncOutSave{jj},MLEs{jj});

    end
    conditions{ii}.A                     = currA;
    conditions{ii}.B                     = currB;
    conditions{ii}.D                     = currD;
    conditions{ii}.MLEs                  = MLEs;
    conditions{ii}.bigTheta              = thetaTrue;
end

benchStruct.MLEbyIterationV2  = conditions;
savePath = genProcessedFileName(stageIConds{1}.findSpotsStage1V2{1},@findSpotsStage2V2);
savePath = grabProcessedRest(savePath);
savePath = traversePath(savePath{1},1);
saveFile = [savePath filesep 'benchStruct'];
makeDIRforFilename(saveFile);
save(saveFile,'benchStruct');
display(['saving:' saveFile]);








