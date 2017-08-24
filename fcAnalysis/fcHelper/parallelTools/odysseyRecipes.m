%% see if i can max out the workers
odysseyConfig();

numBatches = 700;
c = parcluster;
j = cell(numBatches,1);
for ii = 1:numBatches
   j{ii} = c.batch(@testParFOr, 1, {256}, 'pool', 12); 
end