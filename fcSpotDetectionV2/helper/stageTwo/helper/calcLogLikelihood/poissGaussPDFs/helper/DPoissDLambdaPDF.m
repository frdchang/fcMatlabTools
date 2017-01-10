function pdf = DPoissDLambdaPDF(x,lambda)
%DPOISSDlambdaPDF gives you the derivative of the poisson w.r.t. lambda

first = contPoissPDF(x-1,lambda);
second = contPoissPDF(x,lambda);
pdf = first-second;

% pdf2 = exp(1).^((-1).*lambda).*(x+(-1).*lambda).*lambda.^((-1)+x).*gamma(x+1).^(-1);


