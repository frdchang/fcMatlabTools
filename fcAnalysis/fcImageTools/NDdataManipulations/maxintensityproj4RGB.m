function maxRGBmarked = maxintensityproj4RGB(rgbDataWmarkers,direction)
%MAXINTENSITYPROJ4RGB when you do a max projection of a bw rgb image with
%colored markers, the max projection needs to be handled carefully.  the
%image is 2d.
sizeData = size(rgbDataWmarkers);
colors = {[1 0 0]',[0 1 0]',[0 0 1]'};
rgbVals = reshape(permute(rgbDataWmarkers,[3 1 2]),3,numel(rgbDataWmarkers)/3);
maxVal = double(max(rgbDataWmarkers(:)));
diffBasket = cell(numel(colors),1);
for ii = 1:numel(colors);
    currDiff = bsxfun(@minus,double(rgbVals),colors{ii}*maxVal);
%     diffBasket{ii} = find(cellfun(@norm,num2cell(currDiff,1))==0);
    diffBasket{ii}= find(any(currDiff)==0);
end

maxRGBmarked = rgbDataWmarkers(:,:,1);
maxRGBmarked = max(maxRGBmarked,[],direction);
maxRGBmarked = bw2rgb(maxRGBmarked);
for ii = 1:numel(colors)
    [xd,yd] = ind2sub(sizeData(1:2),diffBasket{ii});
    if ~isempty(xd) || ~isempty(yd)
        switch direction
            case 1
                for jj = 1:numel(yd)
                    maxRGBmarked(1,yd(jj),:) = colors{ii}*maxVal;
                end
            case 2
                for jj = 1:numel(xd)
                    maxRGBmarked(xd(jj),1,:) = colors{ii}*maxVal;
                end
            otherwise
                error('did not program for that direction');
        end
    end
end