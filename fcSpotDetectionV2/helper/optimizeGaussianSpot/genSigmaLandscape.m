function [] = genSigmaLandscape(data,pathToOutputDump)
%GENSIGMALANDSCAPE will generate a landscape of sigmas and output to dump
zslice = 9;
threshVal = 0.0015;
sigmaSQXY = 1:0.2:5;
sigmaSQZ  = 1:0.2:5;
patchSize = 30; % patchSize = 10:15;
uberIndex = 1;
makeDIRforFilename(pathToOutputDump);
if exist(pathToOutputDump) ~=0
rmdir(pathToOutputDump,'s');
end
% for kk = 1:numel(patchSize)
    for ii = 1:numel(sigmaSQXY)
        for jj = 1:numel(sigmaSQZ)
            kern = ndGauss([sigmaSQXY(ii) sigmaSQXY(ii) sigmaSQZ(jj)],[patchSize patchSize patchSize]);
            kern = threshPSF(kern,threshVal);
            estimated = findSpotsStage1V2(data,kern,ones(size(data)));
            saveThisSlice = estimated.LLRatio(:,:,zslice);
%             savePath = [pathToOutputDump filesep 'patch' num2str(patchSize(kk))];
% %             makeDIRforFilename(savePath);
            exportSingleFitsStack([pathToOutputDump filesep 'XY' num2str(ii) '_Z' num2str(jj)],saveThisSlice);
            uberIndex = uberIndex+1;
        end
    end
% end
end

