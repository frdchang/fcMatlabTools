function pairingPlotBMP = genPairingPlotBMP(pairingSig,numSeq,varargin)
%GENPAIRINGPLOTBMP plots a pairing signature based on three states
% paired, unpaired and the rest

%--parameters--------------------------------------------------------------
params.pairingHeight         = 20;         % make it this tall
params.nonPairingColor       = [50 50 50];
params.pairingColor          = [0 255 0];
params.otherColor            = [0 0 0];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


pairingPlotBMP = ones(1,numSeq,3);


for ii = 1:numSeq
    if ismember(ii,pairingSig.t)
        idx = ii == pairingSig.t;
        numTracks = pairingSig.pairing(idx);
        if numTracks == 1
            pairingPlotBMP(1,ii,:) = params.pairingColor;
        else
            pairingPlotBMP(1,ii,:) = params.otherColor;
        end
    else
        pairingPlotBMP(1,ii,:) = params.otherColor;
    end
end

pairingPlotBMP = repmat(pairingPlotBMP,params.pairingHeight,1, 1, 1);
pairingPlotBMP = uint8(pairingPlotBMP);