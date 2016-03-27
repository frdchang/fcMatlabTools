function [BBox] = genBBoxWholeThing(data)
%GENBBOXWHOLETHING generates a BBox that encapsulates the whole data set
%
% fchang@fas.harvard.edu

sizeInput = size(data);
% note that the x and y indices are flipped
indices = 1:numel(sizeInput);
indices(2) = 1;
indices(1) = 2;
BBox = [0.5*ones(1,numel(sizeInput)) sizeInput(indices)];


end

