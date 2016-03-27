classdef dataCropper < handle
    %DATACROPPER crops out data given bounding Box.  I designed it to be a
    %class because I wanted these cropped data to remember the BoundingBox
    %used.  so If another channel of data needs to be cropped, i simply
    %give it to this object to crop it the same.    the cropping is
    %intelligent that it will crop along the same dimensions, and will
    %either do singleton expansion or dimensional reduction and crop
    %accordingly.  note that data needs to be >= 2D
    %
    % >> cropped = dataCropper(boundingBox);
    % in general: dataCropper(boundingBox,...,'ParameterName',parameter);
    %
    % parameter name, value pairs for constructor:
    % dataCropper(boundingBox)
    % dataCropper(boundingBox,...,'ParameterName',parameter);
    % - dataCropper(boundingBox,'dataToBeCropped',fullSizeData);
    % - dataCropper(boundingBox,'croppedData',croppedData,'dataDescription','description');
    % - dataCropper(boundingBox,'BBoxDescription','description');
    % - dataCropper(rawData); % this will ask the user for a 2D BBOX
    % - dataCropper([],rawData); % this will BBox the entire nD image
    % 'croppedData', initialize object with numeric data that is cropped by
    %                BBox
    % 'dataToBeCropped', initialize object with numerica data to be cropped
    %                    by BBox
    % ** user either croppedData or dataToBeCropped.
    % 'dataDescription', description of that data
    % 'BBoxDescription', description of BBox used
    %
    % you can save the additional cropped data in the object
    % >> cropped.cropDataAndSave(data1,'data1description');
    % >> cropped.cropDataAndSave(data2,'data2description');
    % >> cropped.cropDataAndSave(data3,'data3description');
    % >> data4Cropped = cropped.cropDataAndReturn(data4);  % this doesn't
    % save the crop in the object, just returns it
    % plots all the cropped
    % >> cropped.plot;
    % saves all the cropped
    % >> cropped.save('c:\save here');
    % will save as: c:\save here\BBoxDescription.fits etc.
    % >> size(cropped)
    % returns the size of the cropped image
    %
    %
    % fchang@fas.harvard.edu
    
    
    properties (SetAccess = private)
        dataList = {};
        dataDescriptionList = {};
        BBox
        BBoxDescription
        sizeData      % size of cropped Data
        sizeOGData    % size of original Data cropped data came from
    end
    
    methods
        function obj = dataCropper(varargin)
            % dataCropper(boundingBox)
            % dataCropper(boundingBox,...,'ParameterName',parameter);
            % - dataCropper(boundingBox,'croppedData',croppedData);
            % - dataCropper(boundingBox,'dataToBeCropped',fullSizeData);
            % - dataCropper(boundingBox,'croppedData',croppedData,'dataDescription','description');
            %
            warning('this function is not fully tested/implented');
            p = inputParser;
            p.addRequired('BBox',@isnumeric);
            p.addParameter('dataToBeCropped',[],@isnumeric);
            p.addParameter('dataDescription','',@isstr);
            p.addParameter('BBoxDescription','',@isstr);
            p.parse(varargin{:});
            input  = p.Results;
            BBoxinput               = input.BBox;
            dataDescription         = input.dataDescription;
            obj.BBoxDescription     = input.BBoxDescription;
            dataToBeCropped         = input.dataToBeCropped;
            
            % check if BBox is a BBox or raw numeric data
            if isvector(BBoxinput)
                obj.BBox = BBoxinput;
            elseif isempty(BBoxinput)
                obj.BBox = genBBoxWholeThing(dataToBeCropped);
                obj.BBoxDescription = 'no crop';
            else
                % ask user to generate a 2D BBOX over
                dataToBeCropped = BBoxinput;
                figure;
                imshow(xyMaxProjND(dataToBeCropped),[]);
                h = imrect;
                BBoxinput = wait(h);
                close;
                obj.BBox = BBoxinput;
            end
            
            % calculate size of crops from BBox input.  note that the x and
            % y lengths are flipped
            obj.sizeData = genSizeFromBBox(obj.BBox);
            obj.sizeOGData = size(dataToBeCropped);
            obj.dataList{end+1} = getSubsetwBBoxND(dataToBeCropped,obj.BBox);
            obj.dataDescriptionList{end+1} = dataDescription;
        end
        
        function cropDataAndSave(obj,data,varargin)
            % crop the data and save it into the object
            % cropper.cropDataAndSave(data1);
            % cropped.cropDataAndSave(data1,'data1description');
            if isempty(varargin)
                dataDescription = '';
            else
                dataDescription = varargin{1};
            end
            obj.dataList{end+1} = getSubsetwBBoxND(data,obj.BBox);
            obj.dataDescriptionList{end+1} = dataDescription;
            
        end
        
        function cropped = cropDataAndReturn(obj,data)
            % simply crop and return data, given obj.boundingBox
            cropped = getSubsetwBBoxND(data,obj.BBox);
        end
        
        function returnSize = size(obj)
            % returns size of cropped data
            returnSize = obj.sizeData;
        end
        
        function returnSize = sizeOG(obj)
            % returns size of original data it was cropped from
            returnSize = obj.sizeOGData;
        end
        
        function combined = plot(obj)
            % plot all the cropped objects, or return colorcombined
            % if data is >2D then simply max project to 2D and display
            % grayscale and color combined
            % if there is no output argument,
            % >> obj.plot, just show plot
            % if there is output argument,
            % >> combine = obj.plot
            % return the color combined image
            if ~isempty(obj.dataList)
                numDatas = numel(obj.dataList);
                currDataXYProj = xyMaxProjND(obj.dataList{1});
                for i = 2:numDatas
                    currDataXYProj = cat(2,currDataXYProj,xyMaxProjND(obj.dataList{i}));
                end
                if nargout == 0
                    imshow(currDataXYProj,[]);
                    % generate comma separated title string
                    titleString = cell(numel(obj.dataDescriptionList)*2-1,1);
                    titleString(2:2:end) = {', '};
                    titleString(1:2:end) = obj.dataDescriptionList;
                    title([titleString{:}]);
                    xlabel(obj.BBoxDescription);
                else
                    combined  = currDataXYProj;
                end
            end
        end
        
        function save(obj,filePath)
            % save as individual files using dataDescription,
            % - dataDescription is not defined, then simply enumerate file
            % names
            % - folder name will be BBoxDescription
            % saves in fits format
            if ~isempty(obj.dataList)
                savePath = [filePath filesep obj.BBoxDescription];
                [~,~,~] = mkdir(savePath);
                for i = 1:numel(obj.dataList)
                    if isempty(obj.dataDescriptionList{i})
                        exportSingleFitsStack([savePath filesep num2str(i) '.fits'],obj.dataList{i});
                    else
                        exportSingleFitsStack([savePath filesep obj.dataDescriptionList{i} '.fits'],obj.dataList{i});
                    end
                end
            end
            
        end
        
    end
    
end

