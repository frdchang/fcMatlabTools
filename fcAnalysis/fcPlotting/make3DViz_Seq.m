function outputPath = make3DViz_Seq(fluorPaths,spotParamPaths,phasePaths,varargin)
%MAKE3DVIZ_SEQ will make a 3D visualization of the image sequence.  
%--parameters--------------------------------------------------------------
params.default1     = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

numSeq = numel(fluorPaths);
fluorExtremas = getMaxMinOfSeq(fluorPaths);
phaseExtremas = getMaxMinOfSeq(phasePaths);



for ii = 1:numSeq
   currFluor = importStack(fluorPaths{ii});
   currPhase = importStack(phasePaths{ii});
   % normalize by sequence extremas
   currFluor = norm0to1(currFluor,'userMin',fluorExtremas.min,'userMax',fluorExtremas.max);
   currPhase = norm0to1(currPhase,'userMin',phaseExtremas.min,'userMax',phaseExtremas.max);
   % load spots
   currSpotParams = loadAndTakeFirstField(spotParamPaths{ii});
   
   if ~isempty(currFluor)
       % make3D viz sans spots
       [views,theViews] = return3Views(currFluor,'phaseAppend',currPhase,'spotParams',currSpotParams);
       % make3D viz with spots
       [viewsSansSpots,theViewsSanSpots] = return3Views(currFluor,'phaseAppend',currPhase);
   end
   
end

outputPath = 'fred';

end

