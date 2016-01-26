function psfData = genPSF(varargin)
%genPSF generates a PSF from a Gibson Lanni vectorial model of the
%   microscope

%--parameters--------------------------------------------------------------
% microscope settings
params.Ti0          = 1.3000e-04;
params.Ni0          = 1.5180;
params.Ni           = 1.5180;
params.Tg0          = 1.7000e-04;
params.Tg           = 1.5150;
params.Ng0          = 1.5150;
params.Ng           = 1.5150;
params.Ns           = 1.46;
params.lambda       = 5.8100e-07;
params.M            = 60;
params.NA           = 1.4500;
params.alpha        = asin(params.NA/params.Ni);
params.pixelSize    = 16e-06/4;
params.f            = 5;
params.mode         = 1;
% default position of the PSF
params.xp           = 0;
params.yp           = 0;
params.zp           = 0;
params.ru           = 4*20;
% default zstep parameters
params.dz           = 0.25e-6;
params.zSteps       = 25;        
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% make sure zSteps are odd so centered PSF has a slice
params.zSteps = params.zSteps + ~mod(params.zSteps,2);
% generate the zSteps centered at the PSF 
bounds = dz*(zSteps-1)/2;
z = linspace(zp + bounds, zp - bounds, zSteps);
myPSF = vectorialPSF(xp, yp, zp, z, ru, p);
myPSF = myPSF / sum(myPSF(:));

if ~isempty(thresh)
    if ndims(myPSF)==2
        [xs,ys] = ind2sub(size(myPSF),find(myPSF > thresh));
    elseif ndims(myPSF)==3
        [xs,ys,zs] = ind2sub(size(myPSF),find(myPSF > thresh));
        xmin = min(xs);
        xmax = max(xs);
        ymin = min(ys);
        ymax = max(ys);
        zmin = min(zs);
        zmax = max(zs);
        myPSF = myPSF(xmin:xmax,ymin:ymax,zmin:zmax);
        myPSF = myPSF / sum(myPSF(:));
    else
        error('PSF calculated is not dimensions 2 or 3');
    end
end
end