function DLogDLamba = DLogDLamba_PP(d,lambda,sigmasq)
%DLOGDLAMPP calculates the deriviative of the log likelihood w.r.t.
% lambda given d = data, lambda = theoretical value, and sigmasq = variance
% of the pixel read noise.  
% the log likelihood function is in Poisson * Poisson form (PP)

DLogDLamba = (d - lambda) ./ (bsxfun(@plus,lambda,sigmasq));
end

