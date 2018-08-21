function flag = isNanTheta(theta0)
%ISNANTHETA checks if any of the inputs is nan for theta
flag1 = getXYZABFromTheta(theta0);
flag2 = flattenCellArray(flag1{:});
if isempty(flag2)
   flag = false; 
   return;
end
flag = cellfun(@(x) any(isnan(x)),flag2);
end

