function [ output ] = testParFOr(N)
%TESTPARFOR Summary of this function goes here
%   Detailed explanation goes here

tic;
parfor ii = 1:N
    test = rand(1048,1048,11);
    test = fft(test);
end
output= toc;


end

