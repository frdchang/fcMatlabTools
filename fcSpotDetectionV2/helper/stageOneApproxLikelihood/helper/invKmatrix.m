function varargout = invKmatrix(invMatrix,varargin)
%INVKMATRIX 

vector = cell2mat(varargin);
out = invMatrix*vector';
out = num2cell(out);
varargout = cell(numel(out),1);
[varargout{:}] = deal(out{:});
end

