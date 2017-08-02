function [ inputs ] = openData_selectCandidates( varargin )
%OPENDATA_SELECTCANDIDATES Summary of this function goes here
%   Detailed explanation goes here

estimated = load(varargin{1});
estimated = estimated.estimated;

switch numel(varargin)
    case 1
        
    case 2
        cellmask = importStack(varargin{2}); 
        inputs = {estimated,'useMask',cellmask};
    case 3
        cellmask = importStack(varargin{2}); 
        threshold = varargin{3}; 
        inputs = {estimated,'useMask',cellmask,'fieldThresh',threshold};
    otherwise
        error('not programmed in');
end
  

