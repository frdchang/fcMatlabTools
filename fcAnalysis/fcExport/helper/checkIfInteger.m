function [checked] = checkIfInteger(input)
%CHECKIFINTEGER checks if the input is integeter
checked = isnumeric(input) & all(round(input(:)) == input(:));
end

