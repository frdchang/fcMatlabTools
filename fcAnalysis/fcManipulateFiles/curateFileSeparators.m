function curated = curateFileSeparators(filePath)
%CURATEFILESEPARATORS will replace all instances of '/' or '\' and use the
%native version
curated = regexprep(filePath,{'\','/'},filesep);
end

