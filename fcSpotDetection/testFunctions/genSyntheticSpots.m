function syntheticSpots = genSyntheticSpots(spotParams,varargin)
%GENSYNTHETICSPOTS generates a synthetic fluorescent spot dataset given a
%list of spotParams = {{x1,y1,z1,a1},{x2,y2,z2,a2},...}.  parameter
%arguments are also passed to the function genMicroscopeNoise, so you can
%adjust the microscope noise parameters from this function as well.

%--parameters--------------------------------------------------------------
params.dataSetSize     = [100,100,10];
params.bkgndValues     = 10*ones(params.dataSetSize);
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% generate true dataset given spotParams

syntheticSpots = genMicroscopeNoise(syntheticSpots,varargin{:});




end

