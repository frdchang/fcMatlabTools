function [myPSF] = make3DPSF(varargin)
%MAKE3DPSF generates a PSF from a vectorial model of the microscope.

% default parameters-------------------------------------------------------
fcTools = myParams();
p.Ti0       = fcTools.params.make3DPSF.p.Ti0;
p.Ni0       = fcTools.params.make3DPSF.p.Ni0;
p.Ni        = fcTools.params.make3DPSF.p.Ni;
p.Tg0       = fcTools.params.make3DPSF.p.Tg0;
p.Tg        = fcTools.params.make3DPSF.p.Tg;
p.Ng0       = fcTools.params.make3DPSF.p.Ng0;
p.Ng        = fcTools.params.make3DPSF.p.Ng;
p.Ns        = fcTools.params.make3DPSF.p.Ns;
p.lambda    = fcTools.params.make3DPSF.p.lambda;
p.M         = fcTools.params.make3DPSF.p.M;
p.NA        = fcTools.params.make3DPSF.p.NA;
p.alpha     = asin(p.NA/p.Ni);
p.pixelSize = fcTools.params.make3DPSF.p.pixelSize;
p.f         = fcTools.params.make3DPSF.p.f;
p.mode      = fcTools.params.make3DPSF.p.mode;
tubeMag     = fcTools.params.make3DPSF.tubeMag;
p.M         = p.M*tubeMag;
% default position of the PSF
xp          = fcTools.params.make3DPSF.xp;
yp          = fcTools.params.make3DPSF.yp;
zp          = fcTools.params.make3DPSF.zp;
ru          = fcTools.params.make3DPSF.ru;
% default zstep parameters
dz          = fcTools.params.make3DPSF.dz;
zSteps      = fcTools.params.make3DPSF.zSteps;
%--------------------------------------------------------------------------

% user parameters----------------------------------------------------------
para = inputParser;
para.addParamValue('Ti0', p.Ti0, @isscalar);
para.addParamValue('Ni0', p.Ni0, @isscalar);
para.addParamValue('Ni', p.Ni, @isscalar);
para.addParamValue('Tg0', p.Tg0, @isscalar);
para.addParamValue('Tg', p.Tg, @isscalar);
para.addParamValue('Ng0', p.Ng0, @isscalar);
para.addParamValue('Ng', p.Ng, @isscalar);
para.addParamValue('Ns', p.Ns, @isscalar);
para.addParamValue('lambda', p.lambda, @isscalar);
para.addParamValue('M', p.M, @isscalar);
para.addParamValue('NA', p.NA, @isscalar);
para.addParamValue('alpha', p.alpha, @isscalar);
para.addParamValue('pixelSize', p.pixelSize, @isscalar);
para.addParamValue('f', p.f, @isscalar);
para.addParamValue('mode', p.mode, @isscalar);
% position of the PSF
para.addParamValue('xp', xp, @isscalar);
para.addParamValue('yp', yp, @isscalar);
para.addParamValue('zp', zp, @isscalar);
para.addParamValue('ru', ru, @isscalar);
% zstep parameters
para.addParamValue('dz', dz, @isscalar);
para.addParamValue('zSteps', zSteps, @isscalar);
% threshold value
para.addParamValue('thresh', [], @isscalar);

para.parse(varargin{:});
input = para.Results;
p.Ti0 = input.Ti0;
p.Ni0 = input.Ni0;
p.Ni = input.Ni;
p.Tg0 = input.Tg0;
p.Tg = input.Tg;
p.Ng0 = input.Ng0;
p.Ng = input.Ng;
p.Ns = input.Ns;
p.lambda = input.lambda;
p.M = input.M;
p.NA = input.NA;
p.alpha = input.alpha;
p.pixelSize = input.pixelSize;
p.f = input.f;
p.mode = input.mode;
xp = input.xp;
yp = input.yp;
zp = input.zp;
ru = input.ru;
dz = input.dz;
zSteps = input.zSteps;
thresh = input.thresh;
%--------------------------------------------------------------------------

% make sure zSteps are odd so centered PSF has a slice
zSteps = zSteps + ~mod(zSteps,2);
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