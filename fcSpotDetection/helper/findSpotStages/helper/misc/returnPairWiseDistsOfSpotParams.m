function pairs = returnPairWiseDistsOfSpotParams(spotParams)
%RETURNPAIRWISEDISTS will return all the distances between spots.  performs
% as n! or something like that.

numDims = 3;
if isempty(spotParams)
   pairs = [];
   return;
end
thetas = grabThetasFromSpotParams(spotParams);
if isempty(thetas)
    pairs = [];
    return;
end
clustCent = thetas(:,1:numDims);

sz = size(clustCent);
A1 = reshape(clustCent, [1 sz]);
A2 = permute(A1, [2 1 3]);
D = sqrt(sum(bsxfun(@minus, A1, A2).^2,3));
pairs = squareform(D);