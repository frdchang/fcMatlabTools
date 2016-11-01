function saveFiles = make3DViz_Seq(fluorPaths,spotParamPaths,phasePaths,LLRatioPaths,varargin)
%MAKE3DVIZ_SEQ will make a 3D visualization of the image sequence.
% phasePath can be empty if not needed
%--parameters--------------------------------------------------------------
params.LLRatioThresh    = 0;
params.zMulti           = 3; % make sure this is integers
params.bkgndGrey        = 0.2;
params.spacerHeight     = 5;
params.pixelHeight      = 2;
params.units            = [0.1083,0.1083,0.300];
params.pairingHeight    = 5;
params.upRezHeight      = 20;
params.markerSize       = 0;
params.pairingHeight    = 20;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

validTimepoints = find(~cellfun(@isempty,fluorPaths));
if isempty(validTimepoints)
    saveFiles = [];
    return;
else
    fluorPaths = fluorPaths(validTimepoints);
    spotParamPaths= spotParamPaths(validTimepoints);
    phasePaths = phasePaths(validTimepoints);
    LLRatioPaths = LLRatioPaths(validTimepoints);
end
display(['make3Dviz_Seq(): for ' calcConsensusString(fluorPaths)]);
numSeq = numel(fluorPaths);
fluorExtremas = getMaxMinOfSeq(fluorPaths);
phaseExtremas = getMaxMinOfSeq(phasePaths);
% get size of dataset
currFluor = importStack(getFirstNonEmptyCellContent(fluorPaths));
sizeDatas  = size(currFluor);

kymoInX = zeros(sizeDatas(2),numSeq,3,'uint8');
kymoInY = zeros(sizeDatas(1),numSeq,3,'uint8');
kymoInZ = zeros(sizeDatas(3)*params.zMulti,numSeq,3,'uint8');

kymoInXsansSpots = kymoInX;
kymoInYsansSpots = kymoInY;
kymoInZsansSpots = kymoInZ;

LLkymoInX = kymoInX;
LLkymoInY = kymoInY;
LLkymoInZ = kymoInZ;

phaseKymoInX = zeros(sizeDatas(2),numSeq,3,'uint8');
convert2uint8 = @(x) uint8(255*x);

saveFiles.Views = {};
saveFiles.ViewsSansSpots = {};
saveFiles.LLViews = {};

spotParamBasket = cell(numSeq,1);
phaseBasket = zeros(sizeDatas(1),sizeDatas(2),ceil(numSeq/sizeDatas(2)));
index = 1;
for ii = 1:numSeq
    currFluor = importStack(fluorPaths{ii});
    currPhase = importStack(phasePaths{ii});
    currLLRatio = importStack(LLRatioPaths{ii});
    % normalize by sequence extremas
    currFluor = norm0to1(currFluor,'userMin',fluorExtremas.min,'userMax',fluorExtremas.max);
    currPhase = norm0to1(currPhase,'userMin',phaseExtremas.min,'userMax',phaseExtremas.max);
    % normalize LLRatio per time point
    currLLRatio = norm0to1(currLLRatio);
    % load spots
    currSpotParams = loadAndTakeFirstField(spotParamPaths{ii});
    % threshold spots by parameters defined
    currSpotParams = threshLLRatio(currSpotParams,params.LLRatioThresh);
    
    if ~isempty(currFluor)
        % make3D viz with spots
        [views,theViews] = return3Views(currFluor,'phaseAppend',currPhase,'spotParams',currSpotParams,params);
        views = convert2uint8(views);
        theViews = structFieldFun(theViews,convert2uint8,{'view','phase'});
        
        [LLviews,LLtheViews] = return3Views(currLLRatio,'phaseAppend',currPhase,'spotParams',currSpotParams,params);
        LLviews = convert2uint8(LLviews);
        LLtheViews = structFieldFun(LLtheViews,convert2uint8,{'view','phase'});
        
        % make3D viz without spots
        [viewsSansSpots,theViewsSanSpots] = return3Views(currFluor,'phaseAppend',currPhase,params);
        viewsSansSpots = convert2uint8(viewsSansSpots);
        theViewsSanSpots = structFieldFun(theViewsSanSpots,convert2uint8,{'view','phase'});
        % save the 3d views
        saveFiles.Views{ii} = genProcessedFileName({fluorPaths{ii}},'make3DViz_Seq','deleteHistory',true,'appendFolder','views');
        makeDIRforFilename(saveFiles.Views{ii});
        imwrite(views,[returnFilePath(saveFiles.Views{ii}) filesep 'index' sprintf('%04d',ii) '.tif'],'tif');
        saveFiles.ViewsSansSpots{ii} = genProcessedFileName({fluorPaths{ii}},'make3DViz_Seq','deleteHistory',true,'appendFolder','viewsSansSpots');
        makeDIRforFilename(saveFiles.ViewsSansSpots{ii});
        imwrite(viewsSansSpots,[returnFilePath(saveFiles.ViewsSansSpots{ii}) filesep 'cell' sprintf('%04d',ii) '.tif'],'tif');
        
        saveFiles.LLViews{ii} = genProcessedFileName({fluorPaths{ii}},'make3DViz_Seq','deleteHistory',true,'appendFolder','viewsLLRatio');
        makeDIRforFilename(saveFiles.LLViews{ii});
        imwrite(LLviews,[returnFilePath(saveFiles.LLViews{ii}) filesep 'index' sprintf('%04d',ii) '.tif'],'tif');
        
        % populate kymos
        kymoInX(:,ii,:) = maxintensityproj4RGB(theViews.view1,1);
        kymoInY(:,ii,:) = maxintensityproj4RGB(theViews.view1,2);
        kymoInZ(:,ii,:) = maxintensityproj4RGB(theViews.view2,1);
        
        kymoInXsansSpots(:,ii,:) = maxintensityproj(theViewsSanSpots.view1,1);
        kymoInYsansSpots(:,ii,:) = maxintensityproj(theViewsSanSpots.view1,2);
        kymoInZsansSpots(:,ii,:) = maxintensityproj(theViewsSanSpots.view2,1);
        
        phaseKymoInX(:,ii,:) = maxintensityproj(theViews.phase,1);
        
        LLkymoInX(:,ii,:) = maxintensityproj4RGB(LLtheViews.view1,1);
        LLkymoInY(:,ii,:) = maxintensityproj4RGB(LLtheViews.view1,2);
        LLkymoInZ(:,ii,:) = maxintensityproj4RGB(LLtheViews.view2,1);
        
        % save the spotParams
        spotParamBasket{ii} = currSpotParams;
    end
    if ~isempty(currPhase)
        if mod(ii,sizeDatas(2))==1
            phaseBasket(:,:,index) =  xyMaxProjND(currPhase);
            index = index+1;
        end
    end
