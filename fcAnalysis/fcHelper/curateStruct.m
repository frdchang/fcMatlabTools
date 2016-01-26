function structout = curateStruct(structin, newfields)
%CURATESTRUCT Set fields of a structure using another structure
%   It is exactly like setstructfields, but unlike that function
%   this function does not append additional fields to structin
%   that exist in newfields

narginchk(2,2);

% Set the output to the input
structout = structin;

% If newfields is not a structure return
if ~isstruct(newfields), return; end

% Loop over all the fields of newfields and assign them to the output
% fc: added additional logic so this function does not append new fields to
% struct in.
fields = fieldnames(structin);
for i = 1:length(fields),
    value = newfields.(fields{i});
    if isstruct(value) && isfield(structout, fields{i}) && isstruct(structout.(fields{i}))
        structout.(fields{i}) = setstructfields(structout.(fields{i}), value);
    else
        structout.(fields{i}) = newfields.(fields{i});
    end
end

end

