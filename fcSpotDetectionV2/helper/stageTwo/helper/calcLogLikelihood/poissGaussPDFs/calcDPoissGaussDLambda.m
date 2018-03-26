function D = calcDPoissGaussDLambda(data,lambda,sigma)
%CALCDPOISSGAUSSDLAMBDA returns the Derivative of the probability of seeing 
% data w.r.t lambda given lambda sigma and zero offset, for now it is not 
% vectorized.
if isscalar(lambda) && ~isscalar(data)
   lambda = lambda*ones(size(data)); 
end

D = arrayfun(@DPoissGaussDLambda,data,lambda,sigma);

end


