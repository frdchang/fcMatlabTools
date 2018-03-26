function [hSig,hBk ] = histSigBkgnd(sig,bkgnd,varargin)
%MYHISTOGRAM is a wrapper for MATLABs histogram, but it does one additional
%thing.  it bins the inf values.
%--parameters--------------------------------------------------------------
params.NumBinsMAX     = 1000;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

hBk  = histogram(bkgnd);
hold on;
hSig = histogram(sig);

if hBk.NumBins > params.NumBinsMAX
    hBk.NumBins = params.NumBinsMAX;
end

if hSig.NumBins > params.NumBinsMAX
    hSig.NumBins = params.NumBinsMAX;
end


if all(sig==inf)
    hSig.BinEdges = [hBk.BinEdges(end) inf];
    hBk.BinEdges  = [hBk.BinEdges inf];
else
    hBk.BinEdges  = [hBk.BinEdges inf];
    hSig.BinEdges = [hSig.BinEdges inf];
end

end

