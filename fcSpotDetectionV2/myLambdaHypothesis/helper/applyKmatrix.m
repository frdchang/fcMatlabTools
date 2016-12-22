function varargout = applyKmatrix(Kmatrix,littleLambdas,varargin)
%APPLYKMATRIX will apply the spectral bleed thru coefficient to the little
%lambdas

numDatas = size(Kmatrix,2);
varargout = cell(numDatas,1);

