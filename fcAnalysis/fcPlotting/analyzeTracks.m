function [ output ] = analyzeTracks(raws,vizPieces,tracks,varargin)
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

tracks = cellfunNonUniformOutput(@(tracks) filterTracksByLength(tracks,params.minTrackLength,Inf),tracks);

[myTracks]    = buildTrackSpots(vizPieces.numSeq{1},tracks,vizPieces.sizeDatas{1},vizPieces.upRezFactor{1});
trackDists    = getTrackDists(tracks);
As            = getTrackByIndex(tracks,4);
Bs            = getTrackByIndex(tracks,5);

AsPlot        = plotTrackStuff(As,vizPieces.numSeq{1});
BsPlot        = plotTrackStuff(Bs,vizPieces.numSeq{1});
distPlot      = plotTrackStuff(trackDists,vizPieces.numSeq{1});

allFluorViews = vizPieces.fluorAllViews{1};
end

