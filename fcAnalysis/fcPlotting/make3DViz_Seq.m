function outputPath = make3DViz_Seq(fluorPaths,spotParamPaths,phasePaths,varargin)
%MAKE3DVIZ_SEQ will make a 3D visualization of the image sequence.
% phasePath can be empty if not needed
%--parameters--------------------------------------------------------------
params.zMulti           = 3; % make sure this is integers
params.bkgndGrey        = 0.2;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

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

phaseKymoInX = zeros(sizeDatas(2),numSeq,3,'uint8');
convert2uint8 = @(x) uint8(255*x);

saveFiles.Views = {};
saveFiles.ViewsSansSpots = {};
saveFiles.kymo = {};
saveFiles.kymoSansSpots = {};

distBasket = cell(numSeq,1);
ampBasket = cell(numSeq,1);
for ii = 1:numSeq
    currFluor = importStack(fluorPaths{ii});
    currPhase = importStack(phasePaths{ii});
    % normalize by sequence extremas
    currFluor = norm0to1(currFluor,'userMin',fluorExtremas.min,'userMax',fluorExtremas.max);
    currPhase = norm0to1(currPhase,'userMin',phaseExtremas.min,'userMax',phaseExtremas.max);
    % load spots
    currSpotParams = loadAndTakeFirstField(spotParamPaths{ii});
    
    if ~isempty(currFluor)
        
        % make3D viz with spots
        [views,theViews] = return3Views(currFluor,'phaseAppend',currPhase,'spotParams',currSpotParams,params);
        views = convert2uint8(views);
        theViews = structFieldFun(theViews,convert2uint8,{'view','phase'});
        % make3D viz without spots
        [viewsSansSpots,theViewsSanSpots] = return3Views(currFluor,'phaseAppend',currPhase,params);
        viewsSansSpots = convert2uint8(viewsSansSpots);
        theViewsSanSpots = structFieldFun(theViewsSanSpots,convert2uint8,{'view','phase'});
        % save the 3d views
        saveFiles.Views{ii} = genProcessedFileName({fluorPaths{ii}},'make3DViz_Seq','deleteHistory',true,'appendFolder','views');
        imwrite(views,[saveFiles.Views{ii} '.tif'],'tif');
        saveFiles.ViewsSansSpots{ii} = genProcessedFileName({fluorPaths{ii}},'make3DViz_Seq','deleteHistory',true,'appendFolder','viewsSansSpots');
        imwrite(viewsSansSpots,[saveFiles.ViewsSansSpots{ii} '.tif'],'tif');
        % populate kymos
        kymoInX(:,ii,:) = maxintensityproj(theViews.view1,1);
        kymoInY(:,ii,:) = maxintensityproj(theViews.view1,2);
        kymoInZ(:,ii,:) = maxintensityproj(theViews.view2,1);
        
        kymoInXsansSpots(:,ii,:) = maxintensityproj(theViewsSanSpots.view1,1);
        kymoInYsansSpots(:,ii,:) = maxintensityproj(theViewsSanSpots.view1,2);
        kymoInZsansSpots(:,ii,:) = maxintensityproj(theViewsSanSpots.view2,1);
        
        phaseKymoInX(:,ii,:) = maxintensityproj(theViews.phase,1);
        
        % calculate distance
    end
    distBasket{ii} = returnPairWiseDists(currSpotParams);
    ampBasket{ii} = returnAmplitudes(currSpotParams);
end

% save the kymos


outputPath = saveFiles;

end

