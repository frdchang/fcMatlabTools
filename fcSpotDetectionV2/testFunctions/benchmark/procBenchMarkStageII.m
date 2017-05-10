function [ benchStruct ] = procBenchMarkStageII( benchStruct,varargin)
%PROCBENCHMARKSTAGEII
%--parameters--------------------------------------------------------------
params.default1     = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% check if findSpotsStage1 has been done
if ~isfield(benchStruct,'findSpotsStage1V2')
    error('NEED TO RUN STAGE 1 first');
end

psfObjs         = benchStruct.psfObjs;
psfs            = benchStruct.psfs;
Kmatrix         = benchStruct.Kmatrix;
stageIConds     = benchStruct.findSpotsStage1V2;
trueCoor        = benchStruct.centerCoor;
benchCC         = benchStruct.conditions;
numConditions = numel(stageIConds);
conditions    = cell(size(stageIConds));
for ii = 1:numConditions
    display(['iteration ' num2str(ii) ' of ' num2str(numConditions)]);
    currStageI      = stageIConds{ii};
    conditionsbench     = benchCC{ii};
    currStageIFiles = currStageI.findSpotsStage1V2;
    currFileList    = currStageI.dataFiles;
    currCamVarList  = currStageI.camVarFile;
    currA           = currStageI.A;
    currB           = currStageI.B;
    currD           = currStageI.D;
    myFuncOutSave   = cell(numel(currFileList),1);
    if currA == 0 
        continue;
    end
    for jj = 1:numel(currFileList)
        display(['A:' num2str(currA) ' B:' num2str(currB) ' D:' num2str(currD) ' i:' num2str(jj) ' of ' num2str(numel(currFileList))]);
        stack                       = importStack(currFileList{jj});
        camVar                      = load(currCamVarList{jj});
        cameraVarianceInElectrons   = camVar.cameraParams.cameraVarianceInADU.*(camVar.cameraParams.gainElectronPerCount.^2);
        [~,electrons]                  = returnElectrons(stack,camVar.cameraParams);
        estimated                   = load(currStageIFiles{jj});
        estimated                   = estimated.x;
        % define candidates
        L = zeros(size(stack{1}));
        cellCoor = num2cell(trueCoor);
        L(cellCoor{:}) = 1;
        sizeKern = size(psfs{1});
        L = imdilate(L,strel(ones(sizeKern(:)')));
        L = bwlabeln(L>0);
        stats = regionprops(L,'PixelList','SubarrayIdx','PixelIdxList');
        candidates.L        = L;
        % candidates.BWmask   = BWmask;
        candidates.stats    = stats;
        domains = genMeshFromData(electrons{1});
        theta0 = conditionsbench.bigTheta;
        maxThetaInputs = cellfunNonUniformOutput(@(x) hybridAllThetas(x),theta0);
        newtonBuild    = newtonRaphsonBuild(maxThetaInputs);
        if ~iscell(cameraVarianceInElectrons)
            camVars = cell(numel(electrons),1);
            [camVars{:}] = deal(cameraVarianceInElectrons);
        end
        %-----APPY MY FUNC-------------------------------------------------
        state = MLEbyIterationV2(psfObjs,estimated.A1,candidates.L>0,electrons,theta0,camVars,domains,{{maxThetaInputs,1},{newtonBuild,20}},'doPloteveryN',inf);
        %-----SAVE MY FUNC OUTPUT------------------------------------------
        myFuncOutSave{jj}           = genProcessedFileName(currStageIFiles{jj},@MLEbyIterationV2);
        makeDIRforFilename(myFuncOutSave{jj});
        parForSave(myFuncOutSave{jj},state);
    end
    conditions{ii}.A                     = currA;
    conditions{ii}.B                     = currB;
    conditions{ii}.D                     = currD;
    conditions{ii}.MLEbyIterationV2      = myFuncOutSave;
    conditions{ii}.bigTheta              = theta0;
end

benchStruct.MLEbyIterationV2  = conditions;
savePath = conditions{end}.MLEbyIterationV2{1};
savePath = grabProcessedRest(savePath);
savePath = traversePath(savePath{1},1);
saveFile = [savePath filesep 'benchStruct'];
makeDIRforFilename(saveFile);
save(saveFile,'benchStruct');
display(['saving:' saveFile]);



