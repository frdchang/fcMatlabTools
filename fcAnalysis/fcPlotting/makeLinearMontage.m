function dataMontage = makeLinearMontage(data)
%MAKELINEARMONTAGE Summary of this function goes here
%   Detailed explanation goes here
sizeData = size(data);
dataMontage = reshape(data,sizeData(1),prod(sizeData(2:end)));
end

