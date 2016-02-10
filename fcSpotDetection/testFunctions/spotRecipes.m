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
% find the coordinate of maximum intensity
startCoor = ind2subND(size(test.data),find(test.data == max(test.data(:))));
inElectrons = returnElectrons(test.data,2.1,100);
inPhotons = (inElectrons)*(1/0.7);
kern = genPSF('onlyPSF',false);
detectedWPSF = findSpotsStageOne(inPhotons,threshPSF(kern.glPSF,0.08),ones(size(test.data)));
Aest = detectedWPSF.A(startCoor{:});
Best = detectedWPSF.B(startCoor{:});

startCoor = ind2subND(size(test.data),find(test.data == max(test.data(:))));

kernSigmas = {kern.gaussSigmas(1),kern.gaussSigmas(2),kern.gaussSigmas(3)};


DLogDTheta = calcDLogDTheta(Aest,Best,startCoor,kernSigmas,inPhotons);
sampling = 1:1:numel(test.data);
basketGrad = {};
basketCoor = {};
zSlice = 5;
index = 1;
for i = 1:size(test.data,1)
    for j = 1:size(test.data,2)
        currCoor = {i,j,zSlice};
        DLogDTheta = calcDLogDTheta(Aest,Best,currCoor,kernSigmas,inPhotons);
        basketGrad{index} = DLogDTheta(3:5);
        basketCoor{index} = [currCoor{:}]';
        index = index+1;
    end
end
basketCoor = cell2mat(basketCoor)';
basketGrad = cell2mat(basketGrad)';
imagesc(detectedWPSF.A(:,:,zSlice));
colormap gray
hold on;
quiver(basketCoor(:,1),basketCoor(:,2),basketGrad(:,1),basketGrad(:,2),'sr','filled');
quiver3(basketCoor(:,1),basketCoor(:,2),basketCoor(:,3),basketGrad(:,1),basketGrad(:,2),basketGrad(:,3),'sr','filled');