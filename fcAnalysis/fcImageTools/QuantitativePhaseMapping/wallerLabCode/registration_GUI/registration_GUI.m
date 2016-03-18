function varargout = registration_GUI(varargin)
% REGISTRATION_GUI MATLAB code for registration_GUI.fig
%      REGISTRATION_GUI, by itself, creates a new REGISTRATION_GUI or raises the existing
%      singleton*.
%
%      H = REGISTRATION_GUI returns the handle to a new REGISTRATION_GUI or the handle to
%      the existing singleton*.
%
%      REGISTRATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGISTRATION_GUI.M with the given input arguments.
%
%      REGISTRATION_GUI('Property','Value',...) creates a new REGISTRATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before registration_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to registration_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help registration_GUI

% Last Modified by GUIDE v2.5 14-Oct-2014 15:51:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @registration_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @registration_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before registration_GUI is made visible.
function registration_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to registration_GUI (see VARARGIN)

% Choose default command line output for registration_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

function varargout = registration_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function dir_edit1_Callback(hObject, eventdata, handles)
function dir_edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function dir_edit2_Callback(hObject, eventdata, handles)
function dir_edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off');

function dirbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function dirbox2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off');

function img_type1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function img_type1_Callback(hObject, eventdata, handles)
function img_type2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off');
function img_type2_Callback(hObject, eventdata, handles)

function dirbox1_Callback(hObject, eventdata, handles)
function dirbox2_Callback(hObject, eventdata, handles)

function op_sel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ps1_Callback(hObject, eventdata, handles)
function ps1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function lam1_Callback(hObject, eventdata, handles)
function lam1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function z1_Callback(hObject, eventdata, handles)
function z1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function sf1_Callback(hObject, eventdata, handles)
function sf1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ps2_Callback(hObject, eventdata, handles)
function ps2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off');
function lam2_Callback(hObject, eventdata, handles)
function lam2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off');
function z2_Callback(hObject, eventdata, handles)
function z2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off');
function sf2_Callback(hObject, eventdata, handles)
function sf2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off');

function ref1_Callback(hObject, eventdata, handles)
function ref1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ref2_Callback(hObject, eventdata, handles)
function ref2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function browse_btn1_Callback(hObject, eventdata, handles)
name = uigetdir;
if(ischar(name))
    set(handles.dir_edit1, 'String', name);
end
function browse_btn2_Callback(hObject, eventdata, handles)
name = uigetdir;
if(ischar(name))
    set(handles.dir_edit2, 'String', name);
end

function load_btn1_Callback(hObject, eventdata, handles)
set(handles.dirbox1, 'Enable', 'on');
set(handles.dirbox1, 'Max', 1);
set(handles.dirbox1, 'String', 'Valid files will appear here ...');
folder = get(handles.dir_edit1, 'String');
contents = cellstr(get(handles.img_type1, 'String'));
selstr = contents{get(handles.img_type1,'Value')}; 

switch selstr
    case 'TIFF (Single Image)'
        type = '.tiff';
    case 'TIF (Multiple Image)'
        type = '.tif';
    case 'TIF'
        type = '.tif';
    case 'JPEG'
        type = '.jpg';
    case 'BMP'
        type = '.bmp';
    case 'PNG'
        type = '.png';
end

struct = dir([folder '\*' type]);
sz = size(struct,1);

if(sz == 0)
    set(handles.dirbox1, 'String', 'No valid files.');
    set(handles.dirbox1, 'Value', 1);
    set(handles.dirbox1, 'Enable', 'off');
else
    if(strcmp(selstr,'TIFF (Multiple Image)'))
        set(handles.dirbox1, 'Max', 1);
    else    
        set(handles.dirbox1, 'Max', sz);
    end
    c = cell(sz,1);
    for x = 1 : sz
        c{x} = struct(x).name;
    end
    set(handles.dirbox1, 'String', c);
end
function load_btn2_Callback(hObject, eventdata, handles)
set(handles.dirbox2, 'Enable', 'on');
set(handles.dirbox2, 'Max', 1);
set(handles.dirbox2, 'String', 'Valid files will appear here ...');
folder = get(handles.dir_edit2, 'String');
contents = cellstr(get(handles.img_type2, 'String'));
selstr = contents{get(handles.img_type2,'Value')};

