function [fullMontage,tableOfOutputs] = make3DViz_Seq(rawFluorPaths,fluorPaths,spotParamPaths,phasePaths,LLRatioPaths,varargin)
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


validTimepoints = [getFirstNonEmptyIndex(fluorPaths):getLastNonEmptyIndex(fluorPaths)];
if isempty(validTimepoints)
    fullMontage = [];
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

sizeDatas = getSize(currFluor);

% generate kymos
phaseKymos = buildKymo(phasePaths,upRezFactor);
fluorKymos = buildKymo(fluorPaths,upRezFactor);
LLRatKymos = buildKymo(LLRatioPaths,upRezFactor);
rawKymos   = buildKymo(rawFluorPaths,upRezFactor);
% generate spotkymos
spotKymos  = buildKymoSpots(fluorKymos,spotParamPaths,sizeDatas,upRezFactor,varargin{:});

% generate views (sampled)
phaseViews = buildView(phasePaths,upRezFactor);
fluorViews = buildView(fluorPaths,upRezFactor);
phaseViews = ncellfun(@norm2UINT255,phaseViews);
fluorViews = ncellfun(@norm2UINT255,fluorViews);

% generate all timepoint views
phaseAllViews = buildView(phasePaths,upRezFactor,numSeq);
fluorAllViews = buildView(fluorPaths,upRezFactor,numSeq);

% generate spotviews
spotViews  = buildViewSpots(fluorPaths,spotParamPaths,upRezFactor,varargin{:});
allSpotViews  = buildViewSpots(fluorPaths,spotParamPaths,upRezFactor,'doAllTimePoints',true,varargin{:});
allSpotViews = ncellfun(@uint8,allSpotViews);

% do overlay num spots conflict with spectral rgb
fluorViewsWithSpots = myOverlay(fluorViews,spotViews);
fluorKymosWithSpots = myOverlay(fluorKymos,spotKymos);

% remove the second views in build view and remove 2nd and 3rd dim from
% phase
fluorViews          = cellfunNonUniformOutput(@removeSecondElement,fluorViews);
fluorViewsWithSpots = cellfunNonUniformOutput(@removeSecondElement,fluorViewsWithSpots);
phaseViews          = cell2mat(phaseViews{1}(1,:));
phaseKymos          = phaseKymos{1}(1);
% if this is multi color dataset, generate a multi color kymograph
if numel(fluorViews) > 1
    coloredFluorViews = genRGBFromCell(fluorViews);
    coloredFluorKymos = genRGBFromCell(fluorKymos);
    
    % convert views to rgb
    eachView = applyFuncToCellRows(@cell2mat,coloredFluorViews);
    coloredFluorViews = vertcat(eachView{:});
    
    fluorViewsWithSpots = cellfun(@(x) applyFuncToCellRows(@cell2mat,x),fluorViewsWithSpots,'un',0);
    fluorViewsWithSpots = vertcat(fluorViewsWithSpots{:});
    assembled = {phaseViews,phaseKymos,coloredFluorViews,fluorViewsWithSpots,coloredFluorKymos,fluorKymosWithSpots};
else
    assembled = {phaseViews,phaseKymos,fluorViews,fluorViewsWithSpots,fluorKymos,fluorKymosWithSpots};
end

individualImgsNames = {'phaseViews','phaseKymos','fluorViews','fluorViewsWithSpots','fluorKymos','fluorKymosWithSpots','phaseAllViews','fluorAllViews','sizeDatas','upRezFactor','numSeq','validTimepoints','fullMontage','allSpotViews'};
fullMontage = genMontage(assembled);
assembled = {assembled{:},phaseAllViews,fluorAllViews,sizeDatas,upRezFactor,numSeq,validTimepoints,fullMontage,allSpotViews};
assembled = convertListToListofArguments(assembled);

tableOfOutputs = table(assembled{:},'VariableNames',individualImgsNames);
end



