function [ inputs ] = openData_selectCandidates( varargin )
%OPENDATA_SELECTCANDIDATES Summary of this function goes here
%   Detailed explanation goes here

estimated = load(varargin{1});
estimated = estimated.estimated;

if numel(varargin) == 2
   cellmask = importStack(varargin{2}); 
   inputs = {estimated,'useMask',cellmask};
else
    inputs = {estimated};
end


