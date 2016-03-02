%% test first stage MLE
% it returns the parameters inputed to simulate the microscope
N = 1000;
ABasket = zeros(N,1);
BBasket = zeros(N,1);
kern1 = genPSF();
for i = 1:N
    display(i);
    test = genSyntheticSpots('useCase',2);
    inElectrons = returnElectrons(test.data,2.1,100);
    detected = findSpotsStageOne((inElectrons)*(1/0.7),kern1,ones(size(test.data)));
    Aest = detected.A;
    Best = detected.B;
    ABasket(i) = max(Aest(:));
    BBasket(i) = max(Best(:));
end

%% test gradient ascent MLE
% generate synthetic data with 1 spot
test = genSyntheticSpots('useCase',2);
% find the coordinate of maximum intensity
startCoor = ind2subND(size(test.data),find(test.data == max(test.data(:))));
inElectrons = returnElectrons(test.data,2.1,100);
kern = genPSF('onlyPSF',false);
detectedWPSF = findSpotsStageOne((inElectrons)*(1/0.7),threshPSF(kern.glPSF,0.08),ones(size(test.data)));
detectedWGauss = findSpotsStageOne((inElectrons)*(1/0.7),threshPSF(kern.gaussKern,0.08),ones(size(test.data)));
Aest = detectedWPSF.A(startCoor{:});
Best = detectedWPSF.B(startCoor{:});
sqrtBest = sqrt(Best);



%% plot 3d gradient vector field using quiver3(x,y,z,u,v,w)
test = genSyntheticSpots('useCase',2);
inElectrons = returnElectrons(test.data,2.1,100);
inPhotons = (inElectrons)*(1/0.7);
kern = genPSF('onlyPSF',false);
detectedWPSF = findSpotsStageOne(inPhotons,threshPSF(kern.glPSF,0.08),ones(size(test.data)));
% find the coordinate of maximum intensity
startCoor = ind2subND(size(detectedWPSF.A),find(detectedWPSF.A == max(detectedWPSF.A(:))));
Aest = detectedWPSF.A(startCoor{:});
Best = detectedWPSF.B(startCoor{:});
kernSigmas = {kern.gaussSigmas(1),kern.gaussSigmas(2),kern.gaussSigmas(3)};
initParam = [Aest,Best,startCoor{:},kernSigmas{:}];
useParam = [1,1,1,1,1,0,0,0];
close all;
param = doGradientSearch(initParam,useParam,@DLogDTheta_Spot1,inPhotons,'maxIter',1000,'stepSize',.1);
plot3Dstack(detectedWPSF.A,'clustCent',[param(3);param(4);param(5)]);
% DLogDTheta = calcDLogDTheta(Aest,Best,startCoor,kernSigmas,inPhotons);
% sampling = 1:1:numel(test.data);
% basketGrad = {};
% basketCoor = {};
% zSlice = 5;
% index = 1;
% for i = 1:size(test.data,1)
%     for j = 1:size(test.data,2)
%         currCoor = {i,j,zSlice};
%         DLogDTheta = calcDLogDTheta(Aest,Best,currCoor,kernSigmas,inPhotons);
%         basketGrad{index} = DLogDTheta(3:5);
%         basketCoor{index} = [currCoor{:}]';
%         index = index+1;
%     end
% end
% basketCoor = cell2mat(basketCoor)';
% basketGrad = cell2mat(basketGrad)';
% imagesc(detectedWPSF.A(:,:,zSlice));
% colormap gray
% hold on;
% quiver(basketCoor(:,1),basketCoor(:,2),basketGrad(:,1),basketGrad(:,2),'sr','filled');
% quiver3(basketCoor(:,1),basketCoor(:,2),basketCoor(:,3),basketGrad(:,1),basketGrad(:,2),basketGrad(:,3),'sr','filled');

%% generate different SNR
kern = genPSF('onlyPSF',false);
As = 10:4:30;
for j = 1:1000
    index = 1;
    for i = As
        spotParamStruct1.xp   = .2e-6;  %(units m in specimen plane)
        spotParamStruct1.yp   = .1e-6;  %(units m in specimen plane)
        spotParamStruct1.zp   = 0e-6;  %(units m in specimen plane)
        spotParamStruct1.amp  = i;    %(number of electrons at peak)
        sampleData = genSyntheticSpots('useCase',2,'bkgndVal',10,'spotList',{spotParamStruct1});
        % convert to photons
        inElectrons = returnElectrons(sampleData.data,2.1,100);
        inPhotons = (inElectrons)*(1/0.7);
        % grab kernel
        kern = genPSF('onlyPSF',false);
        % do stage 1
        detectedWPSF = findSpotsStageOne(inPhotons,threshPSF(kern.glPSF,0.04),ones(size(sampleData.data)));
        % save them
        if index == 1
            catenated = cat(2,maxintensityproj(detectedWPSF.A,3),maxintensityproj(sampleData.synAmp,3),maxintensityproj(detectedWPSF.B,3),maxintensityproj(sampleData.synBak,3));
            datas = maxintensityproj(sampleData.data,3);
        else
            catenated = cat(1,catenated,cat(2,maxintensityproj(detectedWPSF.A,3),maxintensityproj(sampleData.synAmp,3),maxintensityproj(detectedWPSF.B,3),maxintensityproj(sampleData.synBak,3)));
            datas = cat(1,datas,maxintensityproj(sampleData.data,3));
        end
        index = index+1;
    end
    exportSingleTifStack(['~/Desktop/test/catenated' num2str(j)],uint8(round(catenated*10)));
    exportSingleTifStack(['~/Desktop/test/datas' num2str(j)],uint8(round(datas)));
