%% see if i can max out the workers
setupCluster('setWallTime','00:10:00','setMemUsage','4000');
numBatches = 10;
c = parcluster;
j = cell(numBatches,1);
for ii = 1:numBatches
   j{ii} = c.batch(@testParFOr, 1, {256}, 'pool', 12); 
end

