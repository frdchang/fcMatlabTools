function [benchStruct] = genBenchMark(varargin)
%GENBENCHMARK will generate a battery datasets for the spot detection to do
% benchmarking on


%--parameters--------------------------------------------------------------
params.saveFolder       = '~/Desktop/dataStorage/fcDataStorage';
params.sizeData         = [29 29 13];%[21 21 9];
params.benchType        = 3; % 1 = 1 spot, 2 = 2 spots, 3= 2 spots 2 channels

params.usePSFfunc       = false;
%-----Gaussian FUNC--------------
params.psfSigmas        = {[0.9 0.9 0.9],[1.2 1.2 1.2]};
params.psfSizes         = {[21 21 21],[21 21 21]};

%-----PSF FUNC-------------------
params.psfFunc          = @genPSF;
params.binning          = 3;
params.psfFuncArgs      = {{'lambda',514e-9,'f',params.binning,'mode',0},{'lambda',610e-9,'f',params.binning,'mode',0}};
params.interpMethod     = 'linear';
params.kMatrix          = [1 0.3144; 0 1];

params.threshPSFArgs    = {[11,11,11]};
params.NoiseFunc        = @genSCMOSNoiseVar;
params.NoiseFuncArgs    = {params.sizeData,'scanType','slow'};

params.numSamples       = 10;
params.As               = linspace(0,30,11);
params.Bs               = linspace(0,24,5);
params.dist2Spots       = linspace(0,6,7);
params.dist2SpotsAtA    = [];%[3,15,27,30];
params.dist2SpotsAtB    = [];%[0,6,24,0];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);
params.NoiseFuncArgs{1} = params.sizeData;
params.centerCoor       = round(params.sizeData/2);

% generate date string
temp = datevec(date);
year = temp(1);
month = temp(2);
day = temp(3);
today = sprintf('%d%02d%02d',year,month,day);

if params.usePSFfunc
    psfs        = cellfunNonUniformOutput(@(x) params.psfFunc(x{:}),params.psfFuncArgs);
    psfs        = cellfunNonUniformOutput(@(x) centerGenPSF(x),psfs);
    psfObjs     = cellfunNonUniformOutput(@(x) myPattern_Numeric(x,'downSample',[params.binning,params.binning,params.binning],'interpMethod',params.interpMethod),psfs);
    psfs        = cellfunNonUniformOutput(@(x) x.returnShape,psfObjs);
    psfs        = cellfunNonUniformOutput(@(x) threshPSF(x,params.threshPSFArgs{:}),psfs);
else
    psfObjs     = cellfunNonUniformOutput(@(x,y) genGaussKernObj(x,y),params.psfSigmas,params.psfSizes);
    psfs        = cellfunNonUniformOutput(@(x) x.returnShape,psfObjs);
    psfs        = cellfunNonUniformOutput(@(x) threshPSF(x,params.threshPSFArgs{:}),psfs);
end


switch params.benchType
    case 1
        typeOfBenchMark = '1S1C';
        Kmatrix = 1;
        params.dist2Spots = 0;
        psfs = psfs(1);
        psfObjs = psfObjs(1);
    case 2
        typeOfBenchMark = '2S1C';
        Kmatrix = 1;
        psfs = psfs(1);
        psfObjs = psfObjs(1);
    case 3
        typeOfBenchMark = '2S2C';
        Kmatrix = params.kMatrix;
    otherwise
        error('benchType needs to be {1,2,3}');
end

if numel(Kmatrix) == 1
    kmatrixString = num2str(Kmatrix);
else
    kmatrixString = [num2str(Kmatrix(2)) ',' num2str(Kmatrix(3))];
end
folderSave = [today '-gBM-' typeOfBenchMark '-N' num2str(params.numSamples) '-sz' vector2Str(params.sizeData) '-A' num2str(min(params.As)) ',' num2str(max(params.As)) ',' num2str(numel(params.As)) '-B' num2str(min(params.Bs)) ',' num2str(max(params.Bs)) ',' num2str(numel(params.Bs)) '-D' num2str(min(params.dist2Spots)) ',' num2str(max(params.dist2Spots)) ',' num2str(numel(params.dist2Spots)) '-K' kmatrixString];

saveFolder = [params.saveFolder filesep folderSave filesep typeOfBenchMark];
[~,~,~] = mkdir(saveFolder);

centerCoor  = params.centerCoor;
domains     = genMeshFromData(zeros(params.sizeData));


