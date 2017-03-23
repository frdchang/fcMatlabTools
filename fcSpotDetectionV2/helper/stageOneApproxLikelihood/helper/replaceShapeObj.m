function currInput = replaceShapeObj(currInput,shapeObj )
%REPLACESHAPEOBJ will check if element is an myPattern* object and replace it with
%shapeobj


for ii = 1:numel(currInput)
    currShape = currInput{ii};
    if ~isempty(regexp(class(currShape{1}),'myPattern','ONCE'))
        currInput{ii}{1} = shapeObj;
    end
end


end

