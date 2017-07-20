function [gradData,hessData] = NDgradientAndHessian3D(data,domains)
gradData = cell(3,1);

spacingBasket = calcSpacing(domains);
for ii = 1:3
   spacingBasket{ii} = -spacingBasket{ii}; 
end


[gradData{:}] = gradient(data,spacingBasket{1},spacingBasket{2},spacingBasket{3});
tempGradData = gradData;
gradData{2} = tempGradData{1};
gradData{1} = tempGradData{2};

temp = cell(3,1);

if nargout == 2
    hessData = cell(3,3);
    for ii = 1:3
        [temp{:}] = gradient(gradData{ii},spacingBasket{1},spacingBasket{2},spacingBasket{3});
        temptemp = temp;
        temp{2} = temptemp{1};
        temp{1} = temptemp{2};
        [hessData{:,ii}] = temp{:};
    end
end

