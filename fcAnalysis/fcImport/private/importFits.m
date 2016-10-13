function [fitsData] = importFits(filename)
%IMPORTFITS will import a fits file format but take care regarding special
%characters = {'(',')','[',']'}

specialCharacters = {'(',')','[',']'};
homeDIR = getHomeDir;
filename = regexprep(filename,'^~',homeDIR);
% append fits extension
filename = updateFileExtension(filename,'fits');

checkForSpecialChar = regexp(filename,specialCharacters);
if sum(cellfun(@isempty,checkForSpecialChar)) > 0
    % there is special characters so copy the file to a neutral location,
    % rename the file without special characters, and load it, then delete
    % it
    cleanFilename = returnFileName(regexprep(filename,specialCharacters,''));
    cleanFilename = [homeDIR filesep cleanFilename];
    copyfile(filename,cleanFilename);
    fitsData = flipud(fits_read(cleanFilename));
    delete(cleanFilename);   
else
    % there is no special characters, so just load it
    fitsData = flipud(fits_read(filename));
end



