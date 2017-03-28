function [estimated] = findSpotsStage1V2(data,spotKern,cameraVariance,varargin)
%FINDSPOTSSTAGE1 will find the MLE of the parameters of two statistical
% models that correspond to 1 spot or 0 spot to every position in the
% dataset using an approximate log likelihood function that accounts for
% pixel to pixel differences in readnoise.  The derivation is located in
% the math supp. ref[] and in the mathematica notebook
% designLikelihoodFilter.nb.
%
% data:             the dataset, or cell array of multi spectral datasets
% spotKern:         the shape data, e.g. psf or gaussian
% cameraVariance:   the read noise in variance.  size of this dataset needs
%                   to be the same size as the data, so extrude
%                   accordingly.   if cameraVariance is a string, this
%                   function will treat it as a path to the camera
%                   calibration file
% varargin{1}:      Kmatrix of spectral bleedthru
%
% model1 - one spot model  - A1*spotKern + B1
% model0 - zero spot model - B0
%
% detected is an output structure with the estimated parameters
% detected.A0:      MLE of A1 of a spot with no background
% detected.A1:      MLE of A1 of 1 spot model
% detected.B1:      MLE of B1 of 1 spot model
% detected.B0:      MLE of B0 of 0 spot model
% detected.LLRatio: approximate log likelihood ratio of model 1 vs model 0
%
% [notes] - this function caches results so next computation is faster.
%           clear findSpotStage1 if memory needs to be opened.
%         - if spot kern is separable and provided as a separable kernel
%           spotKern = {sep1,sep2,sep3}, then separable convolution will be
%           used.
%         - if there is multi spectral datasets, then each dataset is in a
%           cell array.  in this condition varargin must be the bleedthru
%           matrix K.
%         - when using multi spectral datasets, you must pass a
%         multispectral spotKern = {kern1,kern2} corresponding to each
%         dataset
%         - assumes there can only be one camera variance, can be updated
%         in the future
%         - assumes different spectral kernels have the same size
%         - if datasets inputed are gpuArrays, everything runs on the gpu
%           * for multispectral datasets gpu is almost a requirement for
%           computational overhead
%
% fchang@fas.harvard.edu

persistent spotKernSaved;
persistent invVarSaved;
persistent k1;
persistent k3;
persistent k5;
persistent Normalization;

%--parameters--------------------------------------------------------------
params.kMatrix       = [];
params.nonNegativity = true;
params.loadIntoGpu   = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

%% if cameraVariance is a file path to calibration mat file
if ischar(cameraVariance)
    [data,cameraVariance] = returnElectronsFromCalibrationFile(data,cameraVariance);
end

if isempty(cameraVariance)
    if iscell(data)
        cameraVariance = ones(size(data{1}));
    else
        cameraVariance = ones(size(data));
    end
    
end

