function droppedVowels = dropVowels(myString)
%DROPVOWELS Summary of this function goes here
%   Detailed explanation goes here

droppedVowels = regexprep(myString,'[aeiou]','');
end

