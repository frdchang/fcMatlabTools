function stageIIOutputs = stageIIhelper(currStageI,thetaTrue,params,sizeKern,Kmatrix,psfObjs)
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
    return;
end
parfor jj = 1:doNum
    %         display(['A:' num2str(currA) ' B:' num2str(currB) ' D:' num2str(currD) ' i:' num2str(jj) ' of ' num2str(doNum)]);
    stack                       = importStack(currFileList{jj});
    camVar                      = load(currCamVarList{jj});
    cameraVarianceInElectrons   = camVar.cameraParams.cameraVarianceInADU.*(camVar.cameraParams.gainElectronPerCount.^2);
    [~,photonData]              = returnElectrons(stack,camVar.cameraParams);
    estimated                   = load(currStageIFiles{jj});
    estimated                   = estimated.x;
    myTheta0s                   = genSequenceOfThetas(thetaTrue,estimated);
    
    % define candidates
    L = zeros(size(stack{1}));
    spotCoors = getSpotCoorsFromTheta(thetaTrue);
    for zz = 1:numel(spotCoors)
        cellCoor = num2cell(spotCoors{zz});
        L(cellCoor{:}) = 1;
    end
    
    
    L = imdilate(L,strel(ones(sizeKern(:)')));
    L = bwlabeln(L>0);
    stats = regionprops(L,'PixelList','SubarrayIdx','PixelIdxList');
    
    currMask = L == 1;
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
stageIIOutputs.currA = currA;
stageIIOutputs.currB = currB;
stageIIOutputs.currD = currD;
stageIIOutputs.MLEs = MLEs;
stageIIOutputs.myFuncOutSave = myFuncOutSave;

end
