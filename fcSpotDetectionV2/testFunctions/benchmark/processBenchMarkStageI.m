function processStruct = processBenchMarkStageI(benchStruct,myFunc,varargin)
%PROCESSBENCHMARK will process benchmark with myFunc that is a filter, ie.
% stageI
% 
% myFunc takes in data_i and cameraVar_i and then outputs_i

%--parameters--------------------------------------------------------------
params.default1     = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

conditions  = benchStruct.conditions;
sizeBench   = size(conditions);
psfs        = benchStruct.psfs;
trueCoor    = benchStruct.centerCoor;
psfSize     = size(psfs{1});

conditions = cell(sizeBench(1),sizeBench(2));
for ai = 1:sizeBench(1)
    for bi = 1:sizeBench(2)
        currConditions = conditions{ai,bi};
        currFileList   = currConditions.fileList;
        currCamVarList = currConditions.cameraVarList;
        currA          = currConditions.A;
        currB          = currConditions.B;
        signalBasket = cell(numel(currFileList),1);
        bkgndBasket  = cell(numel(currFileList,1));
        for ii = 1:numel(currFileList)
           stack            = importStack(currFileList{ii});
           camVar           = importStack(currCamVarList{ii});
           estimated        = myFunc(stack,psfs{1},camVar);
           % save outputStruct
           saveOutputFile   = genProcessedFileName(currFileList,myFunc);
           save(saveOutputFile,'estimated');
           [signal,bkgnd]   = structfun(@(x) measureSigBkgnd(x,trueCoor,psfSize),estimated,'UniformOuput',false);
           signalBasket{ii} = signal;
           bkgndBasket{ii}  = bkgnd;
        end
        conditions{ai,bi}.signals = signalBasket;
        conditions{ai,bi}.bkgnds = bkgndBasket;
        conditions{ai,bi}.A = currA;
        conditions{ai,bi}.B = currB;
    end
end


