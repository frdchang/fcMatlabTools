function [ restHess ] = calcABHessianFilter(data,est,kern,kernDs,kernD2s,cameraVariance)
%CALCHESSIAN Summary of this function goes here
%   Detailed explanation goes here

convF        = @convFFTND;
kern         = flipAllDimensions(kern);
onesSizeKern = ones(size(kern));
kernSq       = kern.^2;
kernDs       = cellfunNonUniformOutput(@(x) flipAllDimensions(x),kernDs);
%kernD2s      = cellfunNonUniformOutput(@(x) flipAllDimensions(x),kernD2s);
invVar2      = 1./cameraVariance;
invVar4      = 1./cameraVariance.^2;
dataN2       = data.*invVar2;
dataN4       = data.*invVar4;

restHess = cell(5,5);
% A,A
restHess{1,1} = -convF(dataN4,kernSq) - convF(invVar2,kernSq);
% A,B
restHess{1,2} = -convF(dataN4,kern) - convF(invVar2,kern);
% B,B
restHess{2,2} = -convF(dataN4,onesSizeKern) - convF(invVar2,onesSizeKern);
% A,{x,y,z}
for ii = 1:3
    restHess{1,2+ii} = ...
        - (est.B1.^2).*convF(invVar4,kernDs{ii}) ...
        - 2*est.A1.*est.B1.*convF(invVar4,kernDs{ii}.*kern) ...
        - (est.A1.^2).*convF(invVar4,kernDs{ii}.*kernSq) ...
        + est.B1.*convF(dataN4,kernDs{ii}) ...
        - est.B1.*convF(invVar2,kernDs{ii}) ...
        - 2*est.A1.*convF(invVar2,kernDs{ii}.*kern) ...
        + convF(dataN2,kernDs{ii}); 
end

% B,{x,y,z}
for ii = 1:3
   restHess{2,2+ii} = ...
       - est.A1.*convF(dataN4,kernDs{ii}) ...
       - est.A1.*convF(invVar2,kernDs{ii});
end