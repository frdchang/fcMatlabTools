function Kmatrix = extractKmatrixFromData(spectras,varargin)
%EXTRACTKMATRIXFROMDATA will extract spectral bleedthru given a cell list
%folder paths that contain the data
%
% extractKmatrixFromData({'GreenTTL','CyanTTL'},'/mnt/btrfs/fcDataStorage/fcNikon/fcTest/20170216-check2ColorBleedThru/combinedData/red','/mnt/btrfs/fcDataStorage/fcNikon/fcTest/20170216-check2ColorBleedThru/combinedData/green');
pathToCalibration = '/home/fchang/Dropbox/code/Matlab/fcBinaries/calibration-ID001486-CoolerAIR-ROI2048x2048-SlowScan-sensorCorrectionOFF-20161021.mat';
numSpectras = numel(varargin);
otsuMulti = 1;
[~,kern ]= ndGauss([0.9,0.9,0.9],[7 7 7]);
coeffHolder = cell(numSpectras,1);
for ii = 1:numSpectras
    currSpectraFolder = varargin{ii};
    currSpectraPaths = getAllFiles(currSpectraFolder,'tif');
    % organize into spectra
    currSpectraPaths = cellfunNonUniformOutput(@(x) keepCertainStringsUnion(currSpectraPaths,x),spectras);
    numSpectras = numel(currSpectraPaths{1});
    tempDataHolder = cell(numel(currSpectraPaths),1);
    for jj = 1:numSpectras
        stack = importStack(currSpectraPaths{1}{jj});
        [stack,readNoiseVarInElectrons] = returnElectronsFromCalibrationFile(stack,pathToCalibration);
        stack = findSpotsStage1(stack,kern,readNoiseVarInElectrons);
        currThresh = multithresh(stack.LLRatio(:))*otsuMulti;
        idx   = stack.LLRatio > currThresh;
        stack = stack.A1;
        tempDataHolder{1} = [tempDataHolder{1} stack(idx)'];
        for kk = 2:numel(currSpectraPaths)
            otherStack = importStack(currSpectraPaths{kk}{jj});
            [otherStack,readNoiseVarInElectrons] = returnElectronsFromCalibrationFile(otherStack,pathToCalibration);
            otherStack = findSpotsStage1(otherStack,kern,readNoiseVarInElectrons);
            
            tempDataHolder{kk} = [tempDataHolder{kk} otherStack.A1(idx)'];
        end
    end
    figure;scatter(tempDataHolder{1},tempDataHolder{2});xlabel(spectras{1});ylabel(spectras{2});
    title(returnFileName(currSpectraFolder));
    coeffHolder{ii} = polyfit(tempDataHolder{1},tempDataHolder{2}, 1);
    %     tempDataHolder = cell(numel(currSpectraPaths),1);
    %     for jj = 1:numel(currSpectraPaths)
    %         for kk = 1:numel(currSpectraPaths{jj})
    %             stack = importStack(currSpectraPaths{jj}{kk});
    %             currThresh = multithresh(stack(:))*otsuMulti;
    %             tempDataHolder{jj} = [tempDataHolder{jj} stack(stack>currThresh)'];
    %         end
    %     end
end


end

