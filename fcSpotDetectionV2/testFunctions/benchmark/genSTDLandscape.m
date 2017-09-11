function [] = genSTDLandscape(varargin)
% will generate the std landscape from cramer rao lb.

%--parameters--------------------------------------------------------------
params.saveFolder       = '~/Desktop/dataStorage/fcDataStorage';
params.sizeData         = [29 29 11];%[21 21 9];
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

params.useThisCamVar    = 2.5919;  % this value simulates the slow mode with broken pixels

params.numSamples       = 10;
params.As               = linspace(0,30,31);
params.Bs               = linspace(0,24,25);
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

setupParForProgress(totNum);
parfor zz = 1:totNum
    incrementParForProgress();
    [ai,bi,di] = ind2sub([numel(params.As),numel(params.Bs),numel(params.dist2Spots)],zz);
    
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
    
    %     if currD ~= 0 && (currB > currA)
    %         continue;
    %     end
    
    
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
    if iscell(bigLambdas)
        camVarInLambdaUnits = cell(numel(bigLambdas),1);
        [camVarInLambdaUnits{:}] = deal(params.useThisCamVar*ones(size(bigLambdas{1})));
    else
        camVarInLambdaUnits = params.useThisCamVar*ones(size(bigLambdas{1}));
    end
    [ infoMatrix,asymtotVar,stdErrors,fullInfoMatrix] = calcExpectedFisherInfo(bigLambdas,bigDLambdas,camVarInLambdaUnits);
    
    benchConditions{zz} = stdErrors;
end

numThetas = numel(getFirstNonEmptyCellContent(benchConditions));
[aa,bb] = meshgrid(params.As,params.Bs);
numLines = 10;
gradC = linspace(0.2,0.5,size(benchConditions,3));
for ii = 1:numThetas
    
    for jj = [size(benchConditions,3),2]
        display(jj)
        currBench = benchConditions(:,:,jj);
        currPlot = NaN(size(currBench));
        for zz = 1:numel(currBench)
            if ~isempty(currBench{zz})
                if currBench{zz}(ii) ~= Inf
                    currPlot(zz) = currBench{zz}(ii);
                end
            end
        end
        if ~all(isreal(currPlot))
            continue;
        end
        if jj == size(benchConditions,3)
            createFullMaxFigure;
            [cc, hh]=contour(aa,bb,currPlot',numLines,'LineWidth',3,'ShowText','on','LabelSpacing',300);
            prevMin = min(currPlot(:));
            prevMax = max(currPlot(:));
            %             [cc, hh]=contour(aa,bb,currPlot',numLines,'LineWidth',3,'ShowText','on','LabelSpacing',300,'LevelList',round2(hh.LevelList,0.1));
        else
            hold on;
            if prevMax < min(currPlot(:))
                            contour(aa,bb,currPlot',numLines,'LineWidth',1,'ShowText','on','LabelSpacing',1100,'LineStyle','--');

            else
                            contour(aa,bb,currPlot',numLines,'LineWidth',1,'ShowText','on','LabelSpacing',1100,'LevelList',hh.LevelList,'LineStyle','--');

            end
        end
        
    end
    set(gca,'Ydir','reverse');
    %             axis equal;
    xlabel('A');ylabel('B');
    box off;
    title(['theta ' num2str(ii) ' d' num2str(size(benchConditions,3)) '(colored) and then d' num2str(jj)]);
    exportFigEPS(['~/Desktop/' num2str(ii) '_' num2str(jj) '.eps']);
    close all;
end

% display('genBenchMark() done...');
% benchStruct.psfObjs     = psfObjs;
% benchStruct.Kmatrix     = Kmatrix;
% benchStruct.conditions  = benchConditions;
% benchStruct.psfs        = psfs;
% benchStruct.centerCoor  = centerCoor;
% save([saveFolder filesep 'benchStruct'],'benchStruct');
% display('genBenchmark() saved...');
end
