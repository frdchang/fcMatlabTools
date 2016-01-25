function params = updateParams(params,userParams)
%UPDATEPARAMS takes userParams, which can be a structure or a named,value
%cell list, and updates the params structure fields.

if ~isempty(userParams)
    if isstruct(userParams)
        params = setstructfields(params,userParams);
    else
        params = parsepropval(params,userParams{:});
    end
end

end

