function outputFiles = batchHelper(listOfArguments,openFileFunc,openFileFuncParams,myFunc,myFuncParams,saveFunc,hashMyFuncParams,saveFuncParams)


extractedVariables   = openFileFunc(listOfArguments{:},openFileFuncParams{:});
funcOutput           = cell(nargout(myFunc),1);
[funcOutput{:}]      = myFunc(extractedVariables{:},myFuncParams{:});
outputFiles          = saveFunc(listOfArguments,funcOutput,myFunc,hashMyFuncParams,saveFuncParams{:});
end