if ~iscell(data)
    %% data is just a numeric array----------------------------------------
    %% load into gpu if instructed
    if params.loadIntoGpu
        data = gpuArray(data);
        spotKern = gpuArray(spotKern);
        cameraVariance = gpuArray(cameraVariance);
    end
    
    if iscell(spotKern)
        % convolution is separable
        convFunc = @convSeparableND;
        sqSpotKern = cellfunNonUniformOutput(@(x) x.^2,spotKern);
        onesSizeSpotKern = genSeparableOnes(cellfun(@(x) numel(x),spotKern));
    else
        % otherwise just do fft
        convFunc = @convFFTND;
        spotKern = flipAllDimensions(spotKern);
        sqSpotKern = spotKern.^2;
        if isa(data,'gpuArray') && isa(spotKern,'gpuArray') && isa(cameraVariance,'gpuArray')
            onesSizeSpotKern = ones(size(spotKern),'gpuArray');
        else
            onesSizeSpotKern = ones(size(spotKern));
        end
        
    end
    
    % if spotKern or cameraVariance changes, cache the results
    currInvVar = 1./cameraVariance;
    if ~isequal(spotKernSaved,spotKern) || ~isequal(invVarSaved,currInvVar)
        invVarSaved = currInvVar;
        spotKernSaved = spotKern;
        k1 = convFunc(invVarSaved,spotKern);
        k3 = convFunc(invVarSaved,sqSpotKern);
        k5 = convFunc(invVarSaved,onesSizeSpotKern);
        Normalization = k1.^2 - k5.*k3;
    end
    
    dataNormed  = data.*invVarSaved;
    k2          = convFunc(dataNormed,spotKern);
    k4          = convFunc(dataNormed,onesSizeSpotKern);
    %     clear('dataNormed','data');
    % parameters given A*spotKern, model of 1 spot without background
    A0          = k2./ k3;
    % parameters given A*spotKern + B, model of 1 spot
    A1          = (k1.*k4 - k5.*k2 ) ./ Normalization;
    B1          = (k1.*k2 - k3.*k4)  ./ Normalization;
    LL1         = -((B1.^2).*k5 + A1.*(2*B1.*k1 - 2*k2 + A1.*k3) - 2*B1.*k4);
    % parameters given B only, model of 0 spot
    B0          = k4./k5;
    LL0         = -((B0.^2).*k5 - 2*B0.*k4);
    LLRatio     = LL1-LL0;
    
    if isa(data,'gpuArray') && isa(spotKern,'gpuArray') && isa(cameraVariance,'gpuArray')
        LLRatioPoissPoiss = gpuCalcLLRatioPoissPoiss(data,spotKern,A1,B1,B0,cameraVariance);
    end
    
    if params.nonNegativity
        A0(A0<0)      = 0;
        LLRatio(A1<0) = 0;
        if isa(data,'gpuArray') && isa(spotKern,'gpuArray') && isa(cameraVariance,'gpuArray')
            LLRatioPoissPoiss(A1<0) = 0;
        end
        A1(A1<0)      = 0;
        B1(B1<0)      = 0;
    end
    
    A0          = gather(A0);
    A1          = gather(A1);
    B1          = gather(B1);
    B0          = gather(B0);
    LLRatio     = gather(LLRatio);
    spotKern    = gather(spotKernSaved);
    
