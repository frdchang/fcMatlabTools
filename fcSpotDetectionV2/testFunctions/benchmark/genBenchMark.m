function [benchStruct] = genBenchMark(varargin)
%GENBENCHMARK will generate a battery datasets for the spot detection to do
% benchmarking on


%--parameters--------------------------------------------------------------
params.sizeData         = [51 51 51];
params.KMatrix          = [1 0.2; 0.2 1];

params.psfFunc          = @genPSF;
params.psfFuncArgs      = {{},{}};
params.NoiseFunc        = @genSCMOSNoiseVar;
params.NoiseFuncArgs    = {params.sizeData,'scanType','slow'};

params.numSamples       = 10;
params.As               = linspace(0,10,20);
params.Bs               = linspace(0,10,20);
params.dist2Spots       = linspace(0,5,20);
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

centerCoor = getCenterCoor(params.sizeData);
domains  = genMeshFromData(zeros(params.sizeData));

for a = 1:numel(params.As)
    for b = 1:numel(params.Bs)
        for d = 1:numel(params.dist2Spots)
            bigTheta    = genBigTheta(params.Kmatrix,psfs,spotCoors);
            bigLambdas  = bigLambda(domains,bigTheta);
            cameraVar   = params.NoiseFunc(params.NoiseFuncArgs{:});
            [electrons] = genMicroscopeNoise(bigLambdas,'readNoiseData',cameraVar);
        end
    end
end

