function [] = parForSave(fname,data)
%PARFORSAVE saves variables for parfor loops

var_name=genvarname(inputname(2)); 
eval([var_name '=data;']);

try 
    save(fname,var_name,'-append');
catch 
    save(fname,var_name);
end