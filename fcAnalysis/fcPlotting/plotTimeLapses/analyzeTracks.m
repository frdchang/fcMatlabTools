function [ fullMontage,As,Bs,trackDists,overlayedTracks] = analyzeTracks(raws,vizPieces,tracks,spots,varargin)
%ANALYZETRACKS Summary of this function goes here
%   Detailed explanation goes here
% make view tracks, alpha = 0.5 for timepoints not progressed yet
% make kymo tracks,
% calc various things

%--parameters--------------------------------------------------------------
params.minTrackLength     = 2;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


vizPieces = load(vizPieces);
vizPieces = vizPieces.montagePieces;

filteredTracks = cellfunNonUniformOutput(@(tracks) filterTracksByLength(tracks,params.minTrackLength,Inf),tracks);

[myTracks]    = buildTrackSpots(vizPieces.numSeq{1},vizPieces.validTimepoints{1},filteredTracks,vizPieces.sizeDatas{1},vizPieces.upRezFactor{1});









[trackDists,pairingSig]    = getTrackDists(filteredTracks);
As            = getTrackByIndex(filteredTracks,4);
Bs            = getTrackByIndex(filteredTracks,5);

[AsPlot,maxVals]        = plotTrackStuff(As,vizPieces.numSeq{1},varargin{:},vizPieces.validTimepoints{1});
BsPlot        = plotTrackStuff(Bs,vizPieces.numSeq{1},varargin{:},vizPieces.validTimepoints{1},'maxVals',maxVals);
distPlot      = plotTrackStuff(trackDists,vizPieces.numSeq{1},varargin{:},vizPieces.validTimepoints{1});

pairingPlot   = genPairingPlotBMP(pairingSig,vizPieces.numSeq{1});

allFluorViews = vizPieces.fluorAllViews{1};

if ~isempty(myTracks)
    overlayedTracks = cellfunNonUniformOutput(@(x,y)overlayTracks(x,y),allFluorViews,myTracks);
    
else
    overlayedTracks = allFluorViews;
end
trackKymos = cellfunNonUniformOutput(@(overlayedTracks) genKymosFromViews(overlayedTracks),overlayedTracks);

fullMontage = genMontage({AsPlot,BsPlot,distPlot,pairingPlot,trackKymos{:}});
imshow(fullMontage);

end

