function [ analyzedTracks ] = procAnalyzeTracks(ec_T_3Dviz,trackedSpots,varargin)
%POCANALYZETRACKS Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.doProcParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

kymoPieces  = ec_T_3Dviz.outputFiles.montagePiecesMat;
tracks      = trackedSpots.outputFiles.passThru;

kymoPiecesTracks = glueCells(kymoPieces,tracks);

analyzedTracks   = applyFuncTo_listOfListOfArguments(kymoPiecesTracks,@openData_passThru,{},@analyzeTracks,{varargin{:}},@saveToProcessed_make3DViz_Seq,{},'doParallel',params.doProcParallel);

analyzedTracks   = procSaver(eC_T_spotOutputs,analyzedTracks);
end

