function yesorno = isFunc(aVariable)
%ISFUNC checks aVariable is a function handle or not
yesorno = isa(aVariable,'function_handle');
end

