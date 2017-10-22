function [ filePath ] = make3DTracks(tracks,fluorsFiles,phaseFiles,varargin)
%MAKE3DTRACKS Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.minTrackLength     = 2;
params.phaseFactor        = 0.1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

tracks = cellfunNonUniformOutput(@(tracks) filterTracksByLength(tracks,params.minTrackLength,Inf),tracks);

savePath = genProcessedFileName(fluorsFiles,@make3DTracks);
savePath = [returnFilePath(savePath) filesep 'tifs'];
makeDIR(savePath);
numTimePoints = numel(phaseFiles);
% ii = numTimePoints;
% close all;
% currFluors = importStack(fluorsFiles{ii});
% currPhase  = importStack(phaseFiles{ii});
% currPhase  = currPhase*params.phaseFactor ;
% plotTracks(currFluors,currPhase,tracks,ii);
%    sizeData = size(currFluors);
%     axis([0 sizeData(1) 0 sizeData(2) 0 sizeData(3)]);    pbaspect([1 1 2]);
% 
% pause();
% [az,el] = view;
% filePath = cell(numTimePoints,1);
for ii = 1:numTimePoints
    currFluors = importStack(fluorsFiles{ii});
    currPhase  = importStack(phaseFiles{ii});
    currPhase  = currPhase*params.phaseFactor ;
    close all;
    plotTracks(currFluors,currPhase,tracks,ii);
    view([-26,83]);
    set(gca,'Color','none');
    sizeData = size(currFluors);
    pbaspect([1 1 2]);
    filePath{ii} = [savePath filesep num2str(ii)];
    export_fig(filePath{ii} ,'-tif','-r200');
end
end

