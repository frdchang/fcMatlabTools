function [ output ] = analyzeTracks(vizPieces,tracks,varargin)
%ANALYZETRACKS Summary of this function goes here
%   Detailed explanation goes here
% make view tracks, alpha = 0.5 for timepoints not progressed yet
% make kymo tracks, 
% calc various things


%--parameters--------------------------------------------------------------
params.doProcParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

numChans = numel(tracks);

vizPieces = load(vizPieces);
vizPieces = vizPieces.montagePieces;

myTracks = buildTrackSpots(vizPieces.numSeq{1},tracks,vizPieces.sizeDatas{1},vizPieces.upRezFactor{1});
end

