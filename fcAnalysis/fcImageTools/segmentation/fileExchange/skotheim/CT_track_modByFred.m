%main program for segmentation and tracking
function output = CT_track_modByFred(params,trackingSeedData,doParallel)

LcellsO         = trackingSeedData.L;
orderedFileList = trackingSeedData.orderedFileList;

%---set all relevant thresholds-only change if needed ---

max_size_vs_largest_cell =params.max_size_vs_largest_cell; %how much larger (fraction) pixel area a cell can be compared with the final image

%---end of threshold ----
tic %start timer

current_seg_start_time = numel(orderedFileList);
numbM = current_seg_start_time;


no_obj = double(max(LcellsO(:)));

cell_exists=ones(no_obj,2); %matrix with each row = new cell with first col. exist or not sec col = time of birth

%-----define out-variables to struc 'all_obj'------------------
all_obj.cells  = zeros([size(LcellsO) numbM],'uint16'); %saves the segmentation, this is the only necessary output from the program

% example definition of morphological parameter
all_obj.cell_area            =zeros(no_obj,numbM);

%...add more things her if needed...

%------end of define out-variables to struc 'all_obj'---------



%find largest cell to calculate max allowed cell size---

tmp_sizes=zeros(1,no_obj);for i5=1:no_obj;tmp_sizes(i5)=sum(sum(LcellsO==i5));end

max_allowed_cell_size=max_size_vs_largest_cell.*max(tmp_sizes);

%-----end max allowed cell size calculation---------------------------------

%---start of main iterative loops---
Lcells=LcellsO; %start by setting the previous labeled image as the current
[xL,yL] = size(LcellsO);
Lbasket = zeros(xL,yL,no_obj,'uint16');
cell_exists_basket = cell(no_obj,1);
cell_area_basket = zeros(no_obj,numbM);
I=importStack(orderedFileList{end});
close all;
hImage = imshow(plotLabels(I,[],Lcells));
drawnow;
if doParallel
    for c_time=current_seg_start_time:-1:1  %c_time = current time, note segmentation is backwards in time
        I=importStack(orderedFileList{c_time});
        display(['timepoint:' num2str(c_time) ' file:' orderedFileList{c_time}]);
        I = uint8(norm0to1(-double(I))*255);
        fprintf([repmat('.',1,no_obj) '\n\n']);
        parfor i = 1:no_obj
            [new_c_Image2,newcell_exists]  = fastTracker_modByFred(cell_exists,i,I,Lcells,c_time,params,max_allowed_cell_size);
            cell_area_basket(i,c_time) = sum(sum(new_c_Image2>0));
            Lbasket(:,:,i) = new_c_Image2;
            cell_exists_basket{i} = newcell_exists;
            fprintf('\b|\n');
        end
        % update cell_exists with all the ones i tried. multiply all of them to
        % get the global update
        cell_exists = ones(no_obj,2);
        for k = 1:no_obj
            cell_exists = cell_exists.*cell_exists_basket{k};
        end
        logicalLbasket = Lbasket > 0;
        checkOverlap = sum(logicalLbasket,3);
        overlapSet = uint16(checkOverlap == 1);
        Lbasket = bsxfun(@times,Lbasket,overlapSet);
        all_obj.cells(:,:,c_time)   = sum(Lbasket,3);
        Lcells = all_obj.cells(:,:,c_time);
        rgbLabels = plotLabels(-double(I),[],Lcells);
        set(hImage,'CData',rgbLabels);
        title(['timepoint' num2str(c_time) ' ']);
        fprintf('\n');
        drawnow;
    end %end time point loop
else
    for c_time=current_seg_start_time:-1:1  %c_time = current time, note segmentation is backwards in time
        I=imread(orderedFileList{c_time});
        display(['timepoint:' num2str(c_time) ' inverting and normalizing phase image to [0,255]']);
        I = uint8(norm0to1(-double(I))*255);
        for i = 1:no_obj
            display(['cell:' num2str(i)]);
            [new_c_Image2,newcell_exists]  = fastTracker_modByFred(cell_exists,i,I,Lcells,c_time,params,max_allowed_cell_size);
            cell_area_basket(i,c_time) = sum(sum(new_c_Image2>0));
            Lbasket(:,:,i) = new_c_Image2;
            cell_exists_basket{i} = newcell_exists;
        end
        % update cell_exists with all the ones i tried. multiply all of them to
        % get the global update
        cell_exists = ones(no_obj,2);
        for k = 1:no_obj
            cell_exists = cell_exists.*cell_exists_basket{k};
        end
        logicalLbasket = Lbasket > 0;
        checkOverlap = sum(logicalLbasket,3);
        overlapSet = checkOverlap == 1;
        Lbasket = bsxfun(@times,Lbasket,overlapSet);
        all_obj.cells(:,:,c_time)   = sum(Lbasket,3);
        Lcells = all_obj.cells(:,:,c_time);
        rgbLabels = plotLabels(-double(I),[],Lcells);
        set(hImage,'CData',rgbLabels);
    end %end time point loop
end



all_obj.cell_area = cell_area_basket;

ttime=toc;

disp(['total time: ' num2str(ttime./60) 'min'])
output.all_obj = all_obj;
output.params = params;
output.LcellsO= LcellsO;
output.fileList = orderedFileList;
output.numbM = numbM;
% save(savefile, 'all_obj', 'numbM', 'LcellsO' ...
%     ,'cell_exists','max_size_vs_largest_cell','max_area_increase_per_tp','higher_threshold','lower_threshold' ...
%     ,'threshold_increase_factor','phase_subtraction_factor','no_obj');

close all



%--------------------------------------------------------------------------





%99999999999999999999999999999999999999999999999999999999999999999999999999