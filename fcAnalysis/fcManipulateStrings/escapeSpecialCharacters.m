function escaped = escapeSpecialCharacters(input)
%ESCAPESPECIALCHARACTERS Summary of this function goes here
%   Detailed explanation goes here

escaped = regexprep(input,'[\[\$\^\.\\\*\+\[\]\(\)\{\}\?\|\]]', '\\$0');
end

