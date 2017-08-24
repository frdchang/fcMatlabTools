function [ output ] = testParFOr(N)
%TESTPARFOR Summary of this function goes here
%   Detailed explanation goes here

parpool('local', str2num(getenv('SLURM_CPUS_PER_TASK')))

output = cell(N,1);
tic;
parfor ii = 1:N
    test = rand(1048,1048,11);
    test = fft(test);
    output{ii} = toc;
end
output{end+1} = toc;

delete(gcp);

end

