function [modelSq1,modelSq2,LL1,LL0,LL1SansDataSq,LLRatio] = calcLLRatioManually(data,kern,A1,B1,B0,cameraVariance)
%CALCLLRATIOMANUALLY Summary of this function goes here
%   Detailed explanation goes here
%
% for two channels it was checked to be correct by giving it ground truth
% data and seeing if LL1 = 0 at the proper coordinate.  
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

    function [mymodelSq1,mymodelSq2,myLL1,myLL0,myLL1SansDataSq,myLLRatio] = gpuLLRatioPerPatch(x,y,z)
        xSeg = floor((sizeKern(1)-1)/2);
        ySeg = floor((sizeKern(2)-1)/2);
        zSeg = floor((sizeKern(3)-1)/2);
        xL = max(1,x-xSeg);
        yL = max(1,y-ySeg);
        zL = max(1,z-zSeg);
        xH = min(sizeData(1),x+xSeg);
        yH = min(sizeData(2),y+ySeg);
        zH = min(sizeData(3),z+zSeg);
        
        mymodelSq1 = 0;
        mymodelSq2 = 0;
        myLL1 = 0;
        myLL0 = 0;
        myLL1SansDataSq = 0;
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
                    lambda0  = B0(x,y,z);
                    mymodelSq1 = mymodelSq1 + lambda1.^2;
                    mymodelSq2 = mymodelSq2 + lambda0.^2;
                    % this is poisson poisson approximation
                    sqError1 = ((lambda1 - data(ii,jj,kk))^2)/cameraVariance(ii,jj,kk);
                    sqError2 = ((lambda0 - data(ii,jj,kk))^2)/cameraVariance(ii,jj,kk);
                     myLL1 = myLL1 - sqError1;
                     myLL0 = myLL0 - sqError2;
%                     myLL1 = myLL1 -(lambda1^2 - 2*lambda1*data(ii,jj,kk))/cameraVariance(ii,jj,kk);
%                     myLL0 = myLL0 -(lambda0^2 - 2*lambda0*data(ii,jj,kk))/cameraVariance(ii,jj,kk);
                    myLL1SansDataSq = myLL1SansDataSq - sqError1 +  (data(ii,jj,kk)^2)/cameraVariance(ii,jj,kk);
%                     myLLRatio = myLLRatio  + myLL1 - myLL0;
%   myLLRatio = myLLRatio  + -((lambda1 - data(ii,jj,kk))^2)/cameraVariance(ii,jj,kk) + ((B0(x,y,z)- data(ii,jj,kk))^2)/cameraVariance(ii,jj,kk);
                end
            end
        end
         myLLRatio = myLL1 - myLL0;  % this has more numerical noise for some reason
    end

[modelSq1,modelSq2,LL1,LL0,LL1SansDataSq,LLRatio] = arrayfun(@gpuLLRatioPerPatch,idx,idy,idz);
% note that the output is flipped xy
modelSq1 = gather(permute(modelSq1,[2 1 3]));
modelSq2 = gather(permute(modelSq2,[2 1 3]));
LL1 = gather(permute(LL1,[2 1 3]));
LL0 = gather(permute(LL0,[2 1 3]));
LL1SansDataSq = gather(permute(LL1SansDataSq,[2 1 3]));
LLRatio = gather(permute(LLRatio,[2 1 3]));
end





% myModel = A*spotKern + B;
% myModel2 = B0*ones(size(spotKern));
% modelSq1 = sum(myModel(:).^2);
% modelSq2 = sum(myModel2(:).^2);
% LL1 = -sum((myModel(:)-data(:)).^2);
% LL1SansDataSq = LL1 + sum(data(:).^2);
% LL2 = -sum((myModel2(:)-data(:)).^2);
% LL2SansDataSq = LL2 + sum(data(:).^2);
% LLRatio = LL1 - LL2;
% end

