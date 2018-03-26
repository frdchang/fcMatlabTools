function [carved,carvedMask,BBox] = carveOutWithMask(datas,mask,sizeOfKern,varargin)
%CARVEOUTWITHMASK will carve out datas, which can be a structure of datas
%or cell or numeric and will carve out the mask with sizeOfKern as a border
% skp fields are added as varargin stuff

S = regionprops(mask,'BoundingBox');

if max(numel(S)) > 1
    warning('there are more than 1 value in the mask, i will take the first');
end

myBBox = S(1).BoundingBox;

if iscell(datas)
    carved = cellfunNonUniformOutput(@(x) getSubsetwBBoxND(x,myBBox,'borderVector',sizeOfKern),datas);
    carvedMask = getSubsetwBBoxND(mask,myBBox,'borderVector',sizeOfKern,'padValue',0);
elseif isstruct(datas)
    fields = fieldnames(datas);
    if ~isempty(varargin)
        offender = ismember(fields,varargin{1});
        fields(offender) = [];
    end
    carved = struct;
    carvedMask = getSubsetwBBoxND(mask,myBBox,'borderVector',sizeOfKern);
   
        for ii = 1:numel(fields)
             if iscell(datas.(fields{ii})) && isnumeric(datas.(fields{ii}){1})
                 carved.(fields{ii}) = cellfunNonUniformOutput(@(x) getSubsetwBBoxND(x,myBBox,'borderVector',sizeOfKern),datas.(fields{ii}));
             elseif isnumeric(datas.(fields{ii}))
                  carved.(fields{ii}) = getSubsetwBBoxND(datas.(fields{ii}),myBBox,'borderVector',sizeOfKern);
             else
                carved.(fields{ii}) = datas.(fields{ii}); 
             end
            
        end

           

    
elseif isnumeric(datas) || islogical(datas);
    [carved,BBox] = getSubsetwBBoxND(datas,myBBox,'borderVector',sizeOfKern);
    carvedMask = getSubsetwBBoxND(mask,myBBox,'borderVector',sizeOfKern,'padValue',0);
else
    error('datas need to be a cell, or struct of numerics, or numeric');
end


end

