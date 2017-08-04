function [ montaged ] = genMontage( cellOfData )
%GENMONTAGE will make a montage given a cell of datas and even if they are
%different sizes.  
cellOfData = flattenCellArray(cellOfData);
sizeDatas = cellfunNonUniformOutput(@size,cellOfData);

end

