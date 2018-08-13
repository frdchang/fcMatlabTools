function [ area ] = areaOfOverlappingGauss(mu1,mu2,sigma1,sigma2)
%AREAOFOVERLAPPINGGAUSS returns the area of 2 overlapping gaussians
% 
% https://stats.stackexchange.com/questions/103800/calculate-probability-area-under-the-overlapping-area-of-two-normal-distributi
%http://www.jgyan.com/intersection-points-for-two-gaussian-distribution/


a = 1 / (2*sigma1^2) - 1 / (2*sigma2^2);
b = mu2 / (sigma2^2) - mu1 / (sigma1^2);
c = mu1^2 / (2*sigma1^2) - mu2^2 / (2*sigma2^2) - log(sigma2/sigma1);
% num = mu2 .* (sigma1.^2) - sigma2 .* (mu1.*sigma2 + sigma1 .* sqrt((mu1 - mu2).^2 + 2 .* (sigma1.^2 - sigma2.^2) * log(sigma1./sigma2)));
% dem = sigma1.^2 - sigma2.^2;
% 
% area = num ./ dem;
test = roots([a b c]);

t = -4:0.1:max(mu1,mu2)*3;
plot(t,normpdf(t,mu1,sigma1));
hold on;
plot(t,normpdf(t,mu2,sigma2));
vline(test);
end

