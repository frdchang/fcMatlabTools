function [fullMontage,tableOfOutputs] = makeKymo(fluorPaths,varargin)
%MAKEKYMO Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.upRez            = 1;
params.units            = [0.1083,0.1083,0.45700];
params.bkgndGrey        = 0.2;
params.spacerHeight     = 5;
params.pixelHeight      = 2;
params.pairingHeight    = 5;
params.upRezHeight      = 20;
params.markerSize       = 0;
params.pairingHeight    = 20;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

myUnits = params.units / params.units(1);
upRezFactor   = round(params.upRez*myUnits);


validTimepoints = [getFirstNonEmptyIndex(fluorPaths):getLastNonEmptyIndex(fluorPaths)];
if isempty(validTimepoints)
    fullMontage = [];
    return;
else
    fluorPaths      = fluorPaths(validTimepoints);
end
display(['makeKymo(): for ' returnFileName(calcConsensusString(flattenCellArray(fluorPaths)))]);

numSeq = numel(fluorPaths);
firstFile = getFirstNonEmptyCellContent(fluorPaths);
currFluor = importStack(firstFile);

sizeDatas = getSize(currFluor);

% generate kymos
fluorKymos = buildKymo(fluorPaths,upRezFactor);
% generate spotkymos

