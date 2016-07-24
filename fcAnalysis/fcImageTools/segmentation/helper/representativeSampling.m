function coors = representativeSampling(data)
%REPRESENTATIVESAMPLING will generate samples that correspond to the
%intensity of data.
data = data / sum(data(:));

Nmax = 1000;
% make sure data has density
if sum(data(:) > 0) > 0
    indices = randsample(1:numel(data),Nmax,true,data(:));
    coors = ind2subND(size(data),indices);
    coors = cell2mat(coors);
else
    coors = [];
end
