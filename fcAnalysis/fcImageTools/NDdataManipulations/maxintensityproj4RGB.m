function maxRGBmarked = maxintensityproj4RGB(rgbDataWmarkers,direction)
%MAXINTENSITYPROJ4RGB when you do a max projection of a bw rgb image with
%colored markers, the max projection needs to be handled carefully.  the
%image is 2d.
sizeData = size(rgbDataWmarkers);
if numel(sizeData) == 2
   rgbDataWmarkers = repmat(rgbDataWmarkers,1,1,3); 
end
% colors = {[1 0 0]',[0 1 0]',[0 0 1]'};
% rgbVals = reshape(permute(rgbDataWmarkers,[3 1 2]),3,numel(rgbDataWmarkers)/3);
% maxVal = double(max(rgbDataWmarkers(:)));
% diffBasket = cell(numel(colors),1);
% for ii = 1:numel(colors)
%     currDiff = bsxfun(@minus,double(rgbVals),colors{ii}*maxVal);
% %     diffBasket{ii} = find(cellfun(@norm,num2cell(currDiff,1))==0);
%     diffBasket{ii}= find(any(currDiff)==0);
% end
% 

colorParts = diff(rgbDataWmarkers,1,3);
colorParts = maxintensityproj(colorParts,3);
diffBasket = find(colorParts > 0);

maxRGBmarked = rgbDataWmarkers(:,:,1);
maxRGBmarked = max(maxRGBmarked,[],direction);
maxRGBmarked = cat(3,maxRGBmarked,maxRGBmarked,maxRGBmarked);

for ii = 1:numel(diffBasket)
  [xx,yy] = ind2sub(sizeData(1:2),diffBasket(ii));
  switch direction
      case 1
          maxRGBmarked(1,yy,:) = rgbDataWmarkers(xx,yy,:);
      case 2
          maxRGBmarked(xx,1,:) = rgbDataWmarkers(xx,yy,:);
      otherwise
          error('incorrect direction');
  end
end


% for ii = 1:numel(colors)
%     [xd,yd] = ind2sub(sizeData(1:2),diffBasket{ii});
%     if ~isempty(xd) || ~isempty(yd)
%         switch direction
%             case 1
%                 for jj = 1:numel(yd)
%                     maxRGBmarked(1,yd(jj),:) = colors{ii}*maxVal;
%                 end
%             case 2
%                 for jj = 1:numel(xd)
%                     maxRGBmarked(xd(jj),1,:) = colors{ii}*maxVal;
%                 end
%             otherwise
%                 error('did not program for that direction');
%         end
%     end
% end