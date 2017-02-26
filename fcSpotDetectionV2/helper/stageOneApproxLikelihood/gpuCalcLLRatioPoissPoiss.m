function LLRatio = gpuCalcLLRatioPoissPoiss(data,kern,A1,B1,B0,cameraVariance)
%GPUCALCLLRATIO will calculate the LLRatio using arrayfun using Poisson
%Poisson Approximation


sizeData = size(data);
sizeKern = size(kern);
% data = gpuArray(data);
% kern = gpuArray(kern);
% A1 = gpuArray(A1);
% B1 = gpuArray(B1);
% B0 = gpuArray(B0);
% cameraVariance = gpuArray(cameraVariance);

idx = gpuArray([1:sizeData(1)]);
idy = gpuArray([1:sizeData(2)]');
idz = gpuArray(reshape([1:sizeData(3)],1,1,sizeData(3)));

    function myLLRatio = gpuLLRatioPerPatch(x,y,z)
        xSeg = floor((sizeKern(1)-1)/2);
        ySeg = floor((sizeKern(2)-1)/2);
        zSeg = floor((sizeKern(3)-1)/2);
        xL = max(1,x-xSeg);
        yL = max(1,y-ySeg);
        zL = max(1,z-zSeg);
        xH = min(sizeData(1),x+xSeg);
        yH = min(sizeData(2),y+ySeg);
        zH = min(sizeData(3),z+zSeg);
        
        myLLRatio = 0;
        for ii = xL:xH
            for jj = yL:yH
                for kk = zL:zH
                    % this appendment is because when the kernel is at the
                    % upper left corner and you have to correct the
                    % coordinates being read out
                    if (x-xSeg-1) < 0
                        xAppend = -(x-xSeg-1);
                    else
                        xAppend = 0;
                    end
                    
                    if (y-ySeg-1) < 0
                        yAppend = -(y-ySeg-1);
                    else
                        yAppend = 0;
                    end
                    
                    if (z-zSeg-1) < 0
                        zAppend = -(z-zSeg-1);
                    else
                        zAppend = 0;
                    end
                    lambda1  = A1(x,y,z)*kern(ii-xL+1+xAppend,jj-yL+1+yAppend,kk-zL+1+zAppend) + B1(x,y,z);
                    lambda0 = B0(x,y,z);
                    % this is poisson poisson approximation
                    myLLRatio = myLLRatio + -lambda1 + (data(ii,jj,kk)+cameraVariance(ii,jj,kk))*log(lambda1+cameraVariance(ii,jj,kk)) - (-lambda0 + (data(ii,jj,kk)+cameraVariance(ii,jj,kk))*log(lambda0+cameraVariance(ii,jj,kk)));
%                     myLLRatio = myLLRatio  + -((A1(x,y,z)*kern(ii-xL+1+xAppend,jj-yL+1+yAppend,kk-zL+1+zAppend) + B1(x,y,z)- data(ii,jj,kk))^2)/cameraVariance(ii,jj,kk) + ((B0(x,y,z)- data(ii,jj,kk))^2)/cameraVariance(ii,jj,kk);
                end
            end
        end
    end

LLRatio = arrayfun(@gpuLLRatioPerPatch,idx,idy,idz);
% note that the output is flipped xy
LLRatio = permute(LLRatio,[2 1 3]);
LLRatio = gather(LLRatio);
end