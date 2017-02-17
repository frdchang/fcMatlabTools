function Kmatrix = extractKmatrixFromData(spectras,varargin)
%EXTRACTKMATRIXFROMDATA will extract spectral bleedthru given a cell list
%folder paths that contain the data
%
% extractKmatrixFromData({'GreenTTL','CyanTTL'},'/mnt/btrfs/fcDataStorage/fcNikon/fcTest/20170216-check2ColorBleedThru/combinedData/red','/mnt/btrfs/fcDataStorage/fcNikon/fcTest/20170216-check2ColorBleedThru/combinedData/green');

numSpectras = numel(varargin);
otsuMulti = 2;

for ii = 1:numSpectras
    currSpectraFolder = varargin{ii};
    currSpectraPaths = getAllFiles(currSpectraFolder,'tif');
    % organize into spectra
    currSpectraPaths = cellfunNonUniformOutput(@(x) keepCertainStringsUnion(currSpectraPaths,x),spectras);
    tempDataHolder = cell(numel(currSpectraPaths),1);
    for jj = 1:numel(currSpectraPaths)
        for kk = 1:numel(currSpectraPaths{jj})
            stack = importStack(currSpectraPaths{jj}{kk});
            currThresh = multithresh(stack(:))*otsuMulti;
            tempDataHolder{jj} = [tempDataHolder{jj} stack(stack>currThresh)'];
        end  
    end
end


end