end
% setup stage 2
startCoor = ind2subND(size(detectedWPSF.A),find(detectedWPSF.A == max(detectedWPSF.A(:))));
Aest = detectedWPSF.A(startCoor{:});
Best = detectedWPSF.B(startCoor{:});
kernSigmas = {kern.gaussSigmas(1),kern.gaussSigmas(2),kern.gaussSigmas(3)};
initParam = [Aest,Best,startCoor{:},kernSigmas{:}];
useParam = [1,1,1,1,1,0,0,0];
% do stage 2
param = doGradientSearch(initParam,useParam,@DLogDTheta_Spot1,inPhotons,'maxIter',10000,'stepSize',1);



%% thousand points of light
thresh = 10;
minVolume = 10;
kern = genPSF('onlyPSF',false);
kernSigmas = {kern.gaussSigmas(1),kern.gaussSigmas(2),kern.gaussSigmas(3)};
kern = threshPSF(kern.glPSF,0.04);
BBoxSize = size(kern);
% sampleData = genSyntheticSpots('useCase',1,'zSteps',40,'ru',150,'meanInt',21,'numSpots',100);
detectedWPSF = findSpotsStageOne(sampleData.data,kern,ones(size(sampleData.data)));
% find candidate spots
BWmask = detectedWPSF.A > thresh;
% make sure candidate spots have a certain volume
BWmask = bwareaopen(BWmask, minVolume,6);
stats = regionprops(BWmask);
% find iterative MLE for every candidate
clustCent = zeros(3,numel(stats));
for i = 1:numel(stats)
    curCorr = stats(i).Centroid;
%     curData = getSubsetwCentroidANdBBoxSizeND(sampleData.data,curCorr,BBoxSize);
%     curAest = getSubsetwCentroidANdBBoxSizeND(detectedWPSF.A,curCorr,BBoxSize);
%     curBest = getSubsetwCentroidANdBBoxSizeND(detectedWPSF.B,curCorr,BBoxSize);
%     startCoor = ind2subND(size(curAest),find(curAest == max(curAest(:))));
%     Aest = curAest(startCoor{:});
%     Best = curBest(startCoor{:});
%     initParam = [Aest,Best,startCoor{:},kernSigmas{:}];
%     useParam = [1,1,1,1,1,0,0,0];
%     param = doGradientSearch(initParam,useParam,@DLogDTheta_Spot1,curData,'maxIter',2000,'stepSize',10,'plotFunc',[]);
%     coorEst = param(3:5);
%     plot3Dstack(detectedWPSF.A,'clustCent',curCorr([2,1,3])');
clustCent(:,i) = curCorr([2,1,3])';
end

%% test speed of various approaches to dot products and formatting
clear
test = rand(100*100*20,8);
kern = rand(100*100*20,1);
tic
output = sum(bsxfun(@times,test,kern));
toc
test1 = cell(8,1);
for i = 1:8
   test1{i} = rand(100*100*20,1); 
end

tic;
output = zeros(8,1);
for i =1:8
    output(i) = test1{i}'*kern;
end
toc

% cell array dot product is just as fast as the bsxfun approach...i think i
% will do that way since i can use scalars as well.

%% test passing by reference 
test = rand(1000,1000,20);
A = test;
B = test;
C = test;
dataStruct.A = test;
dataStruct.B = test;
dataStruct.C = test;
tic;
for i = 1:10
   dataStruct = inPlace(dataStruct);
   dataStruct.A = dataStruct.A+1;
   dataStruct.B = dataStruct.B+2;
   dataStruct.C = dataStruct.C+3;
end
toc
tic;
[A1,B1,C1] = notInPlace(A,B,C);
[A2,B1,C1] = notInPlace(A1,B1,C1);
toc

%% testing function speed
tic;
for i = 1:1000
    if isempty(firstDerivatives)
    end
end
toc
