function sampledData = genMicroscopeNoise(trueData,varargin)
%GENMICROSCOPENOISE will take trueData as the poisson level, and sample it
%   in a poisson distribution, then add gaussian read noise to simulate a
%   typical microscope with a scmos or ccd camera.
%   
%   note for fred: in the future if the user provides a string file link
%   for a parameter, load that dataset in for that parameter, this will
%   allow for real calibrated microscope parameters.
%
%   note for fred: parameters are just placeholders, go make sure they are
%   correct in the future.

%--parameters--------------------------------------------------------------
params.readNoise     = 1.6;     % electrons (sigma)
params.gain          = 2.1;     % ADU/electrons
params.offset        = 100;     % ADU units
params.QE            = 0.7;     
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% lambda photons to lambda electrons captured
sampledData = double(trueData)*params.QE;
% quantum noise 
sampledData = poissrnd(sampledData);
% read noise
sampledData = sampledData + normrnd(0,params.readNoise,size(trueData));
% convert from electrons to ADU
sampledData = sampledData.*params.gain + params.offset;
end

