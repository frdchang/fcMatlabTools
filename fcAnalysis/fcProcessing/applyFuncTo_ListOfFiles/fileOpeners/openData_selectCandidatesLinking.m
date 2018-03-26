function [ inputs ] = openData_selectCandidatesLinking( varargin )
%OPENDATA_SELECTCANDIDATES Summary of this function goes here
%   Detailed explanation goes here



switch numel(varargin)
    case 1
        inputs = {varargin{1}};
    case 2
        inputs = {varargin{1},'fieldThresh',varargin{2}};
    case 3
        inputs = {{varargin{1},varargin{2}},'fieldThresh',varargin{3}};
    otherwise
        error('not programmed in');
end
  

