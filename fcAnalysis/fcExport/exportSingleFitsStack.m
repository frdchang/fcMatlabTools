function [] = exportSingleFitsStack(filename,stack)
%EXPORTSINGLEFITSSTACK saves a 3D stack in FITS format.
%
% note1: this will also overwrite any file with the same name
% note2: fits file format cannot have special characters such as
%        parenthesis, check their website for details
% note3: on my macosx fits_write handles ~/ and () with ease.  check on
% linux again to see if it breaks on these cases.
%
% fchang@fas.harvard.edu

%% first process filename to be what the fits library likes
% replace '~/' with full path to home directory since fitswrite does not
% like this notation
% filename = regexprep(filename,'^~',getHomeDir);
if isequal(filename(1),'~')
    filename = [getHomeDir filename(2:end)];
end
% append fits extension
% filename = updateFileExtension(filename,'fits');
% checkParen = regexp(filename,'[(|)]','ONCE');
% if ~isempty(checkParen)
%     display('exportSingleFitsStack():REMOVING PARENTHESIS IN FILEPATH');
% end
% filename = regexprep(filename,'[(|)]','-');
filename = curateFileSeparators(filename);
% check if filename exists
if exist(filename,'file')
    display(['overwritingFITS: ' filename ]);
    delete(filename);
end

% %% for external viewers data needs to be tranposed
% szData=size(stack);
% if length(szData) > 1 
%     order=1:length(szData);
%     order(1:2)=[2,1];
%     stack=permute(stack, order);
% end

%% save nd fits format in double format
% import matlab.io.*
% fptr = fits.createFile(filename);
% % fits.createImg(fptr,'int16',[100 200]);
% fits.createImg(fptr,'double_img',size(stack));
% fits.writeImg(fptr,stack);
% fits.closeFile(fptr);
% fitsdisp(filename);
makeDIRforFilename(filename);
display(['writingFITS: ' filename]);
fits_write(filename,flipud(stack));