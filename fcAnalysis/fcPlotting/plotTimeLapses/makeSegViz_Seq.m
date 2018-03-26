function saveFiles = makeSegViz_Seq(phaseFiles,segFiles,varargin)
%MAKESEG Summary of this function goes here
%   Detailed explanation goes here
%--------------------------------------------------------------------------
params.default = [];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

validTimepoints = find(~cellfun(@isempty,segFiles));

if isempty(validTimepoints)
    saveFiles = [];
    return;
end

segFiles    = segFiles(validTimepoints);
phaseFiles  = phaseFiles(validTimepoints);
numSeq      = numel(validTimepoints);

display(['makeSegViz_Seq(): for ' calcConsensusString(segFiles)]);
saveFiles = cell(numSeq,1);
for ii = 1:numSeq
    currSegFile = importStack(segFiles{ii});
    currPhaseFile = importStack(phaseFiles{ii});
    [~,rgbLabelandText] = plotLabels(currPhaseFile,currSegFile,'showPlot',false);
    saveFiles{ii} = genProcessedFileName(segFiles(ii),'makeSegViz_Seq','deleteHistory',true);
    makeDIRforFilename(saveFiles{ii});
    imwrite(rgbLabelandText,[returnFilePath(saveFiles{ii}) filesep 'index' sprintf('%04d',ii) '.tif'],'tif');
end

