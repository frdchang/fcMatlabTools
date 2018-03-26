function yourstr = array2str(array)
%ARRAY2STR Summary of this function goes here
%   Detailed explanation goes here

yourstr = [ regexprep(num2str(array),' +','-') ];
end

