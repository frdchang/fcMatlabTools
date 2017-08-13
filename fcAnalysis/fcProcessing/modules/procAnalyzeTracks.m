function [ analyzedTracks ] = procAnalyzeTracks(ec_T_spotOutputs,ec_T_3Dviz,trackedSpots,varargin)
%POCANALYZETRACKS Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.doProcParallel     = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

raws        = ec_T_spotOutputs.outputFiles.files;
kymoPieces  = ec_T_3Dviz.outputFiles.montagePiecesMat;
tracks      = trackedSpots.outputFiles.passThru;
raws= convertA1sToGlued(raws);

kymoPiecesTracks = glueCells(raws,kymoPieces,tracks);

analyzedTracks   = applyFuncTo_listOfListOfArguments(kymoPiecesTracks,@openData_passThru,{},@analyzeTracks,{varargin{:}},@saveToProcessed_analyzeTracks,{},'doParallel',params.doProcParallel);

analyzedTracks   = procSaver(ec_T_spotOutputs,analyzedTracks);
end

function glued = convertA1sToGlued(A1s)
A1s         = cellfunNonUniformOutput(@localGlue,A1s{:});
glued = glueChans(A1s);
end

function output = localGlue(varargin)
output = cat(1,varargin{:});
end

function glued = glueChans(A1s)
glued = cellfunNonUniformOutput(@glueCells,A1s{:});
end