end
% phaseMontage = plotMontage(phaseBasket,'Size',[1 NaN]);
% phaseMontage = phaseMontage.CData;
phaseMontage = makeLinearMontage(phaseBasket);
phaseMontage = bw2rgb(uint8(255*phaseMontage));
phaseMontage = phaseMontage(:,1:numSeq,:);
close all;
% generate kymos
spacer = params.bkgndGrey*ones(params.spacerHeight,numSeq,3);
% generate amplitude and distance plots
distPlotBMP = bw2rgb(bitmapPlotSeq(spotParamBasket,@returnPairWiseDistsOfSpotParams,params));
ampPlotBMP = bw2rgb(bitmapPlotSeq(spotParamBasket,@returnAmplitudes,params,'pixelHeight',[]));
pairingPlotBMP = genPairingPlotBMP(spotParamBasket,'height',params.pairingHeight);

accessoryPlots = uint8(255*(cat(1,pairingPlotBMP,spacer,ampPlotBMP,spacer,distPlotBMP)));

kymoInXYZ = cat(1,kymoInX,spacer,kymoInY,spacer,kymoInZ,spacer,accessoryPlots);
kymoInXYZsansSpots =  cat(1,kymoInXsansSpots,spacer,kymoInYsansSpots,spacer,kymoInZsansSpots);
LLkymoInXYZ = cat(1,LLkymoInX,spacer,LLkymoInY,spacer,LLkymoInZ,spacer);
% generate top phase plot
% phasePlotOnTop = genPhasePlotOnTop(phasePaths,numSeq);
%
% saveFiles.kymoSansSpots = genProcessedFileName({fluorPaths},'make3DViz_Seq','deleteHistory',true,'appendFolder','kymoSansSpots');
% makeDIRforFilename(saveFiles.kymoSansSpots);
% imwrite(kymoInXYZsansSpots,[saveFiles.kymoSansSpots '.tif'],'tif');
saveFiles.kymo = genProcessedFileName({fluorPaths},'make3DViz_Seq','deleteHistory',true,'appendFolder','kymo');
makeDIRforFilename(saveFiles.kymo);
kymoInXYZ = cat(1,phaseMontage,spacer,kymoInXYZsansSpots,spacer,LLkymoInXYZ,spacer,kymoInXYZ);
imwrite(kymoInXYZ,[saveFiles.kymo '.tif'],'tif');
end

