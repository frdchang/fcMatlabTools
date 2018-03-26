function trueOrFalse = isEveryoneEqual(myCell)
%ISEVERYONEEQUAL will check if everyone is equal in your cell.

checkThis = myCell{1};
checkHistory = zeros(numel(myCell,1));
for ii = 1:numel(myCell)
   checkHistory(ii) = isequal(checkThis,myCell{ii}); 
end

trueOrFalse = all(checkHistory);

end

