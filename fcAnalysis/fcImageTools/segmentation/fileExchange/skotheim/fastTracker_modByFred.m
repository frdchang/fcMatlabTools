function [new_c_Image2, cell_exists] = fastTracker_modByFred(cell_exists,i,Icurr,Lcellscurr,c_time,params,max_allowed_cell_size)
% 20140525 - fred: i want to pay the price of loading the files and segment
% all the cells once. therefore this function collected per cell processing and
% abstract it here so that parfor can run it on all the cells given that a
% frame has been loaded.

%---set all relevant thresholds-only change if needed ---
[x_size,y_size]=size(Lcellscurr);
max_size_vs_largest_cell =params.max_size_vs_largest_cell; %how much larger (fraction) pixel area a cell can be compared with the final image

max_area_increase_per_tp =params.max_area_increase_per_tp;%maximal allowed area increase before switching to higher threshold (was 0.075) % 0.03

higher_threshold         =params.higher_threshold;  %segmentation threshold for regions that wasnt part of the cell in the previous time point

lower_threshold          =params.lower_threshold;  %segmentation threshold for regions that was   part of the cell in the previous time point

threshold_increase_factor=params.threshold_increase_factor;  %change of thresholds in case of large change in area

phase_subtraction_factor =params.phase_subtraction_factor;  %factor that determines how much of hte phase image we deduct from the segmentation

min_cell_size            =params.min_cell_size;   %minimal cell size allowed in pixels

cell_margin              =params.cell_margin;   %margin around the cell from the previous segmentaiton, for current segmentation
    new_c_Image =zeros(size(Lcellscurr)); %define new images
    
    new_c_Image2=zeros(size(Lcellscurr));
%---end of threshold ----
doPlot = false;
checkCell = Lcellscurr==i;

if sum(checkCell(:)) > 0              %if the cell exists for this time
    
