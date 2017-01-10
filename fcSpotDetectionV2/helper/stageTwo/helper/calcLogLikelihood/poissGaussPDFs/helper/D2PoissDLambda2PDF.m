function d2 = D2PoissDLambda2PDF(x,Lambda)
%D2POISSDLAMBDA2 Summary of this function goes here
%   Detailed explanation goes here


d2 = exp(1).^((-1).*Lambda).*Lambda.^((-2)+x).*(((-1)+x).*x+(-2).*x.*Lambda+Lambda.^2).* ...
  gamma(x+1).^(-1);
end

