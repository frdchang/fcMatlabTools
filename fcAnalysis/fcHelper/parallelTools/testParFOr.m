function [ output ] = testParFOr(N)
%TESTPARFOR Summary of this function goes here
%   Detailed explanation goes here

output = cell(N,1);
setupParForProgress(N);
parfor ii = 1:N
    test = rand(1048,1048,11);
    tic;test = fft(test);
    output{ii} = toc;
    incrementParForProgress();
end

end

