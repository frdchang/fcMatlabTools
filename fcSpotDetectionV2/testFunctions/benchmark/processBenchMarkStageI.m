function processStruct = processBenchMarkStageI(benchStruct,myFunc,varargin)
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
conditions = cell(sizeBench(1),sizeBench(2));
for ai = 1:sizeBench(1)
    for bi = 1:sizeBench(2)
        currConditions  = benchStruct.conditions{ai,bi};
        currFileList    = currConditions.fileList;
        currCamVarList  = currConditions.cameraVarList;
        currA           = currConditions.A;
        currB           = currConditions.B;
        sigLL    = zeros(numel(currFileList),1);
        bkLL     = cell(numel(currFileList),1);
        sigA1    = zeros(numel(currFileList),1);
        bkA1     = cell(numel(currFileList),1);
        for ii = 1:numel(currFileList)
           stack            = importStack(currFileList{ii});
           camVar           = load(currCamVarList{ii});
           cameraVarianceInElectrons = camVar.cameraParams.cameraVarianceInADU.*(camVar.cameraParams.gainElectronPerCount.^2);
           electrons = returnElectrons(stack,camVar.cameraParams);
           estimated        = myFunc(electrons,psfs,cameraVarianceInElectrons,'kMatrix',Kmatrix);
           % save outputStruct
           saveEstimatedStruct   = genProcessedFileName(currFileList{ii},myFunc);
           makeDIRforFilename(saveEstimatedStruct);
           save(saveEstimatedStruct,'estimated');
           % measure from LLRatio, A1 or output
           LLRatio = estimated.LLRatio;
           A1      = estimated.A1;
           if iscell(A1)
               A1 = A1{1};    
           end
           [LLSig,LLBK] = measureSigBkgnd(LLRatio,trueCoor,psfSize);
           [A1Sig,A1BK] = measureSigBkgnd(A1,trueCoor,psfSize);
           sigLL(ii)    = LLSig;
           bkLL{ii}     = LLBK;
           sigA1(ii)    = A1Sig;
           bkA1{ii}     = A1BK;
        end
        conditions{ai,bi}.sigLL     = sigLL;
        conditions{ai,bi}.bkLL      = cell2mat(bkLL);
        conditions{ai,bi}.sigA1     = sigA1;
        conditions{ai,bi}.bkA1      = cell2mat(bkA1);
        conditions{ai,bi}.A         = currA;
        conditions{ai,bi}.B         = currB;
        conditions{ai,bi}.saveEstimatedStruct   = saveEstimatedStruct;
        conditions{ai,bi}.dataFiles             = currFileList{ii};
        conditions{ai,bi}.camVarFile            = currCamVarList{ii};
    end
end

processStruct.conditions = conditions;

