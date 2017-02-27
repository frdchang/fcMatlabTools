function curated = removeFileSep(filePath)
%REMOVEFILESEP Summary of this function goes here
%   Detailed explanation goes here
curated = regexprep(filePath,{'\','/'},'');

end

