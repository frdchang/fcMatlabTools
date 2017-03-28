function  squaredCompLL0  = calcModelSquaredForLL0(Kmatrix,B0,k5)
%CALCMODELSQUAREDFORLL0 Summary of this function goes here
%   Detailed explanation goes here
    squaredCompLL0 = 0;
    for ii = 1:size(Kmatrix,2)
        squaredCompTemp = 0;
        for jj = 1:size(Kmatrix,2)
            squaredCompTemp = squaredCompTemp+ Kmatrix(ii,jj)*B0{jj};
        end
        squaredCompLL0 = squaredCompLL0 + (squaredCompTemp.^2).*k5;
    end



