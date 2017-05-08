function [benchStruct] = genBenchMark(varargin)
%GENBENCHMARK will generate a battery datasets for the spot detection to do
% benchmarking on


%--parameters--------------------------------------------------------------
params.saveFolder       = '~/Desktop/dataStorage/fcDataStorage';
params.sizeData         = [21 21 9];
params.benchType        = 3; % 1 = 1 spot, 2 = 2 spots, 3= 2 spots 2 channels

params.psfFunc          = @genPSF;
params.psfFuncArgs      = {{'lambda',514e-9},{'lambda',610e-9}};
params.threshPSFArgs    = {[11,11,11]};
params.NoiseFunc        = @genSCMOSNoiseVar;
params.NoiseFuncArgs    = {params.sizeData,'scanType','slow'};

params.numSamples       = 10;
params.As               = linspace(0,20,5);
params.Bs               = linspace(0,20,5);
params.dist2Spots       = linspace(0,10,2);
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% generate date string
temp = datevec(date);
year = temp(1);
month = temp(2);
day = temp(3);
today = sprintf('%d%02d%02d',year,month,day);
psfs        = cellfunNonUniformOutput(@(x) params.psfFunc(x{:}),params.psfFuncArgs);
psfs        = cellfunNonUniformOutput(@(x) threshPSF(x,params.threshPSFArgs{:}),psfs);
psfObjs     = cellfunNonUniformOutput(@(x) myPattern_Numeric(x),psfs);

switch params.benchType
    case 1
        typeOfBenchMark = '1spot1Channel';
        Kmatrix = 1;
        params.dist2Spots = 0;
        psfs = psfs(1);
        psfObjs = psfObjs(1);
    case 2
        typeOfBenchMark = '2spot1Channel';
        Kmatrix = 1;
        psfs = psfs(1);
        psfObjs = psfObjs(1);
    case 3
        typeOfBenchMark = '2spot2Channel';
        Kmatrix = [1 0.2; 0.2 1];
    otherwise
        error('benchType needs to be {1,2,3}');
end

saveFolder = [params.saveFolder filesep today filesep 'genBenchMark' filesep typeOfBenchMark];
[~,~,~] = mkdir(saveFolder);

centerCoor  = getCenterCoor(params.sizeData);
domains     = genMeshFromData(zeros(params.sizeData));


benchConditions = cell(numel(params.As),numel(params.Bs),numel(params.dist2Spots));
for ai = 1:numel(params.As)
    for bi = 1:numel(params.Bs)
        for di = 1:numel(params.dist2Spots)
            
            switch params.benchType
                case 1
                    % generate a single spot
                    display(['genBenchMark(): A:' num2str(params.As(ai)) ' B:' num2str(params.Bs(bi))]);
                    conditionStr = ['A' num2str(ai) 'B' num2str(bi)];
                    spotCoors = {{[params.As(ai) centerCoor],params.Bs(bi)}};
                case 2
                    % generate spots given that there is 1 channel
                    display(['genBenchMark(): A:' num2str(params.As(ai)) ' B:' num2str(params.Bs(bi)) ' D:' num2str(params.dist2Spots(di))]);
                    conditionStr = ['A' num2str(ai) 'B' num2str(bi) 'D' num2str(di)];
                    secondCoor = centerCoor+[params.dist2Spots(di) 0 0];
                    spotCoors = {{[params.As(ai) centerCoor],[params.As(ai) secondCoor],params.Bs(bi)}};
                    
                case 3
                    % generate spots given that there is 2 channels
                    display(['genBenchMark(): A:' num2str(params.As(ai)) ' B:' num2str(params.Bs(bi)) ' D:' num2str(params.dist2Spots(di))]);
                    conditionStr = ['A' num2str(ai) 'B' num2str(bi) 'D' num2str(di)];
                    secondCoor = centerCoor+[params.dist2Spots(di) 0 0];
                    spotCoors = {{[params.As(ai) centerCoor],params.Bs(bi)},{[params.As(ai) secondCoor],params.Bs(bi)}};
            end
            
            bigTheta    = genBigTheta(Kmatrix,psfs,spotCoors);
            bigLambdas  = bigLambda(domains,bigTheta,'objKerns',psfObjs);
            fileList        = cell(params.numSamples,1);
            cameraVarList   = cell(params.numSamples,1);
            for ii = 1:params.numSamples
                cameraVar          = params.NoiseFunc(params.NoiseFuncArgs{:});
                [sampledData,~,cameraParams]  = genMicroscopeNoise(bigLambdas,'readNoiseData',cameraVar);
                saveFileVar = [saveFolder filesep conditionStr filesep 'cameraVar' filesep 'cameraVar-' conditionStr '-' num2str(ii)];
                makeDIRforFilename(saveFileVar);
                save(saveFileVar,'cameraParams');
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
                fileList{ii} = saveFile;
            end
            benchConditions{ai,bi,di}.bigTheta = bigTheta;
            benchConditions{ai,bi,di}.fileList = fileList;
            benchConditions{ai,bi,di}.cameraVarList = cameraVarList;
            benchConditions{ai,bi,di}.A = params.As(ai);
            benchConditions{ai,bi,di}.B = params.Bs(bi);
            benchConditions{ai,bi,di}.D = params.dist2Spots(di);
        end
    end
end
benchStruct.Kmatrix     = Kmatrix;
benchStruct.conditions  = benchConditions;
benchStruct.psfs        = psfs;
benchStruct.centerCoor  = centerCoor;
save([saveFolder filesep 'benchStruct'],'benchStruct');