%     disp(['cell' num2str(i) ' time: ' num2str(c_time)])                %cosmetic display
    
    %     I=imread(orderedFileList{c_time});
    %
    %     I = uint8(norm0to1(-double(I))*255);
    %     display('inverting and normalizing phase image to [0,255]');
    %
    
    s_f=regionprops(bwlabel(Lcellscurr==i),'Centroid','BoundingBox','Area'); %identify cell, label cell, calculate characteristics
    

    
    
    
    %---get the cell and not an intersection
    
    tmpareas=zeros(1,length(s_f));
    
    for i5=1:length(s_f);tmpareas(i5)=s_f(i5).Area;end
    
    [val,pos]= max(tmpareas); ok_obj_no=pos;
    
    %---end this thing
    
    
    
    %retrieve the bounding box + margins for the current cell
    
    bbox=round(s_f(ok_obj_no).BoundingBox);
    
    lower_x_limit=max(1,bbox(1)-cell_margin);
    
    upper_x_limit=min(y_size,bbox(1)+bbox(3)+cell_margin);
    
    lower_y_limit=max(1,bbox(2)-cell_margin);
    
    upper_y_limit=min(x_size,bbox(2)+bbox(4)+cell_margin);
    
    x_cn=lower_x_limit:upper_x_limit;
    
    y_cn=lower_y_limit:upper_y_limit;
    
    
    
    %open images around the current cell phase and binary
    
    tmpI1=(Icurr(y_cn,x_cn));
    
    tmpI2=(Lcellscurr==i);%was i
    
    tmpI2=tmpI2(y_cn,x_cn);
    
    [Ires] = rescale_im09(tmpI1,-.5,3);%rescales the phase image
    
    %------------------------------------------------
    
    newI2=tmpI1<-100; %make new image for iterative segmentation
    
    
    
    %calculate edges of image (to be excluded from segmentation)
    
    exI=uint8(newI2);
    
    exI(1,1:end)=1;exI(end,1:end)=1;exI(1:end,1)=1;exI(1:end,end)=1; %added march 26th 2012
    
    for j=1:256 %for al possible image intensities
        
        %again watershed algorithm
        
        bw=tmpI1<(j);
        
        bw2=bwmorph(bw,'thicken',1);
        
        D = bwdist(~bw2);
        
        D = -D;
        
        D(~bw2) = -Inf;
        
        L = watershed(D);
        
        %end watershed
        
        
        
        %do not include parts of the watershed that are also part of the image edge!
        
        intr_segm=setxor([0:max(max(L))],[unique(uint8(L).*exI)']);
        
        %----add all relevant parts of L to the new object---------
        
        newI=tmpI1<-100;%tmp variable
        
        for j2=intr_segm %only go over parts that are not included in edges
            
            if sum(sum((L==j2).*tmpI2))./sum(sum((L==j2)))>0.4 ...         %select pieces that are over 40% cell and less than 33% non-cell
                    && sum(sum(((L==j2).*~bw)==1))./sum(sum((L==j2)))<0.33
                
                newI=newI+(L==j2);                                         %add all selected pieces to the same image
                
            end
            
        end
        
        newI=bwmorph(imfill(bwmorph(newI,'close',1),'holes'),'thicken',1); %removes holes and such
        
        newI2=newI2+double(newI);                                          %add to selected images from previous image
        
    end
    
    
    
    maxI2= max(max(newI2));%first maxima to scale against
    
    newI2=newI2-phase_subtraction_factor.*(maxI2./256).*double(Ires);
    
    Ignew=uint8(ones(x_size,y_size));
    
    newI2=newI2-bwdist(tmpI2);
    
    maxI2= max(max(newI2));%first maxima to scale against
    
    lin_im=newI2(:)';
    
    [q,w]=hist(lin_im,50);
    
    [qq,ww]=min(abs(0.90.*maxI2-w));
    
    maxI2=w(ww);
    
    
    
    high_thr=higher_threshold; %threshold for regiosns not-previously designated as "cell"
    
    low_thr =lower_threshold;  %threshold for regiosns     previously designated as "cell"
    
    %calculate which putative cell regions that corresponds to previously segmented areas and which that doesnt
    
    pcell=(newI2-tmpI2.*1)>(maxI2.*high_thr);
    
    prem =((newI2-tmpI2.*1)<(maxI2.*high_thr)).*((newI2-tmpI2.*1)>(maxI2.*low_thr));%was 0.2
    
    %new segmented image
    
    newI=(  pcell+prem.*tmpI2);
    
    newI=(imfill( bwmorph( bwareaopen(newI,10,4),'close',1),'holes'));
    
    %----change segmentation if too large increase-decrease in area (if needed)---------------------------------------------
    
    % if the area increases more than some specified fraction (see "thresholds" above)
    
    % then increase the segmentation thresholds and recalculate the segmentated image
    
    area_increase=(sum(sum(newI))-sum(sum(tmpI2)))./sum(sum(tmpI2));
    
    if area_increase>max_area_increase_per_tp
        
%         disp(['higher thr enabled incr. frac. = ' num2str((sum(sum(newI))-sum(sum(tmpI2)))./sum(sum(tmpI2))) ''])
        
        high_thr = higher_threshold + threshold_increase_factor;
        
        low_thr  = lower_threshold  + threshold_increase_factor;
        
        pcell=(newI2-tmpI2.*1)>(maxI2.*high_thr);
        
        prem =((newI2-tmpI2.*1)<(maxI2.*high_thr)).*((newI2-tmpI2.*1)>(maxI2.*low_thr));%was 0.2
        
        newI=(  pcell+prem.*tmpI2);
        
        newI=(imfill( bwmorph( bwareaopen(newI,10,4),'close',1),'holes'));
        
    end
    
    %same as above but for sudden decreases in cell area
    
    area_decrease =((sum(sum(newI))-sum(sum(tmpI2)))./sum(sum(tmpI2)));
%     disp(area_decrease)
    
    if abs(area_decrease)>max_area_increase_per_tp
        
%         disp(['lower thr enabled incr. frac. = ' num2str((sum(sum(newI))-sum(sum(tmpI2)))./sum(sum(tmpI2))) ''])
        
        high_thr = higher_threshold - threshold_increase_factor;
        
        low_thr  = lower_threshold  - threshold_increase_factor;
        
        pcell=(newI2-tmpI2.*1)>(maxI2.*high_thr);
        
        prem =((newI2-tmpI2.*1)<(maxI2.*high_thr)).*((newI2-tmpI2.*1)>(maxI2.*low_thr));%was 0.2
        
        newI=(  pcell+prem.*tmpI2);
        
        newI=(imfill( bwmorph( bwareaopen(newI,10,4),'close',1),'holes'));
        
    end
    
    %----end change segmentation if too large increase-decrease in area (if needed)---------------------------------------------
    
    
    
    for z1=1 %cosmetic loop
        
        %dont change this code
        
        %--------------remove multiple parts----------------------------
        
        Lny=bwlabel(newI);
        
        Lny2=newI<-1000;
        
        
        
        if sum(sum(newI))>min_cell_size
            
            if max(max(Lny))==1  %all ok
                
                Lny2=Lny2+(Lny==1);
                
            else
                
                maxindex=0;
                
                tmparea=0;
                
                for j2=1:max(max(Lny))
                    
                    if sum(sum(Lny==j2))>tmparea
                        
                        tmparea=sum(sum(Lny==j2));
                        
                        maxindex=j2;
                        
                    end
                    
                end
                
                Lny2=Lny2+(Lny==maxindex);
                
            end
            
        end
        
        %-----------------end remove multiple parts------------------------------------------
        
        new_c_Image(y_cn,x_cn)=new_c_Image(y_cn,x_cn)+i.*Lny2;
        
        
        
        %----- remove places where two cells share the same area:
        
        Ltmp=bwlabel(new_c_Image==i);
        
        s_f4=regionprops(Ltmp,'Area');
        
        if length(s_f4)>1
            
            tmparea=0;
            
            maindex=0;
            
            for j4=1:length(s_f4)
                
                if s_f4(j4).Area>tmparea
                    
                    tmparea=s_f4(j4).Area;
                    
                    maindex=j4;
                    
                end
                
            end
            
            new_c_Image2=new_c_Image2+i.*(Ltmp==maindex);
            
        else
            
            new_c_Image2=new_c_Image2+i.*(new_c_Image==i);
            
        end
        
        %----- end remove places where two cells share the same area:
        
    end %z1 cosmetic loop
    
    
    
    %determine if the segmentation is ok, ie if it fulfills the following conditions:
    
    %1. larger than minimal cell size
    
    %2. not containing all lower than median gfp (if used)
    
    %3. not over max size
    
    %4. no drastic increase of more than 50% cell area
    
    if sum(sum(new_c_Image2==i))<min_cell_size ...
            || sum(sum(uint8(newI).*Ignew(y_cn,x_cn)))./sum(sum(uint8(newI)))<0.99.*mean(mean(Ignew)) ...
            || sum(sum(new_c_Image2>0))>max_allowed_cell_size ...
            || area_increase>0.5
        
        cell_exists(i,1)=0;
        
        cell_exists(i,2)=c_time;
        
    end
    
    %store final segmented image in structure "all.obj"
    
    %     all_obj.cell_area(i,c_time)=sum(sum(new_c_Image2>0));
    %
    %     all_obj.cells(:,:,c_time)=all_obj.cells(:,:,c_time)+new_c_Image2;
    
%     newL=new_c_Image2; %make final labeled image
    
    
    if doPlot
        %-------this code is for image display only-----------------------------------
        
        new_c_Image3=Icurr<-1000;
        
        j5=i;
        
        if cell_exists(j5,1)==1
            
            new_c_Image3=new_c_Image3+bwmorph(new_c_Image2==j5,'remove',inf);
            
        end
        
        %--------------------display image----------------------
        
        Inew_here=uint8(zeros(x_size,y_size,3));
        
        Inew_here(:,:,1)=0.5.*Icurr+   255.*uint8(bwmorph(new_c_Image3,'remove',inf));
        
        Inew_here(:,:,2)=0.5.*Icurr+  0.*uint8(bwmorph(new_c_Image3,'remove',inf));
        
        Inew_here(:,:,3)=0.5.*Icurr+     0.*uint8(bwmorph(new_c_Image3,'remove',inf));
        
        figure(4);imshow(Inew_here);title(c_time);drawnow
        
        if (cell_exists(i,1))>0
            
            im_here=new_c_Image2==i;
            
            s_ftmp=regionprops(bwlabel(im_here),'Centroid');
            
            center_here=round(s_ftmp(1).Centroid);
            
            text(center_here(1,1)+20, center_here(1,2),[num2str(i)],'BackgroundColor',[.7 .9 .7]);
            
        end
        
        
        hold off
    end
    
    %--------------------end image display code--------------------------------
    
    
    
    %---call routine that extracts fluorescent data
    %[all_obj]= get_fl_est1(all_obj,c_time,prefix,suffix2,pos_num,suffix,numbM,type,Lcells,cell_exists,i);
    
    
    
    %                 %display fluorescent data
    %
    %                 figure(5);
    %
    %                 plot(all_obj.nuc_whi5(i,:)-all_obj.cyt_whi5(i,:));hold on
    %
    %                 plot(all_obj.nuc_whi5G(i,:)-all_obj.cyt_whi5G(i,:),'g');
    %
    %                 plot(all_obj.nuc_whi5R(i,:)-all_obj.cyt_whi5R(i,:),'r');
    %
    %                 hold off
    %
    %                 drawnow
    %
    %                 %end displaying fl data
    
    
    
    
    
end %end of cell exists loop
end