switch selstr
    case 'TIFF (Single Image)'
        type = '.tiff';
    case 'TIF (Multiple Image)'
        type = '.tif';
    case 'TIF'
        type = '.tif';
    case 'JPEG'
        type = '.jpg';
    case 'BMP'
        type = '.bmp';
    case 'PNG'
        type = '.png';
end

struct = dir([folder '\*' type]);
sz = size(struct,1);

if(sz == 0)
    set(handles.dirbox2, 'String', 'No valid files.');
    set(handles.dirbox2, 'Value', 1);
    set(handles.dirbox2, 'Enable', 'off');
else
    if(strcmp(selstr,'TIFF (Multiple Image)'))
        set(handles.dirbox2, 'Max', 1);
    else    
        set(handles.dirbox2, 'Max', sz);
    end   
    c = cell(sz,1);
    for x = 1 : sz
        c{x} = struct(x).name;
    end
    set(handles.dirbox2, 'String', c);
end

function selall_btn_Callback(hObject, eventdata, handles)
c = get(handles.dirbox1, 'String');
set(handles.dirbox1, 'Value', 1:size(c,1));
function selall_btn2_Callback(hObject, eventdata, handles)
c = get(handles.dirbox2, 'String');
set(handles.dirbox2, 'Value', 1:size(c,1));

function op_sel_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
sel = contents{get(hObject,'Value')};

switch sel
    case {'Make stack (no registration)', ...
          'Register one stack - single reference', ...
          'Register one stack - reference to previous'}
        set(handles.dir_edit2, 'enable', 'off');
        set(handles.browse_btn2, 'enable', 'off');
        set(handles.load_btn2, 'enable', 'off');
        set(handles.img_type2, 'enable', 'off');
        set(handles.dirbox2, 'enable', 'off');
        set(handles.selall_btn2, 'enable', 'off');
        set(handles.ref2, 'enable', 'off');
        set(handles.ps2, 'enable', 'off');
        set(handles.lam2, 'enable', 'off');
        set(handles.z2, 'enable', 'off');
        set(handles.sf2, 'enable', 'off');
        set(handles.save2, 'enable', 'off');
        
    otherwise 
        set(handles.dir_edit2, 'enable', 'on');
        set(handles.browse_btn2, 'enable', 'on');
        set(handles.load_btn2, 'enable', 'on');
        set(handles.img_type2, 'enable', 'on');
        set(handles.dirbox2, 'enable', 'on');
        set(handles.selall_btn2, 'enable', 'on');
        set(handles.ref2, 'enable', 'on');
        set(handles.ps2, 'enable', 'on');
        set(handles.lam2, 'enable', 'on');
        set(handles.z2, 'enable', 'on');
        set(handles.sf2, 'enable', 'on');
        set(handles.save2, 'enable', 'on');
end

