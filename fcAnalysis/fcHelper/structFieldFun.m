function myStruct = structFieldFun(myStruct,myFunc,onFieldsRegexp)
%STRUCTFIELDFUN  will apply myFunc on 'onFieldsRegexp' that matches by regexp
% of myStruct

F=fieldnames(myStruct);

for ix=1:numel(F)
    if ~isempty(regexp(F{ix},onFieldsRegexp,'ONCE'))
        myStruct.(F{ix})=myFunc(myStruct.(F{ix}));
    end
end


