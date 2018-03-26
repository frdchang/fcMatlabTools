function crossCompLL1 = calcModelCrossForLL1(Kmatrix,A1,B1,k2,k4)
%CALCMODELCROSSFORLL1 Summary of this function goes here
%   Detailed explanation goes here

crossCompLL1   = 0;
for ii = 1:size(Kmatrix,2)
    for jj = 1:size(Kmatrix,2)
        crossCompLL1 = crossCompLL1 + Kmatrix(ii,jj)*( -2*A1{jj}.*k2{ii} - 2*B1{jj}.*k4{ii});
    end
end


