function lambda = lambda_Spot1(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z)
%LAMBDASPOT1 Summary of this function goes here
%   Detailed explanation goes here

lambda = Bak+Amp.*exp(1).^((1/2).*((-1).*sigXsq.^(-1).*(x+(-1).*x0).^2+( ...
  -1).*sigYsq.^(-1).*(y+(-1).*y0).^2+(-1).*sigZsq.^(-1).*(z+(-1).* ...
  z0).^2));
end

