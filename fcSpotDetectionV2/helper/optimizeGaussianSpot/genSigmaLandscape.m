function [] = genSigmaLandscape(data,pathToOutputDump)
%GENSIGMALANDSCAPE will generate a landscape of sigmas and output to dump
zslice = 7;
threshVal = 0.0015;
sigmaXY = sqrt(0.5:0.5:6);
sigmaZ  = sqrt(0.5:0.5:6);
patchSize = 31; % patchSize = 10:15;
uberIndex = 1;
makeDIRforFilename(pathToOutputDump);
if exist(pathToOutputDump) ~=0
    rmdir(pathToOutputDump,'s');
end
% for kk = 1:numel(patchSize)
parfor aa = 1:numel(sigmaZ)
    for bb = 1:numel(sigmaXY)
        thisSigmaSq = [sigmaXY(bb)^2 sigmaXY(bb)^2 sigmaZ(aa)^2];
        %         mux = 0:0.5:0.75;
        %         muy = 0:0.5:0.75;
        %         muz = 0:0.5:0.75;
        %         kernCell = cell(numel(mux),numel(muy),numel(muz));
        %         for ii = 1:numel(mux)
        %             for jj = 1:numel(muy)
        %                 for kk = 1:numel(muz)
        %                     [kernCell{ii,jj,kk},~] = ndGauss(thisSigmaSq,[patchSize,patchSize,patchSize],[mux(ii),muy(jj),muz(kk)]);
        %                 end
        %             end
        %         end
        %         threshKern = threshPSF(kernCell{1,1,1},threshVal);
        %         kernCell = cellfunNonUniformOutput(@(x) cropCenterSize(x,size(threshKern)),kernCell);
        %         estimated  = findSpotsStage1V2Interpolate(data,kernCell,ones(size(data)));
        kern = ndGauss(thisSigmaSq,[patchSize,patchSize,patchSize]);
        kern = threshPSF(kern,threshVal);
        estimated = findSpotsStage1V2(data,kern,ones(size(data)));
        saveThisSlice = estimated.LLRatio(:,:,zslice);
        %             savePath = [pathToOutputDump filesep 'patch' num2str(patchSize(kk))];
        % %             makeDIRforFilename(savePath);
        exportStack([pathToOutputDump filesep 'XY' num2str(bb) '_Z' num2str(aa)],saveThisSlice);
        uberIndex = uberIndex+1;
    end
end
% end


display([num2str(numel(sigmaXY)) ',' num2str(numel(sigmaZ))]);