function DLogDTheta = calcDLogDTheta(Aest,Best,startCoor,kernSigmas,data)
%DLOGDTHETA Summary of this function goes here
%   Detailed explanation goes here
[xGrid,yGrid,zGrid] = ndgrid(1:size(data,1),1:size(data,2),1:size(data,3));
lambda = lambda_Spot1(Aest,Best,startCoor{:},kernSigmas{:},xGrid,yGrid,zGrid);
DLogDLamba = DLogDLamba_PP(data,lambda,1);
DLambdaDTheta = DLambdaDTheta_Spot1(Aest,Best,startCoor{:},kernSigmas{:},xGrid,yGrid,zGrid);
DLogDTheta = cell(5,1);
for i = 1:5
   DLogDTheta{i} = DLogDLamba.*DLambdaDTheta{i}; 
end

for i = 1:5
   DLogDTheta{i} = sum(DLogDTheta{i}(:)); 
end

DLogDTheta = cell2mat(DLogDTheta);
end