function reg_btn_Callback(hObject, eventdata, handles)
restore = pwd;
try
    contents = cellstr(get(handles.op_sel,'String'));
    sel = contents{get(handles.op_sel,'Value')};
    
    % construct image stack 1 or 2
    switch sel
        case {'Make stack (no registration)', ...
              'Register one stack - single reference', ...
              'Register one stack - reference to previous'}
            
            contents = cellstr(get(handles.img_type1,'String'));
            sel2 = contents{get(handles.img_type1,'Value')};
            
            switch sel2
                case 'TIFF (Multiple Image)'
                    imgs = get(handles.dirbox1, 'String');
                    vals = get(handles.dirbox1, 'Value');
                    imgs = imgs(vals);
                    curr_folder = pwd;
                    folder = get(handles.dir_edit1, 'String');

                    cd(folder)
                    info = imfinfo(imgs{1});
                    width = info(1).Width;
                    height = info(1).Height;
                    num = length(info);
 
                    im_stack = zeros(height,width,num,'uint16');
                    for i = 1 : num
                        im_stack(:,:,i)=imread(imgs{1},'Index',i);
                    end
                    im_stack = im2double(im_stack);
                
                otherwise    
                    imgs = get(handles.dirbox1, 'String');
                    vals = get(handles.dirbox1, 'Value');
                    imgs = imgs(vals);
                    curr_folder = pwd;
                    folder = get(handles.dir_edit1, 'String');

                    cd(folder)
                    img = rgb2gray(im2double(imread(imgs{1})));
                    im_stack = zeros(size(img,1), size(img,2), size(imgs,1));
                    im_stack(:,:,1) = img; clear img;

                    for i = 2: size(imgs,1)
                        im_stack(:,:,i) = rgb2gray(im2double(imread(imgs{i})));
                    end
            end
            cd(curr_folder)
    
        otherwise 
            contents = cellstr(get(handles.img_type2,'String'));
            sel2 = contents{get(handles.img_type2,'Value')};
            
            switch sel2
                case 'TIFF (Multiple Image)'
                    imgs = get(handles.dirbox2, 'String');
                    vals = get(handles.dirbox2, 'Value');
                    imgs = imgs(vals);
                    curr_folder = pwd;
                    folder = get(handles.dir_edit2, 'String');

                    cd(folder)
                    info = imfinfo(imgs{1});
                    width = info(1).Width;
                    height = info(1).Height;
                    num = length(info);
 
                    im_stack = zeros(height,width,num,'uint16');
                    for i = 1 : num
                        im_stack(:,:,i)=imread(imgs{1},'Index',i);
                    end
                    im_stack = im2double(im_stack);
                
                otherwise    
                    imgs = get(handles.dirbox2, 'String');
                    vals = get(handles.dirbox2, 'Value');
                    imgs = imgs(vals);
                    curr_folder = pwd;
                    folder = get(handles.dir_edit2, 'String');

                    cd(folder)
                    img = rgb2gray(im2double(imread(imgs{1})));
                    im_stack = zeros(size(img,1), size(img,2), size(imgs,1));
                    im_stack(:,:,1) = img; clear img;

                    for i = 2: size(imgs,1)
                        im_stack(:,:,i) = rgb2gray(im2double(imread(imgs{i})));
                    end
            end
            cd(curr_folder)
    end
    
    % Register stack 1 or 2
    switch sel
               
        case 'Make stack (no registration)'
            assignin('base','im_stack1',im_stack);
            
        case 'Register one stack - single reference'
            cd code
            ref = str2double(get(handles.ref1, 'String'));
            if(strcmp(sel2, 'TIFF (Multiple Image)'))
                ref_indx = ref;
            else
                ref_indx = find(vals == ref);
            end
            ref_img_ft = fft2(im_stack(:,:,ref_indx));

            for i = 1: size(im_stack,3)
                Im2 = im_stack(:,:,i);
                [~,greg] = dftregistration(ref_img_ft,fft2(Im2),2000); 
                im_stack(:,:,i) = abs(ifft2(greg));
            end

            cd ..
            assignin('base','im_stack1',im_stack);

        case 'Register one stack - reference to previous'
            cd code
            ref = str2double(get(handles.ref1, 'String'));
            if(strcmp(sel2, 'TIFF (Multiple Image)'))
                ref_indx = ref;
            else
                ref_indx = find(vals == ref);
            end

            for i = ref_indx+1 : size(im_stack,3)
                Im1 = im_stack(:,:,i-1);
                Im2 = im_stack(:,:,i);
                [~,greg] = dftregistration(fft2(Im1),fft2(Im2),2000); 
                im_stack(:,:,i) = abs(ifft2(greg));
            end 

            for i = ref_indx-1 :-1: 1
                Im1 = im_stack(:,:,i+1);
                Im2 = im_stack(:,:,i);
                [~,greg] = dftregistration(fft2(Im1),fft2(Im2),2000); 
                im_stack(:,:,i) = abs(ifft2(greg));
            end

            cd ..
            assignin('base','im_stack1',im_stack);

        case 'Register second stack - single reference'
            im_stack2 = im_stack;
            evalin('base', 'assignin(''caller'',''im_stack'',im_stack1);');
            cd code
            ref = str2double(get(handles.ref2, 'String'));
            if(strcmp(sel2, 'TIFF (Multiple Image)'))
                ref_indx = ref;
            else
                ref_indx = find(vals == ref);
            end
            
            Im1 = im_stack(:,:,ref_indx);
            Im2 = im_stack2(:,:,ref_indx);

            [~,ref] = dftregistration(fft2(Im1),fft2(Im2),2000); 
            
            for i = 1: size(im_stack2,3)
                Im2 = im_stack2(:,:,i);
                [output,~] = dftregistration(ref,fft2(Im2),2000); 
                xshift = output(3);
                yshift = output(4);
                Im2reg = subpixel_shift(Im2, xshift*size(im_stack,1), ...
                    yshift*size(im_stack,2));
                im_stack2(:,:,i) = Im2reg;
            end

            cd ..
            assignin('base','im_stack2',im_stack2);

        case 'Register second stack - reference to previous'
            im_stack2 = im_stack;
            evalin('base', 'assignin(''caller'',''im_stack'',im_stack1);');
            cd code
            ref = str2double(get(handles.ref2, 'String'));
            if(strcmp(sel2, 'TIFF (Multiple Image)'))
                ref_indx = ref;
            else
                ref_indx = find(vals == ref);
            end
            
            Im1 = im_stack(:,:,ref_indx);
            Im2 = im_stack2(:,:,ref_indx);

            [~,greg] = dftregistration(fft2(Im1),fft2(Im2),2000); 
            im_stack2(:,:,ref_indx) = abs(ifft2(greg));

            for i = ref_indx+1: size(im_stack2,3)
                Im1 = im_stack2(:,:,i-1);
                Im2 = im_stack2(:,:,i);
                [~,greg] = dftregistration(fft2(Im1),fft2(Im2),2000); 
                im_stack2(:,:,i) = abs(ifft2(greg));
            end

            for i = ref_indx-1: -1 : 1
                Im1 = im_stack2(:,:,i+1);
                Im2 = im_stack2(:,:,i);
                [~,greg] = dftregistration(fft2(Im1),fft2(Im2),2000); 
                im_stack2(:,:,i) = abs(ifft2(greg));
            end

            cd ..
            assignin('base','im_stack2',im_stack2);

        case 'Register second stack - parallel reference'
            im_stack2 = im_stack;
            evalin('base', 'assignin(''caller'',''im_stack'',im_stack1);');
            cd code
            for i = 1 : size(im_stack2,3)
                Im1 = im_stack(:,:,i);
                Im2 = im_stack2(:,:,i);
                [~,greg] = dftregistration(fft2(Im1),fft2(Im2),2000); 
                im_stack2(:,:,i) = abs(ifft2(greg));
            end

            cd ..
            assignin('base','im_stack2',im_stack2);

    end

    msgbox('Registration complete!','Status','warn');

