function output = cellMultiply(Kvals,littleLambdas)
%CELLMULTIPLY will multiply the cell contents of Kvals into the cell
%contents of littleLambdas.

output = cellfun(@(x,y) cellfunNonUniformOutput(@(z) x*z,y),Kvals,littleLambdas,'UniformOutput',false);
end

