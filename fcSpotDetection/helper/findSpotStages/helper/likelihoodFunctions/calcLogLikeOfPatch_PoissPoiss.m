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
% [note] - currently the loglikelihood calculates the constant which gets
%          subtracted out anyways.   for performance considerations maybe 
%          that is not needed.
%        - to test this function benchmark against (d-l)^2/sigsq and see if
%          it is the same

centerCoor = round(size(shapeData)/2);
centerCoor = num2cell(centerCoor);

A1 = A1(centerCoor{:});
B1 = B1(centerCoor{:});
B0 = B0(centerCoor{:});

lambda1 = A1*shapeData+B1;
lambda0 = B0*ones(size(shapeData));

LLval1 = logLike_PoissPoiss(data,lambda1,sigmasq);
LLval0 = logLike_PoissPoiss(data,lambda0,sigmasq);

LLratio = LLval1 - LLval0;


end

