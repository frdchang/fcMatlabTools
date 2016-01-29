function psfData = genPSF(varargin)
%genPSF generates a PSF from a Gibson Lanni vectorial model of the
%   microscope
%   usefule equations
%       1) lateral freq cutoff  = 2*NA / lambda
%       2) depth freq cutoff    = n*(1-cos(a)) / lambda
%       3) FWHM                 = 0.353*lambda / NA  (units?)
%       4) Gaussian sigma       = FWHM / 2.355

%--parameters-------------------------------------------------------------- 







% Ns        : sample refractive index
% lambda    : emission wavelength
% M         : magnification
% NA        : numerical aperture
% alpha     : angular aperture, alpha = atan(NA/Ni)
% pixelSize : physical size (width) of the CCD pixels
% f         : (optional, default: 3) oversampling factor to approximate CCD integration
% mode      : (optional, default: 1) if mode = 0, returns oversampled PSF
% microscope settings
params.Ti0          = 1.3000e-04;                   % Ti0       : working distance of the objective
params.Ni0          = 1.5180;                       % Ni0       : immersion medium refractive index, design value
params.Ni           = 1.5180;                       % Ni        : immersion medium refractive index, experimental value
params.Tg0          = 1.7000e-04;                   % Tg0       : coverslip thickness, design value
params.Tg           = 1.7000e-04;                   % Tg        : coverslip thickness, experimental value
params.Ng0          = 1.5150;                       % Ng0       : coverslip refractive index, design value
params.Ng           = 1.5150;                       % Ng        : coverslip refractive index, experimental value
params.Ns           = 1.33;
params.lambda       = 5.500e-07;
params.M            = 100;
params.NA           = 1.400;
params.alpha        = asin(params.NA/params.Ni);
params.pixelSize    = 10.0e-06;
params.f            = 3;
params.mode         = 1;
% default position of the PSF
params.xp           = 0;
params.yp           = 0;
params.zp           = 0;
% calculating ru
FWHM = (0.353*params.lambda)/params.NA;
sigma = FWHM/2.355;
specimenPixelSize = params.pixelSize / params.M;
pixelSigma = sigma / specimenPixelSize;
params.ru           = 20;
% default zstep parameters
params.dz           = 0.25e-6;
params.zSteps       = 25;
params.z0           = 0;
% threshold the psf, if so, put threshold value
params.thresh       = 0.0001;
% plot line profiles
params.plotProfiles = true;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

%% generate the zSteps centered at the PSF 
bounds = params.dz*(params.zSteps - 1)/2;
z = linspace(params.z0 - bounds, params.z0 + bounds, params.zSteps);
% this is the parameter structure that vectorialPSF needs, values are not
% important.
p=struct('Ti0',1.3000e-04,'Ni0', 1.5180,'Ni',1.5180, 'Tg0', 1.7000e-04,...
    'Tg', 1.7000e-04, 'Ng0', 1.5150, 'Ng', 1.5150, 'Ns' , 1.33,...
    'lambda',5.5000e-07, 'M' , 100, 'NA' , 1.400, 'alpha', 0, 'pixelSize', 10.0e-06,'f',3,'mode',1);

psfData = vectorialPSF(params.xp, params.yp, params.zp, z, params.ru, curateStruct(p,params));
% normalize psfData
psfData = psfData ./ sum(psfData(:));

%% generate nd PSF
if ~isempty(params.thresh)
    psfData = getSubsetwBBoxND(psfData,selectCenterBWObj(psfData > params.thresh));
end

%% generate line profiles
if params.plotProfiles
    maxCoor = ind2subND(size(psfData),find(psfData==max(psfData(:)),1));
    for i = 1:numel(maxCoor)
        
    end
end
end