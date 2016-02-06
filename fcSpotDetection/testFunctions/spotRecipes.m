
N = 1000;
ABasket = zeros(N,1);
BBasket = zeros(N,1);
for i = 1:N
   display(i);
   test = genSyntheticSpots('useCase',2);
   inElectrons = returnElectrons(test.data,2.1,100);
   detected = findSpotsStageOne((inElectrons)*(1/0.7),kern1,ones(size(test.data)));
   Aest = detected.A;
   Best = detected.B;
   ABasket(i) = max(Aest(:));
   BBasket(i) = max(Best(:));
end