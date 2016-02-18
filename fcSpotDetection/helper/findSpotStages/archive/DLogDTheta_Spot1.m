function DLogDTheta = DLogDTheta_Spot1(params,useParams,data,varargin)
%DLOGDTHETA_SPOT1 Summary of this function goes here
%   Detailed explanation goes here

Aest = params(1);
Best = params(2);
startCoor(1) = params(3);
startCoor(2) = params(4);
startCoor(3) = params(5);
kernSigmas(1) = params(6);
kernSigmas(2) = params(7);
kernSigmas(3) = params(8);

[xGrid,yGrid,zGrid] = ndgrid(1:size(data,1),1:size(data,2),1:size(data,3));
lambda = lambda_Spot1(Aest,Best,startCoor(1),startCoor(2),startCoor(3),kernSigmas(1),kernSigmas(2),kernSigmas(3),xGrid,yGrid,zGrid);
DLogDLamba = DLogDLamba_PP(data,lambda,1);
DLambdaDTheta = DLambdaDTheta_Spot1(Aest,Best,startCoor(1),startCoor(2),startCoor(3),kernSigmas(1),kernSigmas(2),kernSigmas(3),xGrid,yGrid,zGrid);
DLogDTheta = cell(5,1);
for i = 1:5
   DLogDTheta{i} = DLogDLamba.*DLambdaDTheta{i}; 
end

for i = 1:5
   DLogDTheta{i} = sum(DLogDTheta{i}(:)); 
end

DLogDTheta = cell2mat(DLogDTheta);
DLogDTheta(~useParams)=0;
