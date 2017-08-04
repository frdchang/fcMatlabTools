function saveFiles = make3DViz_Seq(rawFluorPaths,fluorPaths,spotParamPaths,phasePaths,LLRatioPaths,varargin)
%MAKE3DVIZ_SEQ will make a 3D visualization of the image sequence.
% phasePath can be empty if not needed
%--parameters--------------------------------------------------------------
params.upRez            = 1;
params.units            = [0.1083,0.1083,0.45700];
params.bkgndGrey        = 0.2;
params.spacerHeight     = 5;
params.pixelHeight      = 2;
params.pairingHeight    = 5;
params.upRezHeight      = 20;
params.markerSize       = 0;
params.pairingHeight    = 20;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

myUnits = params.units / params.units(1);
upRezFactor   = round(params.upRez*myUnits);


validTimepoints = find(~cellfun(@isempty,fluorPaths));
if isempty(validTimepoints)
    saveFiles = [];
    return;
else
    rawFluorPaths   = rawFluorPaths(validTimepoints);
    fluorPaths      = fluorPaths(validTimepoints);
    spotParamPaths  = spotParamPaths(validTimepoints);
    phasePaths      = phasePaths(validTimepoints);
    LLRatioPaths    = LLRatioPaths(validTimepoints);
    
    phasePaths      = convertListToListofArguments(phasePaths);
    LLRatioPaths    = convertListToListofArguments(LLRatioPaths);
end
display(['make3Dviz_Seq(): for ' returnFileName(calcConsensusString(flattenCellArray(fluorPaths)))]);

numSeq = numel(fluorPaths);
firstFile = getFirstNonEmptyCellContent(fluorPaths);
currFluor = importStack(firstFile);
sizeDatas  = size(currFluor{1});

% generate kymos
phaseKymos = buildKymo(phasePaths,upRezFactor);
fluorKymos = buildKymo(fluorPaths,upRezFactor);
LLRatKymos = buildKymo(LLRatioPaths,upRezFactor);
rawKymos   = buildKymo(rawFluorPaths,upRezFactor);
% generate spotkymos
spotKymos  = buildKymoSpots(fluorKymos,spotParamPaths,sizeDatas,upRezFactor);

% generate views
phaseViews = buildView(phasePaths,upRezFactor);
fluorViews = buildView(fluorPaths,upRezFactor);

% generate spotviews
spotViews  = buildViewSpots(fluorPaths,spotParamPaths,upRezFactor);

% genmontage

% do overlay num spots conflict with spectral rgb
test = cellfunNonUniformOutput(@(fluorViews,spotViews) cellfunNonUniformOutput(@myOverlay,fluorViews,spotViews),fluorViews,spotViews);




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

