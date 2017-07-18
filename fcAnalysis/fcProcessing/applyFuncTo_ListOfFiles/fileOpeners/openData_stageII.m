function [ stageIIinputs ] = openData_stageII(varargin )
%OPENDATA_STAGEII Summary of this function goes here
%   Detailed explanation goes here
datas = importStack(varargin{1});

[electronDatas,cameraVarianceInADU] = returnElectronsFromCalibrationFile(datas,varargin{2});

estimated = load(varargin{3});
estimated = estimated.estimated;

candidates = load(varargin{4});
candidates = candidates.funcOutput;

Kmatrix = varargin{5};

psfObjs = varargin{6};

stageIIinputs = {electronDatas',cameraVarianceInADU,estimated,candidates,Kmatrix,psfObjs};
end

