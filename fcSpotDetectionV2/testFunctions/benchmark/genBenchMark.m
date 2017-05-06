function [benchStruct] = genBenchMark(varargin)
%GENBENCHMARK will generate a battery datasets for the spot detection to do
% benchmarking on


%--parameters--------------------------------------------------------------
params.saveFolder       = '~/Desktop/dataStorage';
params.sizeData         = [51 51 51];
params.Kmatrix          = [1 0.2; 0.2 1];

params.psfFunc          = @genPSF;
params.psfFuncArgs      = {{},{}};
params.NoiseFunc        = @genSCMOSNoiseVar;
params.NoiseFuncArgs    = {params.sizeData,'scanType','slow'};

params.numSamples       = 1;
params.As               = linspace(10,0,20);
params.Bs               = linspace(0,10,20);
params.dist2Spots       = linspace(0,5,20);
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% generate date string
temp = datevec(date);
year = temp(1);
month = temp(2);
day = temp(3);
today = sprintf('%d%02d%02d',year,month,day);
saveFolder = [params.saveFolder filesep today];
[~,~,~] = mkdir(saveFolder);

centerCoor  = getCenterCoor(params.sizeData);
domains     = genMeshFromData(zeros(params.sizeData));
psfs        = cellfunNonUniformOutput(@(x) params.psfFunc(x{:}),params.psfFuncArgs);
psfObjs     = cellfunNonUniformOutput(@(x) myPattern_Numeric(x),psfs);
for ai = 1:numel(params.As)
    for bi = 1:numel(params.Bs)
        for di = 1:numel(params.dist2Spots)
            if isscalar(params.Kmatrix) == 1
                % generate spots given that there is 1 channel
                spotCoors = {{[params.As(ai) centerCoor],[params.As(ai) centerCoor+params.dist2Spots(di)],params.Bs(bi)}};
            elseif size(params.Kmatrix,1) == 2
                % generate spots given that there is 2 channels
                spotCoors = {{[params.As(ai) centerCoor],params.Bs(bi)},{[params.As(ai) centerCoor+params.dist2Spots(di)],params.Bs(bi)}};
            else
                error('Kmatrix needs to be 1 or 2 dimensions');
            end
            
            for ii = 1:params.numSamples
                bigTheta    = genBigTheta(params.Kmatrix,psfs,spotCoors);
                bigLambdas  = bigLambda(domains,bigTheta,'objKerns',psfObjs);
                cameraVar   = params.NoiseFunc(params.NoiseFuncArgs{:});
                [electrons,~,cameraParams]   = genMicroscopeNoise(bigLambdas,'readNoiseData',cameraVar);
                saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths,myFunc,'appendFolder',adsfas);
                % save file
                % save ground true
            end
        end
    end
end

