function [ output ] = testParFOr()
%TESTPARFOR Summary of this function goes here
%   Detailed explanation goes here

N = 2;
output = cell(N,1);
setupParForProgress(N);
parfor ii = 1:N
    output{ii} = bench;
    incrementParForProgress();
end

end

