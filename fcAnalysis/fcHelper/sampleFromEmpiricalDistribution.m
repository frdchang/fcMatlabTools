function samples = sampleFromEmpiricalDistribution(p,edges,n)
%SAMPLEFROMEMPIRICALDISTRIBUTION Summary of this function goes here
%   Detailed explanation goes here

[~,x] = histc(rand(1,n),[0;cumsum(p(:))/sum(p)]);
samples = edges(x);
end

