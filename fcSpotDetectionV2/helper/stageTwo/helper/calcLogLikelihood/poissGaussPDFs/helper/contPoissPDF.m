function pdf = contPoissPDF(x,lambda)
%CONTPOISSPDF a continous version of the poisson pdf.

pdf = (lambda.^x).*exp(-lambda)./gamma(x+1);

end

