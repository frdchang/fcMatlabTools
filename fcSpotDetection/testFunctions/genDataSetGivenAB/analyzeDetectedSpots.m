function [ output_args ] = analyzeDetectedSpots(pathToDataSets,pathToOriginalData)
%ANALYZEDETECTEDSPOTS Summary of this function goes here
%   Detailed explanation goes here

% max distance defining if spot is close enough to the true theta xyz
maxDist = 1;
% ground truth variables
groundTruths = getAllFiles(pathToOriginalData,'theta');

% relevant variables = x y z a b
relevantMLEThetas = logical([1 1 1 0 0 0 1 1]);
relevantXYZCoor  = logical([1 1 1 0 0 0 0 0]);
relevantA        = logical([0 0 0 0 0 0 1 0]);
relevantB        = logical([0 0 0 0 0 0 0 1]);
spotData = grabScatteredData(pathToDataSets,'fcSpotDetection',@openData_grabScatteredData);
spotDataOrganized = getOrderedListFromMatch(spotData.dataFileNames,'-[0-9]+','ascend');

numExperiments = numel(spotDataOrganized);

% xyz coors, log likelihoods, false positive rate, false negative rate,
experimentBasket = cell(numExperiments,1);


for ii = 1:numExperiments
    % extract parameters A and B from each experiment
    expName = returnFileName(spotDataOrganized{ii}.name);
    Aval    =  returnNumberFromMatch(expName,'A',[]);
    Bval    =  returnNumberFromMatch(expName,'B',[]);
    % get the true theta from the experiment
    truthTheta = keepCertainStringsUnion(groundTruths,['A' num2str(Aval) '-B' num2str(Bval)]);
    truthTheta = load(truthTheta{1});
    truthTheta = [truthTheta.theta{relevantMLEThetas}];
    % find index for each experiment
    currExperiment = spotDataOrganized{ii}.subMatch;
    currExperimentIndices = returnIndicesFromMatch(spotData.dataFileNames,currExperiment);
    currExpPaths = spotData.dataFileNames(currExperimentIndices);
    currDatas    = spotData.datas(currExperimentIndices);
    
    allthetaMLE = {};
    allthetaVar = {};
    allLLRatios = [];
    sensitivity = zeros(numel(currDatas),1);
  
    for jj = 1:numel(currDatas)
        currSpotParams = currDatas{jj}.funcOutput;
        for kk = 1:numel(currSpotParams)
            allthetaMLE{end+1} = [currSpotParams(kk).thetaMLE{relevantMLEThetas}]';
            estimatedVars = diag(currSpotParams(kk).thetaVar);
            estimatedVars(relevantMLEThetas);
            allthetaVar{end+1} = [estimatedVars(relevantMLEThetas)];
            allLLRatios(end+1) = currSpotParams(kk).logLike;
        end
        currentAllMLEs = cell2mat(cellfunNonUniformOutput(@(x) cell2mat(x)',{currSpotParams.thetaMLE}));
        distancesAllMLEs = pdist2(currentAllMLEs(relevantXYZCoor,:)',truthTheta(relevantXYZCoor));
        if sum(distancesAllMLEs<maxDist) > 0
            sensitivity(jj) = 1;
        end
    end
    allthetaMLE = cell2mat(allthetaMLE);
    allthetaVar = cell2mat(allthetaVar);
    
    % calculate distances of spots from true theta
    currDists = pdist2(allthetaMLE(relevantXYZCoor,:)',truthTheta(relevantXYZCoor));
    
    thisExp.A = Aval;
    thisExp.B = Bval;
    thisExp.truthTheta = truthTheta;
    thisExp.allthetaMLE = allthetaMLE;
    thisExp.allthetaVar = allthetaVar;
    thisExp.sensitivity = sensitivity;
    thisExp.distances = currDists';
    thisExp.allLLRatios = allLLRatios;
    experimentBasket{ii} = thisExp;
end

experimentBasket = cell2mat(experimentBasket);


LLRthresh = 1e4;


As = zeros(numExperiments,1);
thisSensitivity = zeros(numExperiments,1);
fdr    = zeros(numExperiments,1);
close all;
histogramHandles = cell(numExperiments,1);
for ii = 1:numExperiments
   thisExp = experimentBasket(ii); 
   As(ii) = thisExp.A;
   thisSensitivity(ii) = sum(thisExp.sensitivity) / numel(thisExp.sensitivity);
   selectedSpots = thisExp.allLLRatios > LLRthresh;
   alldistances = [thisExp.distances];
   selectedDists = alldistances(selectedSpots);
   checkDists = selectedDists < maxDist;
   fdr(ii) =  sum(~checkDists) / numel(checkDists);
   
   xCoors = thisExp.allthetaMLE(1,:);
   yCoors = thisExp.allthetaMLE(2,:);
   zCoors = thisExp.allthetaMLE(3,:);
   
   xCoors = xCoors(selectedSpots);
   yCoors = yCoors(selectedSpots);
   zCoors = zCoors(selectedSpots);
   
   figure;h = histogram(xCoors);
   h.Normalization = 'pdf';
   xlabel(['xCoor: A=' num2str(thisExp.A)]);
   histogramHandles{ii} = h;
end
sameAxesHistograms(histogramHandles);

figure;
[~,asI] = sort(As,'ascend');
semilogx(As(asI),thisSensitivity(asI),'--x');
box off;
h = findobj('type','axes');
set(h,'color','none')
axis([0.1 max(As) 0 1]);
xlabel('A');
ylabel('sensitivity');

figure;
[~,asI] = sort(As,'ascend');
semilogx(As(asI),fdr(asI),'--x');
box off;
h = findobj('type','axes');
set(h,'color','none')
axis([0.1 max(As) 0 1]);
xlabel('A');
ylabel('false discovery rate');



end