function d2 = D2PoissGaussDLambda2(d,Lambda)
%D2POISSGAUSSDLAMBDA2 Summary of this function goes here
%   Detailed explanation goes here

d2 = exp(1).^((-1).*Lambda).*Lambda.^((-2)+d).*(((-1)+d).*d+(-2).*d.*Lambda+Lambda.^2).* ...
  gamma(d+1).^(-1);
end

