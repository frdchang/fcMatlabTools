function h = plotMontage(SubV)
%PLOTMONTAGE Summary of this function goes here
%   Detailed explanation goes here

h = montage(reshape(SubV,[size(SubV,1), size(SubV,2), 1, size(SubV,3)]),'DisplayRange',[]);

end

