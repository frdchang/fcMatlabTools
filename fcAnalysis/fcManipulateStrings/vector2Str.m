function [ strVec ] = vector2Str(myVec )
%VECTOR2STR file safe vector to string conversion

strVec = mat2str(myVec);
strVec = regexprep(strVec,'\[|\]','_');

end