benchConditions = cell(numel(params.As),numel(params.Bs),numel(params.dist2Spots));
totNum = numel(params.As)*numel(params.Bs)*numel(params.dist2Spots);
display('genBenchMark() starting...');
setupParForProgress(totNum)
parfor zz = 1:totNum
    incrementParForProgress();
    [ai,bi,di] = ind2sub([numel(params.As),numel(params.Bs),numel(params.dist2Spots)],zz);
    %     for bi = 1:numel(params.Bs)
    %         for di = 1:numel(params.dist2Spots)
    benchConditions{zz}.bigTheta = {};
    benchConditions{zz}.fileList = {};
    benchConditions{zz}.stdErrorList = {};
    benchConditions{zz}.cameraVarList = {};
    benchConditions{zz}.A = params.As(ai);
    benchConditions{zz}.B = params.Bs(bi);
    benchConditions{zz}.D = params.dist2Spots(di);
    currA = params.As(ai);
    currB = params.Bs(bi);
    currD = params.dist2Spots(di);
    
    if ~isempty(params.dist2SpotsAtA) && ~isempty(params.dist2SpotsAtB)
        idxs = arrayfun(@(A,B) find(A==currA,1) & find(B==currB,1),params.dist2SpotsAtA,params.dist2SpotsAtB,'UniformOutput',false);
        idxs = cell2mat(idxs);
        rightAandB = any(idxs);
        if ~rightAandB && ~isequal(currD,0) && numel(params.dist2Spots) ~= 1
            continue;
        end
    end
    
    if currD ~= 0 && (currB > currA)
        continue;
    end
    
    
    switch params.benchType
        case 1
            % generate a single spot
            %                     display(['genBenchMark(): A:' num2str(params.As(ai)) ' B:' num2str(params.Bs(bi))]);
            conditionStr = ['A' num2str(ai) 'B' num2str(bi)];
            spotCoors = {{[params.As(ai) centerCoor],params.Bs(bi)}};
        case 2
            % generate spots given that there is 1 channel
            %                     display(['genBenchMark(): A:' num2str(params.As(ai)) ' B:' num2str(params.Bs(bi)) ' D:' num2str(params.dist2Spots(di))]);
            conditionStr = ['A' num2str(ai) 'B' num2str(bi) 'D' num2str(di)];
            secondCoor = centerCoor+[params.dist2Spots(di) 0 0];
            spotCoors = {{[params.As(ai) centerCoor],[params.As(ai) secondCoor],params.Bs(bi)}};
            
        case 3
            % generate spots given that there is 2 channels
            %                     display(['genBenchMark(): A:' num2str(params.As(ai)) ' B:' num2str(params.Bs(bi)) ' D:' num2str(params.dist2Spots(di))]);
            conditionStr = ['A' num2str(ai) 'B' num2str(bi) 'D' num2str(di)];
            secondCoor = centerCoor+[params.dist2Spots(di) 0 0];
            spotCoors = {{[params.As(ai) centerCoor],params.Bs(bi)},{[params.As(ai) secondCoor],params.Bs(bi)}};
    end
    
    bigTheta    = genBigTheta(Kmatrix,psfObjs,spotCoors);
    [bigLambdas,bigDLambdas,~]  = bigLambda(domains,bigTheta,'objKerns',psfObjs);
    
    fileList        = cell(params.numSamples,1);
    stdErrorList    = cell(params.numSamples,1);
    cameraVarList   = cell(params.numSamples,1);
    for ii = 1:params.numSamples
        cameraVar          = params.NoiseFunc(params.NoiseFuncArgs{:});
        [sampledData,~,cameraParams]  = genMicroscopeNoise(bigLambdas,'readNoiseData',cameraVar);
        saveFileVar = [saveFolder filesep conditionStr filesep 'cameraVar' filesep 'cameraVar-' conditionStr '-' num2str(ii)];
        makeDIRforFilename(saveFileVar);
        saveCameraVar(saveFileVar,cameraParams);
        cameraVarList{ii} = saveFileVar;
        if iscell(sampledData)
            saveFile = cell(numel(sampledData),1);
            for jj = 1:numel(sampledData)
                saveFile{jj} = [saveFolder filesep conditionStr filesep 'channel' num2str(jj) '-' conditionStr '-' num2str(ii) '.tif'];
                exportSingleTifStack(saveFile{jj},sampledData{jj});
            end
        else
            saveFile = [saveFolder filesep conditionStr filesep conditionStr '-' num2str(ii) '.tif'];
            exportSingleTifStack(saveFile,round(sampledData));
        end
        
        [ carvedMask,stats ] = createMaskHelper( bigLambdas,getPatchSize(psfs{1}),bigTheta);
%         carvedMask                  = carveOutWithMask(currMask,currMask,[0,0,0]);
        
        % use only carved mask
        bigLambdasC = cellfunNonUniformOutput(@(x) x(carvedMask),bigLambdas);
        bigDLambdasC = bigDLambdas;
        for kk = 1:numel(bigDLambdas)
            if ~isscalar(bigDLambdas{kk})
                bigDLambdasC{kk} = bigDLambdas{kk}(carvedMask);
            end
        end
        
        if iscell(bigLambdas)
            myVar = cell(size(bigLambdas));
            [myVar{:}] = deal(cameraVar);
            myVar = cellfunNonUniformOutput(@(x) x(carvedMask),myVar);
            
            [ ~,~,stdErrors,~] = calcExpectedFisherInfo(bigLambdasC,bigDLambdasC,myVar);
            
        else
            cameraVar = cameraVar(carvedMask);
            [ ~,~,stdErrors,~] = calcExpectedFisherInfo(bigLambdasC,bigDLambdasC,cameraVar);
            
        end
        
        fileList{ii} = saveFile;
        stdErrorList{ii} = stdErrors;
    end
    benchConditions{zz}.bigTheta = bigTheta;
    benchConditions{zz}.fileList = fileList;
    benchConditions{zz}.stdErrorList = stdErrorList;
    benchConditions{zz}.cameraVarList = cameraVarList;
end
display('genBenchMark() done...');
benchStruct.psfObjs     = psfObjs;
benchStruct.Kmatrix     = Kmatrix;
benchStruct.conditions  = benchConditions;
benchStruct.psfs        = psfs;
benchStruct.centerCoor  = centerCoor;
save([saveFolder filesep 'benchStruct'],'benchStruct','-v7.3');
display('genBenchmark() saved...');
