function spacingBasket = calcSpacing(domains)
%CALCSPACING for each dimension of data calculates the spacing in domains,
%which are generated by meshgrid

spacingBasket = cell(numel(domains),1);

for ii = 1:numel(spacingBasket)
   currDomain = domains{ii};
   for jj = 1:ndims(currDomain)
      diffDomain = diff(currDomain,1,jj);
      theDiffs = uniqueFP(diffDomain,10^-10);
      if numel(theDiffs) > 1
         error('this domain has uneven spacing');
      end
      if theDiffs > 0
         spacingBasket{ii} =  theDiffs;
      end
   end
end


end
