sampleN = 10000;
N = 100;

rmsMean = zeros(numel(N),1);
rmsHodge = zeros(numel(N),1);
theta = 0:0.01:1;

parfor jj = 1:numel(theta)
    display(jj);
    N = 100;
    thetaBasket = zeros(sampleN,1);
    hodgeBasket = zeros(sampleN,1);
    for ii = 1:sampleN
        currData = normrnd(theta(jj),1,N);
        hodgeBasket(ii) = hodgesEstimator(currData);
        thetaBasket(ii) = mean(currData(:));
    end
    rmsHodge(jj) = NDrms(hodgeBasket,theta(jj));
    rmsMean(jj) =  NDrms(thetaBasket,theta(jj));
end