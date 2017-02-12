function [] = openExplorer(myDir)
%OPENEXPLORER will open local explorer for myDIR
% Just as an example; current dir

myDir = [ returnFilePath([myDir filesep]) filesep];
myDir = removeDoubleFileSep(myDir);
% Windows PC    
if ispc
    C = evalc(['!explorer ' myDir]);

% Unix or derivative
elseif isunix

    % Mac
    if ismac
        C = evalc(['!open ' myDir]);

    % Linux
    else
%         fMs = {...
%             'xdg-open'   % most generic one
%             'gvfs-open'  % successor of gnome-open
%             'gnome-open' % older gnome-based systems               
%             'kde-open'   % older KDE systems
%            };
%         C = '.';
%         ii = 1;
%         while ~isempty(C)                
%             C = evalc(['!' fMs{ii} ' ' myDir]);
%             ii = ii +1;
%         end
C = evalc(['!' 'gvfs-open' ' ' myDir]);
    end
else
    error('Unrecognized operating system.');
end

if ~isempty(C)
    error(['Error while opening directory in default file manager.\n',...
        'The reported error was:\n%s'], C); 
end


end

