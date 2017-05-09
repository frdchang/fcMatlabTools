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
conditions = cell(sizeBench(1),sizeBench(2),sizeBench(3));
for ai = 1:sizeBench(1)
    for bi = 1:sizeBench(2)
        for di = 1:sizeBench(3)
            currConditions  = benchStruct.conditions{ai,bi,di};
            currFileList    = currConditions.fileList;
            currCamVarList  = currConditions.cameraVarList;
            currA           = currConditions.A;
            currB           = currConditions.B;
            sigLL    = zeros(numel(currFileList),1);
            bkLL     = cell(numel(currFileList),1);
            sigA1    = zeros(numel(currFileList),1);
            bkA1     = cell(numel(currFileList),1);
            for ii = 1:numel(currFileList)
                display(['A:' num2str(currA) ' B:' num2str(currB) ' i:' num2str(ii) ' of ' num2str(numel(currFileList))]);
                stack            = importStack(currFileList{ii});
                camVar           = load(currCamVarList{ii});
                cameraVarianceInElectrons = camVar.cameraParams.cameraVarianceInADU.*(camVar.cameraParams.gainElectronPerCount.^2);
                electrons = returnElectrons(stack,camVar.cameraParams);
                estimated        = myFunc(electrons,psfs,cameraVarianceInElectrons,'kMatrix',Kmatrix);
                % save outputStruct
                saveEstimatedStruct   = genProcessedFileName(currFileList{ii},myFunc);
                makeDIRforFilename(saveEstimatedStruct);
                parForSave(saveEstimatedStruct,estimated);
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
        end
        conditions{ai,bi,di}.sigLL     = sigLL;
        conditions{ai,bi,di}.bkLL      = cell2mat(bkLL);
        conditions{ai,bi,di}.sigA1     = sigA1;
        conditions{ai,bi,di}.bkA1      = cell2mat(bkA1);
        conditions{ai,bi,di}.A         = currA;
        conditions{ai,bi,di}.B         = currB;
        conditions{ai,bi,di}.saveEstimatedStruct   = saveEstimatedStruct;
        conditions{ai,bi,di}.dataFiles             = currFileList{ii};
        conditions{ai,bi,di}.camVarFile            = currCamVarList{ii};
    end
end


processStruct.conditions = conditions;
savePath = conditions{1,1}.saveEstimatedStruct;
savePath = grabProcessedRest(savePath);
savePath = traversePath(savePath{1},1);
saveFile = [savePath filesep 'processStruct'];
save(saveFile,'processStruct');
display(['saving:' saveFile]);