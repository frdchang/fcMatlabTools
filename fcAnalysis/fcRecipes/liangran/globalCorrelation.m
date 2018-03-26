%% for liangran, from fred.  
% liangran notices that there is no correlation between individual
% chromosomes, but when you sum up half of the chromosomes vs. the other
% half, there is a correlation.  this could be explained by the fact that
% each nucleus has a certain level of average crossovers.  e.g. some
% nucleus will have higher levels of COs than others.  I modeled this case
% below, where each chromosome will independently acquire COs, but there is
% also a global level of COs per nucleus.  


% number of nucleus to model
numNuclei = 100;

% average CO levels per chromosome are set by the chromosome number.  
chrs = 5:20;

% each nuclei is a column, and each row is an experiment.  
trueCOs = repmat(chrs,numNuclei,1);

% each nuclei will have its global average number of COs slightly modulated
% by gaussian distribution with sigma = 2.  
fluctuation = 2*randn(numNuclei,1);
fluctuation = repmat(fluctuation,1,numel(chrs));

% sample experimental COs as poisson variable
expCOs = poissrnd(trueCOs + fluctuation);

% correlation between chr1 and 2
scatter(expCOs(:,1),expCOs(:,2));

% correlatin between sum of even and odds
oddChrs = expCOs(:,1:2:end);
evenChrs = expCOs(:,2:2:end);

sumOddChrs = sum(oddChrs,2);
sumEvenChrs = sum(evenChrs,2);

scatter(sumOddChrs,sumEvenChrs);



