function psfDataStruct = genPSF(varargin)
%genPSF generates a PSF from a Gibson Lanni vectorial model of the
%   microscope
%   CFI Plan Achromat lambda 60x NA 1.4 WD 0.13
%   CFI Plan Achromat lambda 100x NA 1.45 WD 0.13


%--parameters--------------------------------------------------------------
% normalization settings
params.normType     = 2;                            % normType = 0; no normalization
% normType = 1; normalize by Sum = 1
% normType = 2; normalize by Peak = 1
% microscope settings
params.Ti0          = 1.3000e-04;                   % Ti0       : working distance of the objective                                             (Nikon 60x Lambda = 0.14mm)
params.Ni0          = 1.5180;                       % Ni0       : immersion medium refractive index, design value
params.Ni           = 1.5180;                       % Ni        : immersion medium refractive index, experimental value
params.Tg0          = 1.7000e-04;                   % Tg0       : coverslip thickness, design value
params.Tg           = 1.7000e-04;                   % Tg        : coverslip thickness, experimental value
params.Ng0          = 1.5150;                       % Ng0       : coverslip refractive index, design value
params.Ng           = 1.5150;                       % Ng        : coverslip refractive index, experimental value
params.Ns           = 1.5150;                       % Ns        : sample refractive index
params.lambda       = 5.500e-07;                    % lambda    : emission wavelength
params.M            = 60;                           % M         : magnification                                                                 (Nikon 60x Lambda)
params.NA           = 1.400;                        % NA        : numerical aperture                                                            (Nikon 60x Lambda = 1.4)
params.alpha        = asin(params.NA/params.Ni);    % alpha     : angular aperture, alpha = atan(NA/Ni)
params.pixelSize    = 6.5e-06;                      % pixelSize : physical size (width) of the CCD pixels                                       (Hamamatsu Flash V2 = 6.5 microns)
params.f            = 3;                            % f         : (optional, default: 3) oversampling factor to approximate CCD integration
params.mode         = 1;                            % mode      : (optional, default: 1) if mode = 0, returns oversampled PSF
% default position of the PSF
params.xp           = 0;
params.yp           = 0;
params.zp           = 0;
params.ru           = 13;
% default zstep parameters
params.dz           = 0.25e-6;
params.zSteps       = 25;
params.z0           = -2e-6;
% threshold the psf, if so, put threshold value
params.thresh       = []; %0.0002;
% plot line profiles
params.plotProfiles = true;
% fit gaussian shape
params.fitGauss     = true;
% only output psf for single output argument
params.onlyPSF      = true;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

%% generate the zSteps centered at the PSF
if params.mode ==0
    % this means oversampled psf is requested so return oversampled z also
    params.zSteps = params.zSteps*params.f;
    params.dz     = params.dz/params.f;
    
end

% for some reasons params.f needs to be odd
if mod(params.f,2) ~= 1
   error('f needs to be odd'); 
end
z = params.z0:params.dz:(params.z0 + params.dz*(params.zSteps-1));
% this is the parameter structure that vectorialPSF needs, values are not
% important.
p=struct('Ti0',1.3000e-04,'Ni0', 1.5180,'Ni',1.5180, 'Tg0', 1.7000e-04,...
    'Tg', 1.7000e-04, 'Ng0', 1.5150, 'Ng', 1.5150, 'Ns' , 1.33,...
    'lambda',5.5000e-07, 'M' , 100, 'NA' , 1.400, 'alpha', 0, 'pixelSize', 10.0e-06,'f',3,'mode',1);

psfData = vectorialPSF(params.xp, params.yp, params.zp, z, params.ru, curateStruct(p,params));
% normalize psfData
switch params.normType
    case 1
        psfData = psfData ./ sum(psfData(:));
        
    case 2
        psfData = psfData ./ max(psfData(:));
    otherwise
        error('this normType is not expected');
end

%% generate nd PSF
if ~isempty(params.thresh)
    psfData = threshPSF(psfData,params.thresh);
end

if params.onlyPSF
    psfDataStruct = psfData;
    return;
else
    psfDataStruct.glPSF = psfData;
end

%% fit gaussian
if params.fitGauss
    % generate line profiles from the brighteset pixel in all cardinal
    % directions
    maxCoor = cell2mat(ind2subND(size(psfData),find(psfData==max(psfData(:)),1)));
    profileBasket = cell(numel(maxCoor),1);
    for i = 1:numel(maxCoor)
        startLine = maxCoor;
        endLine   = maxCoor;
        startLine(i) = 1;
        endLine(i) = size(psfData,i);
        profileBasket{i} = getNDLineProfile(psfData,{startLine,endLine});
        profileBasket{i} = profileBasket{i}{:};
    end
    % fit gaussians to all of the profiles
    fitBasket = cell(numel(maxCoor),1);
    for i = 1:numel(maxCoor)
        fitBasket{i} = fit([1:numel(profileBasket{i})]',profileBasket{i},'gauss1');
    end
    % generate gaussian kernel approximation
    sigmaBasket = zeros(numel(maxCoor),1);
    for i = 1:numel(maxCoor)
        sigmaBasket(i) = sqrt(((fitBasket{i}.c1)^2)/2);
    end
    psfDataStruct.gaussKern = ndGauss(sigmaBasket.^2,size(psfData));
    switch params.normType
        case 1
            psfDataStruct.gaussKern = psfDataStruct.gaussKern ./ sum(psfDataStruct.gaussKern(:));
            
        case 2
            psfDataStruct.gaussKern = psfDataStruct.gaussKern ./ max(psfDataStruct.gaussKern(:));
        otherwise
            error('this normType is not expected');
    end
    psfDataStruct.gaussSigmas = sigmaBasket;
end

%% plot line profiles from fit
if params.plotProfiles
    % see how well it fits
    for i = 1:numel(maxCoor)
        figure;
        title('line profile');
        plot(fitBasket{i},1:numel(profileBasket{i}),profileBasket{i});
    end
    plot3Dstack(psfData,'text','psf');
    plot3Dstack(psfDataStruct.gaussKern,'text','guassian approximation');
end
specimenStepSize = params.pixelSize / params.M;

[xx,yy,zz] = ndgrid( 0:specimenStepSize:specimenStepSize*(size(psfData,1)-1), 0:specimenStepSize:specimenStepSize*(size(psfData,2)-1),z);
psfDataStruct.domains = {xx,yy,zz};

% %% 
% [xx,yy,zz] = meshgrid( 0:specimenStepSize:specimenStepSize*(size(psfData,1)-1), 0:specimenStepSize:specimenStepSize*(size(psfData,2)-1),z);
% %% 






