function [ h ] = plotLineProfilesFromAPoint(data,varargin )
%PLOTLINEPROFILESFROMAPOINT given ND data plot line profiles from the max
%point, or if coordinate provided from that point along each principle
%dimensions
if isempty(varargin)
    maxCoor = cell2mat(ind2subND(size(data),find(data==max(data(:)),1)));
else
    maxCoor= varargin{1};
end
profileBasket = cell(numel(maxCoor),1);
for i = 1:numel(maxCoor)
    startLine = maxCoor;
    endLine   = maxCoor;
    startLine(i) = 1;
    endLine(i) = size(data,i);
    profileBasket{i} = getNDLineProfile(data,{startLine,endLine});
    profileBasket{i} = profileBasket{i}{:};
end

fitBasket = cell(numel(maxCoor),1);
for i = 1:numel(maxCoor)
    fitBasket{i} = fit([1:numel(profileBasket{i})]',profileBasket{i},'gauss1');
end

for i = 1:numel(maxCoor)
    figure;
    
    plot(fitBasket{i},1:numel(profileBasket{i}),profileBasket{i});
    title(['dim=' num2str(i) ' amp=' num2str(fitBasket{i}.a1) ' sigmasq=' num2str((fitBasket{i}.c1 / sqrt(2))^2)]);
end


end

