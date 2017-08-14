function pairingPlotBMP = genPairingPlotBMP(spotParamsBasket,varargin)
%GENPAIRINGPLOTBMP Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.pixelLength     = [];
params.pairingHeight   = 20;  % make it this tall
params.bkgndGrey       = 0.0;
params.color           = [1 0 0];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


numSeq = numel(spotParamsBasket);

if isempty(params.pixelLength)
    bmpPlotLength = numSeq;
else
    bmpPlotLength = params.pixelLength;
end

pairingPlotBMP = params.bkgndGrey*ones(params.pairingHeight,bmpPlotLength);

for ii = 1:bmpPlotLength
    currAmps = returnAmplitudes(spotParamsBasket{ii});
    if numel(currAmps) == 1
       pairingPlotBMP(:,ii,:) = 1; 
    end
end

pairingPlotBMP = bw2rgb(pairingPlotBMP);
pairingPlotBMP(:,:,~params.color) = 0;