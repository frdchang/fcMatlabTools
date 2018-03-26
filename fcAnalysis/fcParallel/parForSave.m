function [] = parForSave(fname,x)
%PARFORSAVE saves variables for parfor loops
% 
% var_name=genvarname(inputname(2)); 
% eval([var_name '=x;']);
% 
% try 
%     save(fname,var_name,'-append');
% catch 
%     save(fname,var_name);
% end

save(fname,'x');