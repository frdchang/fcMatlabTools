function withTranspose = createTransposed(dataCell)
%CREATETRANSPOSED Summary of this function goes here
%   Detailed explanation goes here

withTranspose = {};

for ii = 1:numel(dataCell);
   withTranspose{end+1} = dataCell{ii};
   withTranspose{end+1} = flipud(dataCell{ii});
end

end

