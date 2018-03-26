function coors = representativeSampling(data,varargin)
%REPRESENTATIVESAMPLING will generate samples that correspond to the
%intensity of data.
% if you give it the mask, it will sample within the mask
data = data / sum(data(:));
Nmax = 1000;
if isempty(varargin)
    % make sure data has density
    if sum(data(:) > 0) > 0
        indices = randsample(1:numel(data),Nmax,true,data(:));
        coors = ind2subND(size(data),indices);
        coors = cell2mat(coors);
    else
        coors = [];
    end
else
    % make sure data has density
    mask = varargin{1};
    idxMask = find(mask==1);
    data = data(idxMask);
    
    if sum(data > 0) > 0
        indices = randsample(idxMask,Nmax,true,data);
        coors = ind2subND(size(data),indices);
        coors = cell2mat(coors);
    else
        coors = [];
    end
    
    
end
