function [ filePath ] = make3DTracks(tracks,fluorsFiles,phaseFiles,varargin)
%MAKE3DTRACKS Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.minTrackLength     = 2;
params.phaseFactor        = 0.1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);
bkgnd = [0.2,0.2,0.2];

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

xMax = cellfun(@(tracks) max(cellfun(@(x) max(max(x(:,2))),tracks)),tracks);
yMax = cellfun(@(tracks) max(cellfun(@(x) max(max(x(:,3))),tracks)),tracks);
zMax = cellfun(@(tracks) max(cellfun(@(x) max(max(x(:,4))),tracks)),tracks);
filePath = cell(numTimePoints);
for ii = 1:numTimePoints
    currFluors = importStack(fluorsFiles{ii});
    currPhase  = importStack(phaseFiles{ii});
    currPhase  = currPhase*params.phaseFactor ;
    close all;
    plotTracks(currFluors,currPhase,tracks,ii);
    axis(ceil([0 max(xMax,size(currFluors,1)) 0 max(yMax,size(currFluors,2)) 0 max(zMax,size(currFluors,3))]));
    view([-26,83]);
    set(gcf,'color',bkgnd);
    set(gca,'Color','none');
    set(gca,'xcolor','w');
    set(gca,'ycolor','w');
    set(gca,'zcolor','w');
    pbaspect([1 1 1.5]);
    filePath{ii} = [savePath filesep num2str(ii) '.tif'];
%     saveas(gcf,filePath{ii});
    export_fig(filePath{ii} ,'-tif','-native');
end
end

