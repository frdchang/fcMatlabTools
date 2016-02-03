function params = updateParams(params,userParams)
%UPDATEPARAMS takes userParams, which can be a structure or a named,value
%cell list, and updates the params structure fields.
% userParams can be 
% 1) {'name',value,...}
% 2) struct
% 3) {struct}

if ~isempty(userParams)
   if iscell(userParams)
       if isstruct(userParams{1})
           params = setstructfields(params,userParams{1});
       else
           params = parsepropval(params,userParams{:});
       end   
   else
       if isstruct(userParams)
           params = setstructfields(params,userParams);
       else
           error('userParams is not the type expected');
       end
   end
end

end

