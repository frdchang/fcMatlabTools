function [output] = getNDXYZProfiles(ndData,varargin)
%GETNDXYZPROFILES% generate line profiles from the brighteset pixel in all cardinal
% directions

%--parameters--------------------------------------------------------------
params.fitGaussian = false;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

maxCoor = cell2mat(ind2subND(size(ndData),find(ndData==max(ndData(:)),1)));
profiles = cell(numel(maxCoor),1);
for i = 1:numel(maxCoor)
    startLine = maxCoor;
    endLine   = maxCoor;
    startLine(i) = 1;
    endLine(i) = size(ndData,i);
    profiles{i} = getNDLineProfile(ndData,{startLine,endLine},params);
    profiles{i} = profiles{i}{:};
end

if params.fitGaussian
    % fit gaussians to all of the profiles
    fitBasket = cell(numel(maxCoor),1);
    for i = 1:numel(maxCoor)
        fitBasket{i} = fit([1:numel(profiles{i})]',profiles{i},'gauss1');
    end
    % generate gaussian kernel approximation
    sigmaBasket = zeros(numel(maxCoor),1);
    for i = 1:numel(maxCoor)
        sigmaBasket(i) = sqrt(((fitBasket{i}.c1)^2)/2);
    end
    gaussStruct.gaussKern = ndGauss(sigmaBasket,size(ndData));
    gaussStruct.gaussSigmas = sigmaBasket;
    output.profiles = profiles;
    output.gaussFits = gaussStruct;
    for i = 1:numel(maxCoor)
        figure;

        plot(fitBasket{i},1:numel(profiles{i}),profiles{i});
                title(['sigma ' num2str(sigmaBasket(i))]);
    end
end