catch err
    cd(restore);
    msgbox('Registration unsuccessful.','Status','error');
end


function save1_Callback(hObject, eventdata, handles)
cd datasets
assignin('base', 'ps', str2double(get(handles.ps1, 'String')));
assignin('base', 'lambda', str2double(get(handles.lam1, 'String')));

expr = get(handles.z1, 'String');
eval(['z = ' expr]);
assignin('base', 'zvec', z);

evalin('base', 'im_stack = im_stack1;');

name = get(handles.sf1, 'String');
expr = ['save(''' name ...
    '.mat'', ''im_stack'', ''ps'', ''lambda'', ''zvec'');'];

evalin('base', expr);

cd ..
msgbox('Saved successfully!','Status','warn');

function save2_Callback(hObject, eventdata, handles)
cd datasets
assignin('base', 'ps', str2double(get(handles.ps2, 'String')));
assignin('base', 'lambda', str2double(get(handles.lam2, 'String')));

expr = get(handles.z2, 'String');
eval(['z = ' expr ';']);
assignin('base', 'zvec', z);

evalin('base', 'im_stack = im_stack2;');

name = get(handles.sf2, 'String');
expr = ['save(''' name ...
    '.mat'', ''im_stack'', ''ps'', ''lambda'', ''zvec'');'];

evalin('base', expr);

cd ..
msgbox('Saved successfully!','Status','warn');

% -------------------------------------------------------------------------
% SHAMELESS SELF-PROMOTION BUTTON
function about_Callback(hObject, eventdata, handles)
cd code
img = imread('seal.jpg');
cd ..
msgbox(['This application was created by Gautam Gunjala,' ...
    ' B.S. Electrical Engineering & Computer Science, B.S. Engineering' ...
    ' Mathematics and Statistics, 2016, at the University of California,' ...
    ' Berkeley. Affiliated with the Computational Imaging Lab and Prof.' ...
    ' Laura Waller (http://www.laurawaller.com).'], ...
    'About','custom',img)
