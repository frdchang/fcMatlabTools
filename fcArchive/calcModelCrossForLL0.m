function crossCompLL0 = calcModelCrossForLL0(Kmatrix,B0,k4)
%CALCMODELCROSSFORLL0 Summary of this function goes here
%   Detailed explanation goes here

    crossCompLL0 = 0;
    for ii = 1:size(Kmatrix,2)
        for jj = 1:size(Kmatrix,2)
            crossCompLL0 = crossCompLL0 - 2*Kmatrix(ii,jj).*B0{jj}.*k4{ii};
        end 
    end


