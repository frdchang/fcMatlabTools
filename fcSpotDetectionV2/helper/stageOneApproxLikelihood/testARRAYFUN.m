function [] = testARRAYFUN( )
%TESTARRAYFUN Summary of this function goes here
%   Detailed explanation goes here

%% lets practice arrayfun stenciled

kern = ones(3,3);
sizeKern = size(kern);
test = rand(10,10);
sizeData = size(test);
idx = 1:numel(test);

    function mySum = doSum(i)
        [x,y] = ind2sub(size(test),i);
        xL = max(1,x-floor((sizeKern(1)-1)/2));
        yL = max(1,y-floor((sizeKern(2)-1)/2));
        xH = min(sizeData(1),x+floor((sizeKern(1)-1)/2));
        yH = min(sizeData(2),y+floor((sizeKern(2)-1)/2));
        xDom = xL:xH;
        yDom = yL:yH;
        myPatch = test(xDom,yDom);
        mySum = sum(myPatch(:));
    end

mySum = arrayfun(@doSum,idx);
mySum = reshape(mySum,10,10);
corpus = convn(kern,test);
corpus = unpadarray(corpus,sizeData);
end

