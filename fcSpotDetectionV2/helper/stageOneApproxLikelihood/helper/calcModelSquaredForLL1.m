function modelsummedSq = calcModelSquaredForLL1(Kmatrix,As,Bs,k1,k3,k5)
%CALCMODELSQUARED calculates the (A*F+B+...)^2 by expanding the quadratic
%and then summing the terms
modelsummedSq = 0;
for ii = 1:size(Kmatrix,2)
    tempAs = cell(size(As));
    tempBs = cell(size(Bs));
   for jj = 1:size(Kmatrix,1)
       tempAs{jj} = As{jj}*Kmatrix(ii,jj);
       tempBs{jj} = Bs{jj}*Kmatrix(ii,jj);
       modelsummedSq = givenABs(tempAs,tempBs,k1,k3,k5);
   end
end

end


function modelsummedSq = givenABs(As,Bs,k1,k3,k5)
AandB = interleave(As,Bs);
kIndicator = zeros(numel(AandB),1);
kIndicator(1:2:end) = 2;
kIndicator(2:2:end) = 1;
useK = kIndicator*kIndicator';

kholder = {k5,k1,0,k3};

modelsummedSq = 0;
for ii = 1:numel(AandB)
    for jj = 1:numel(AandB)
        modelsummedSq = modelsummedSq+ AandB{ii}.*AandB{jj}.*kholder{useK(ii,jj)};
    end
end

end
