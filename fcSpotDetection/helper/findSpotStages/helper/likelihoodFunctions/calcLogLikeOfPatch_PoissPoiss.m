function LLratio = calcLogLikeOfPatch_PoissPoiss(data,sigmasq,A1,B1,B0,shapeData)
%CALCLOGLIKEOFPATCH calculates the log likelihood of a patch
% 
% data:             measured data patch
% sigmasq:          readnoise                         (same size as data)
% A1:               est amplitude given spot model 1  (same size as data)
% B1:               est background given spot model 1 (same size as data)
% B0:               est background given spot model 0 (same size as data)
% shapeData:        the shape function                (same size as data)
%
% [note] - tested this function against the correlation based (d-l)^2/sigsq 
%          and the values are the same -fc. 

centerCoor = round(size(shapeData)/2);
centerCoor = num2cell(centerCoor);

A1 = A1(centerCoor{:});
B1 = B1(centerCoor{:});
B0 = B0(centerCoor{:});

lambda1 = A1*shapeData+B1;
lambda0 = B0*ones(size(shapeData));

dataI = data > -Inf;

LLval1 = logLike_PoissPoiss(data(dataI),lambda1(dataI),sigmasq(dataI));
LLval0 = logLike_PoissPoiss(data(dataI),lambda0(dataI),sigmasq(dataI));

% LLval1 = ((data(dataI)-lambda1(dataI)).^2)./(sigmasq(dataI));
% LLval0 = ((data(dataI)-lambda0(dataI)).^2)./(sigmasq(dataI));
% 
% LLval1 = -sum(LLval1(:));
% LLval0 = -sum(LLval0(:));

LLratio = LLval1 - LLval0;


end

