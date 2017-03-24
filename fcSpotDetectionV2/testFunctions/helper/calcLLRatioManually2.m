function [modelSq1,modelSq2,LL1,LL0,LL1SansDataSq,LLRatio,crossTerms1] = calcLLRatioManually2(data1,data2,kern1,kern2,A1a,A1b,B1a,B1b,B0a,B0b,cameraVariance,Kmatrix)
%CALCLLRATIOMANUALLY Summary of this function goes here
%   Detailed explanation goes here

sizeData = size(data1);
sizeKern = size(kern1);
% data = gpuArray(data);
% kern = gpuArray(kern);
% A1 = gpuArray(A1);
% B1 = gpuArray(B1);
% B0 = gpuArray(B0);
% cameraVariance = gpuArray(cameraVariance);

idx = gpuArray([1:sizeData(1)]);
idy = gpuArray([1:sizeData(2)]');
idz = gpuArray(reshape([1:sizeData(3)],1,1,sizeData(3)));

    function [mymodelSq1,mymodelSq2,myLL1,myLL0,myLL1SansDataSq,myLLRatio,mycrossTerms1] = gpuLLRatioPerPatch(x,y,z)
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
        mycrossTerms1 = 0;
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
                    lambda1_1  = Kmatrix(1)*(A1a(x,y,z)*kern1(ii-xL+1+xAppend,jj-yL+1+yAppend,kk-zL+1+zAppend) + B1a(x,y,z));
                    lambda1_2  = Kmatrix(2)*(A1a(x,y,z)*kern2(ii-xL+1+xAppend,jj-yL+1+yAppend,kk-zL+1+zAppend) + B1a(x,y,z));
                    lambda1_3  = Kmatrix(3)*(A1b(x,y,z)*kern1(ii-xL+1+xAppend,jj-yL+1+yAppend,kk-zL+1+zAppend) + B1b(x,y,z));
                    lambda1_4  = Kmatrix(4)*(A1b(x,y,z)*kern2(ii-xL+1+xAppend,jj-yL+1+yAppend,kk-zL+1+zAppend) + B1b(x,y,z));
                    
                    lambda0_1  = Kmatrix(1)*B0a(x,y,z);
                    lambda0_2  = Kmatrix(2)*B0a(x,y,z);
                    lambda0_3  = Kmatrix(3)*B0b(x,y,z);
                    lambda0_4  = Kmatrix(4)*B0b(x,y,z);
                    
                    mymodelSq1 = mymodelSq1 + (lambda1_1  + lambda1_2  + lambda1_3  + lambda1_4)^2;
                    mymodelSq2 = mymodelSq2 + (lambda0_1  + lambda0_2  + lambda0_3  + lambda0_4)^2;
                    
                    mycrossTerms1 = mycrossTerms1 - 2*lambda1_1*(data1(ii,jj,kk)^2)/cameraVariance(ii,jj,kk) - 2*lambda1_3*(data1(ii,jj,kk)^2)/cameraVariance(ii,jj,kk) - 2*lambda1_2*(data2(ii,jj,kk)^2)/cameraVariance(ii,jj,kk)- 2*lambda1_4*(data2(ii,jj,kk)^2)/cameraVariance(ii,jj,kk);
                    % this is poisson poisson approximation
                    sqError1 = ((lambda1_1 + lambda1_3 - data1(ii,jj,kk))^2)/cameraVariance(ii,jj,kk) + ((lambda1_2 + lambda1_4 - data2(ii,jj,kk))^2)/cameraVariance(ii,jj,kk);
                    sqError2 = ((lambda0_1 + lambda0_3 - data1(ii,jj,kk))^2)/cameraVariance(ii,jj,kk) + ((lambda0_2 + lambda0_4 - data2(ii,jj,kk))^2)/cameraVariance(ii,jj,kk);
                     myLL1 = myLL1 - sqError1;
                     myLL0 = myLL0 - sqError2;
%                     myLL1 = myLL1 -(lambda1^2 - 2*lambda1*data(ii,jj,kk))/cameraVariance(ii,jj,kk);
%                     myLL0 = myLL0 -(lambda0^2 - 2*lambda0*data(ii,jj,kk))/cameraVariance(ii,jj,kk);
                    myLL1SansDataSq = myLL1SansDataSq - sqError1 +  (data1(ii,jj,kk)^2)/cameraVariance(ii,jj,kk) +  (data2(ii,jj,kk)^2)/cameraVariance(ii,jj,kk);
%                     myLLRatio = myLLRatio  + myLL1 - myLL0;
%   myLLRatio = myLLRatio  + -((lambda1 - data(ii,jj,kk))^2)/cameraVariance(ii,jj,kk) + ((B0(x,y,z)- data(ii,jj,kk))^2)/cameraVariance(ii,jj,kk);
                end
            end
        end
         myLLRatio = myLL1 - myLL0;  % this has more numerical noise for some reason
    end

[modelSq1,modelSq2,LL1,LL0,LL1SansDataSq,LLRatio,crossTerms1] = arrayfun(@gpuLLRatioPerPatch,idx,idy,idz);
% note that the output is flipped xy
modelSq1 = gather(permute(modelSq1,[2 1 3]));
modelSq2 = gather(permute(modelSq2,[2 1 3]));
LL1 = gather(permute(LL1,[2 1 3]));
LL0 = gather(permute(LL0,[2 1 3]));
LL1SansDataSq = gather(permute(LL1SansDataSq,[2 1 3]));
LLRatio = gather(permute(LLRatio,[2 1 3]));
crossTerms1 = gather(permute(crossTerms1,[2 1 3]));
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

