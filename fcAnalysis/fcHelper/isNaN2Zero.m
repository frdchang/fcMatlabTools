function [ data ] = isNaN2Zero(data )
%ISNAN2ZERO will convert nan values to zero

if iscell(data)
    data = cellfunNonUniformOutput(@(x) makeZeroIfNan(x),data);
else
    data(isnan(data))=0;
end

end

function a = makeZeroIfNan(a)
a(isnan(a)) = 0;
end

