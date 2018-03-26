function D2 = calcD2PoissGaussDLambda2(data,lambda,sigma)
%CALCD2POISSGAUSSDLAMBDA2 returns the second derivative of the probability 
% of seeing data w.r.t lambda given lambda sigma and zero offset, for now
% it is not vectorized.
if isscalar(lambda) && ~isscalar(data)
   lambda = lambda*ones(size(data)); 
end

D2 = arrayfun(@D2PoissGaussDLambda2,data,lambda,sigma);

end

