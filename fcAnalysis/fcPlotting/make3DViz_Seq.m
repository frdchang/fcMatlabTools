function outputPath = make3DViz_Seq(fluorPaths,spotParamPaths,phasePaths,varargin)
%MAKE3DVIZ_SEQ will make a 3D visualization of the image sequence.  
%--parameters--------------------------------------------------------------
params.default1     = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

numSeq = numel(fluorPaths);

for ii = 1:numSeq
   currFluor = importStack(fluorPaths{ii});
   currPhase = importStack(phasePaths{ii});
   currSpotParams = load(spotParamPaths{ii});
   
   if ~isempty(currFluor)
       
   end
end


end