else
    %% data is multispectral-----------------------------------------------
    % load into gpu if instructed
    
    % make sure spotKern has the same dimensions
    if ~isEveryoneEqual(cellfunNonUniformOutput(@size,spotKern))
        error('multi spectral kernels need to be the same size');
    end
    
    % spotKern must be cell array of kernels for each spectra
    spotKern = reshape(spotKern,numel(spotKern),1);
    data  = reshape(data,numel(data),1);
    if iscell(spotKern{1})
        % convolution is separable
        if params.loadIntoGpu
            data = cellfunNonUniformOutput(@(x) gpuArray(x),data);
            spotKern = cellfunNonUniformOutput(@(x) cellfunNonUniformOutput(@(x) gpuArray(x),x),spotKern);
            cameraVariance = gpuArray(cameraVariance);
        end
        convFunc = @convSeparableND;
        sqSpotKern = cellfunNonUniformOutput(@(y) cellfunNonUniformOutput(@(x) x.^2,y),spotKern);
        onesSizeSpotKern =  genSeparableOnes(cellfun(@(x) numel(x),spotKern{1}));
    else
        % otherwise just do fft
        if params.loadIntoGpu
            data = cellfunNonUniformOutput(@(x) gpuArray(x),data);
            spotKern = cellfunNonUniformOutput(@(x) gpuArray(x),spotKern);
            cameraVariance = gpuArray(cameraVariance);
        end
        convFunc = @convFFTND;
        spotKern = cellfunNonUniformOutput(@(y) flipAllDimensions(y),spotKern);
        sqSpotKern = cellfunNonUniformOutput(@(y) y.^2,spotKern);
        onesSizeSpotKern =  ones(size(spotKern{1}));
    end
    
    % if spotKern or cameraVariance changes, cache the results
    currInvVar = 1./cameraVariance;
    clear('cameraVariance');
    if ~isequal(spotKernSaved,spotKern) || ~isequal(invVarSaved,currInvVar)
        invVarSaved     = currInvVar;
        clear('currInvVar');
        spotKernSaved   = spotKern;
        k1              = cellfunNonUniformOutput(@(x) convFunc(invVarSaved,x),spotKern);
        k3              = cellfunNonUniformOutput(@(x) convFunc(invVarSaved,x),sqSpotKern);
        k5              = convFunc(invVarSaved,onesSizeSpotKern);
    end
    
    if ~isempty(params.kMatrix)
        kMatrix     = params.kMatrix;
    else
        warning('bleed thru Kmatrix not supplied with multi spectral data');
        kMatrix     = eye(numel(data));
    end
    
    dataNormed      = cellfunNonUniformOutput(@(x) x.*invVarSaved,data);
    k2              = cellfunNonUniformOutput(@(x,spotKern) convFunc(x,spotKern),dataNormed,spotKern);
    k4              = cellfunNonUniformOutput(@(x) convFunc(x,onesSizeSpotKern),dataNormed);
    clear('dataNormed','data');
    
    A0              = cellfunNonUniformOutput(@(x,k3) x./k3,k2,k3);
    A0              = gpuApplyInvKmatrix(kMatrix,A0);
    A0              = cellfunNonUniformOutput(@(x) gather(x),A0);
    
    A1              = cellfunNonUniformOutput(@(x,y,k1,k3) (k1.*x - k5.*y ) ./ ( k1.^2 - k5.*k3),k4,k2,k1,k3);
    B1              = cellfunNonUniformOutput(@(x,y,k1,k3) (k1.*x - k3.*y) ./  (k1.^2 - k5.*k3),k2,k4,k1,k3);
    LL1             = cellfunNonUniformOutput(@(B1,A1,k1,k2,k3,k4) -((B1.^2).*k5 + A1.*(2*B1.*k1 - 2*k2 + A1.*k3) - 2*B1.*k4),B1,A1,k1,k2,k3,k4);
    LL1             = cellfunNonUniformOutput(@(x) gather(x),LL1);
    
    A1              = gpuApplyInvKmatrix(kMatrix,A1);
    A1              = cellfunNonUniformOutput(@(x) gather(x),A1);
    B1              = gpuApplyInvKmatrix(kMatrix,B1);
    B1              = cellfunNonUniformOutput(@(x) gather(x),B1);
    
    B0              = cellfunNonUniformOutput(@(k4) k4./k5,k4);
    LL0             = cellfunNonUniformOutput(@(B0,k4) -((B0.^2).*k5 - 2*B0.*k4),B0,k4);
    LL0             = cellfunNonUniformOutput(@(x) gather(x),LL0);
    LLRatio         = sumCellContents(LL1) - sumCellContents(LL0);
    clear('LL1','LL0');
    
    B0              = gpuApplyInvKmatrix(kMatrix,B0);
    B0              = cellfunNonUniformOutput(@(x) gather(x),B0);
    
    spotKern        = cellfunNonUniformOutput(@(x) gather(x),spotKernSaved);
    
    if params.nonNegativity
        selectNegVals = cellfunNonUniformOutput(@(x) x<0,A1);
        selectNegVals = multiCellContents(selectNegVals);
        LLRatio(selectNegVals>0) = 0;
        for ii = 1:size(kMatrix,2)
            A0{ii}(A0{ii}<0) = 0;
            A1{ii}(A1{ii}<0) = 0;
            B1{ii}(B1{ii}<0)=0;
        end
    end
end

estimated.A0         = A0;
estimated.A1         = A1;
estimated.B1         = B1;
estimated.B0         = B0;
estimated.LLRatio    = LLRatio;
if exist('LLRatioPoissPoiss','var') == 1
    estimated.LLRatioPoissPoiss = LLRatioPoissPoiss;
end
estimated.spotKern   = spotKern;
