function [] = templateForStenciledArrayFun( )
%TESTARRAYFUN Summary of this function goes here
%   Detailed explanation goes here

%% lets practice arrayfun stenciled

xlength = 100;
ylength = 1000;
zlength = 20;

test = gpuArray(rand(xlength,ylength,zlength));
test2 = gpuArray(rand(xlength,ylength,zlength));

uberTest = cat(4,test,test2);

idx = gpuArray([1:xlength]);
idy = gpuArray([1:ylength]');
idz = gpuArray(reshape([1:zlength],1,1,zlength));

kern = gpuArray(ones(3,5,7));

numDatas = numel(uberTest);
sizeKern = size(kern);
sizeData = size(test);
    function mySum = doSum(x,y,z)
        xL = max(1,x-floor((sizeKern(1)-1)/2));
        yL = max(1,y-floor((sizeKern(2)-1)/2));
        zL = max(1,z-floor((sizeKern(3)-1)/2));
        xH = min(sizeData(1),x+floor((sizeKern(1)-1)/2));
        yH = min(sizeData(2),y+floor((sizeKern(2)-1)/2));
        zH = min(sizeData(3),z+floor((sizeKern(3)-1)/2));
        mySum = 0;
        for ii = xL:xH
            for jj = yL:yH
                for kk = zL:zH
                    for ll = 1:2
                        mySum = mySum + uberTest(ii,jj,kk,ll);  
                    end
                end
            end
        end
    end

tic;mySumoutput = arrayfun(@doSum,idx,idy,idz);toc

% note that the output is flipped xy
mySumoutput = permute(mySumoutput,[2 1 3]);
tic;corpus = convn(kern,test);toc
corpus = unpadarray(corpus,sizeData);
myError = mySumoutput - corpus;


end

