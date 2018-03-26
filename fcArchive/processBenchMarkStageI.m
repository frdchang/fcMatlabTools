function benchStruct = processBenchMarkStageI(benchStruct,myFunc,varargin)
%PROCESSBENCHMARK will process benchmark with myFunc that is a filter, ie.
% stageI
%
% myFunc takes stack,psfs,cameraVarianceInElectrons,'kMatrix',Kmatrix

%--parameters--------------------------------------------------------------
params.default1     = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

conditions  = benchStruct.conditions;
sizeBench   = size(conditions);
psfs        = benchStruct.psfs;
trueCoor    = benchStruct.centerCoor;
psfSize     = size(psfs{1});
Kmatrix     = benchStruct.Kmatrix;

benchConditions = benchStruct.conditions;
switch ndims(benchConditions)
    case 2
        idx = find(ones(size(benchConditions)));
    case 3
        benchConditions = benchConditions(:,:,1);
        idx = find(ones(size(benchConditions)));
    otherwise
        error('bench conditions dimensions not 2 or 3');
end
numConditions = numel(idx);
conditions = cell(size(benchConditions,1),size(benchConditions,2));
parfor ii = 1:numConditions
    display(['iteration ' num2str(ii) ' of ' num2str(numConditions)]);
    currConditions  = benchConditions{ii};
    currFileList    = currConditions.fileList;
    currCamVarList  = currConditions.cameraVarList;
    currA           = currConditions.A;
    currB           = currConditions.B;
    currD           = currConditions.D;
    sigLL           = zeros(numel(currFileList),1);
    bkLL            = cell(numel(currFileList),1);
    sigA1           = zeros(numel(currFileList),1);
    bkA1            = cell(numel(currFileList),1);
    saveEstimatedStruct = cell(numel(currFileList),1);
    for jj = 1:numel(currFileList)
        display(['A:' num2str(currA) ' B:' num2str(currB) ' D:' num2str(currD) ' i:' num2str(jj) ' of ' num2str(numel(currFileList))]);
        stack                       = importStack(currFileList{jj});
        camVar                      = load(currCamVarList{jj});
        cameraVarianceInElectrons   = camVar.cameraParams.cameraVarianceInADU.*(camVar.cameraParams.gainElectronPerCount.^2);
        electrons                   = returnElectrons(stack,camVar.cameraParams);
        estimated                   = myFunc(electrons,psfs,cameraVarianceInElectrons,'kMatrix',Kmatrix);
        % save outputStruct
        saveEstimatedStruct{jj}     = genProcessedFileName(currFileList{jj},myFunc);
        makeDIRforFilename(saveEstimatedStruct{jj});
        parForSave(saveEstimatedStruct{jj},estimated);
        % measure from LLRatio, A1 or output
        LLRatio     = estimated.LLRatio;
        A1          = estimated.A1;
        if iscell(A1)
            A1 = A1{1};
        end
        [LLSig,LLBK] = measureSigBkgnd(LLRatio,trueCoor,psfSize);
        [A1Sig,A1BK] = measureSigBkgnd(A1,trueCoor,psfSize);
        sigLL(jj)    = LLSig;
        bkLL{jj}     = LLBK;
        sigA1(jj)    = A1Sig;
        bkA1{jj}     = A1BK;
    end
    
    conditions{ii}.sigLL                 = sigLL;
    conditions{ii}.bkLL                  = cell2mat(bkLL);
    conditions{ii}.sigA1                 = sigA1;
    conditions{ii}.bkA1                  = cell2mat(bkA1);
    conditions{ii}.A                     = currA;
    conditions{ii}.B                     = currB;
    conditions{ii}.D                     = currD;
    conditions{ii}.saveEstimatedStruct   = saveEstimatedStruct;
    conditions{ii}.dataFiles             = currFileList;
    conditions{ii}.camVarFile            = currCamVarList;
end

benchStruct.stageIconditions = conditions;
savePath = conditions{1,1}.saveEstimatedStruct{1};
savePath = grabProcessedRest(savePath);
savePath = traversePath(savePath{1},1);
saveFile = [savePath filesep 'benchStruct'];
makeDIRforFilename(saveFile);
save(saveFile,'benchStruct');
display(['saving:' saveFile]);