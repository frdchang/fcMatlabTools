function pdf = DPoissDLambdaPDF(x,lambda)
%DPOISSDLAMBDAPDF gives you the derivative of the poisson w.r.t. lambda

first = contPoissPDF(x-1,lambda);
second = contPoissPDF(x,lambda);
pdf = first-second;


