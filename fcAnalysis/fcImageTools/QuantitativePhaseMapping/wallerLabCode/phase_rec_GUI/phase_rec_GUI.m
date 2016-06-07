function varargout = phase_rec_GUI(varargin)
% PHASE_REC_GUI MATLAB code for phase_rec_GUI.fig
%      PHASE_REC_GUI, by itself, creates a new PHASE_REC_GUI or raises the existing
%      singleton*.
%
%      H = PHASE_REC_GUI returns the handle to a new PHASE_REC_GUI or the handle to
%      the existing singleton*.
%
%      PHASE_REC_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHASE_REC_GUI.M with the given input arguments.
%
%      PHASE_REC_GUI('Property','Value',...) creates a new PHASE_REC_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before phase_rec_GUI_OpeningFcn gets calledGP.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to phase_rec_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help phase_rec_GUI

% Last Modified by GUIDE v2.5 05-Oct-2014 23:22:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @phase_rec_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @phase_rec_GUI_OutputFcn, ...
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

% --- Executes just before phase_rec_GUI is made visible.
function phase_rec_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for phase_rec_GUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = phase_rec_GUI_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%     E D I T   B O X E S   &   I N P U T   S E L E C T I O N       %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%        D A T A  &  A L G O R I T H M   S E L E C T I O N          %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function filepathedit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function filepathedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in imstack2load.
function imstack2load_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function imstack2load_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function algo_select_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function stacknum_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function stacknum_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off');

% --- Executes during object creation, after setting all properties.
function stackslider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'enable', 'off');

function resultnum_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function resultnum_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off');

function sweepvalues_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function sweepvalues_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                G E N E R A L   P A R A M E T E R S                %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i0posedit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function i0posedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function iplusedit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function iplusedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function iminusedit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function iminusedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pixszedit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pixszedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lambdaedit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function lambdaedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function dzedit_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function dzedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                   S T A N D A R D   T I E                         %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function eps1edit_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function eps1edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function eps2edit_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function eps2edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                   I T E R A T I V E   T I E                       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function nloopsedit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function nloopsedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off')

function factoredit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function factoredit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off')

function currentresimage_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function currentresimage_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Enable', 'off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%               H I G H E R   O R D E R   T I E                     %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function numimgsedit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function numimgsedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'enable','off');

function indexstepedit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function indexstepedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Enable', 'off');

function polydegedit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function polydegedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'enable','off');

function sigmaedit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function sigmaedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Enable', 'off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%       G A U S S I A N   P R O C E S S   R E G R E S S I O N       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function binsedit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function binsedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%        G E R C H B E R G - S A X T O N   A L G O R I T H M        %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function gsiteredit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function gsiteredit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off');

function gsnumimgsedit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function gsnumimgsedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Enable', 'off');

% --- Executes during object creation, after setting all properties.
function gstype_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%       A L T E R N A T E  &  E X T R A   P A R A M E T E R S       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in zvec_select.
function zvec_select_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function zvec_select_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off');

% --- Executes during object creation, after setting all properties.
function dz_select_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Enable', 'off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                    S A V E   R E S U L T S                        %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function saveedit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function saveedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%                   H E L P   M E S S A G E S                       %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                G E N E R A L   P A R A M E T E R S                %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in i0poshelp.
function i0poshelp_Callback(hObject, eventdata, handles)
msgbox(['Choose the image index in the loaded image' ...
    ' stack corresponding to the center focal plane.'], ...
    'I0 Position','help');

% --- Executes on button press in iplushelp.
function iplushelp_Callback(hObject, eventdata, handles)
msgbox(['Choose the image index in the loaded image' ...
    ' stack corresponding to the focal plane that is a distance of' ...
    ' dz away from the center plane, I0.'], ...
    'I (+) Position','help');

% --- Executes on button press in iminushelp.
function iminushelp_Callback(hObject, eventdata, handles)
msgbox(['Choose the image index in the loaded image' ...
    ' stack corresponding to the focal plane that is a distance of' ...
    ' -dz away from the center plane, I0.'], ...
    'I (-) Position','help');

% --- Executes on button press in pixszhelp.
function pixszhelp_Callback(hObject, eventdata, handles)
msgbox('Enter the pixel size in meters (m).', ...
    'Pixel Size','help');

% --- Executes on button press in lambdahelp.
function lambdahelp_Callback(hObject, eventdata, handles)
msgbox('Enter the wavelength in meters (m).', ...
    'Pixel Size','help');

% --- Executes on button press in dzhelp.
function dzhelp_Callback(hObject, eventdata, handles)
msgbox(['Enter the z distance in meters (m) between the center focal' ...
    ' plane and either of the other two planes to be used in the' ... 
    ' computation of dI/dz.'],'Propagation Distance (dz)','help');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                    S T A N D A R D   T I E                        %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in epshelp.
function epshelp_Callback(hObject, eventdata, handles)
msgbox(['Enter the value to be used to prevent', ...
    ' division by zero when dividing by the Fourier transform of the', ...
    ' Laplacian operator.'], 'Laplacian Regularization','help');

% --- Executes on button press in eps2help.
function eps2help_Callback(hObject, eventdata, handles)
msgbox(['Enter a value to be added to the', ...
    ' intensity at the focal plane, I0, to prevent division by zero.'], ...
    'Intensity Regularization','help');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                   I T E R A T I V E   T I E                       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in iter_help.
function iter_help_Callback(hObject, eventdata, handles)
msgbox(['Enter the number of error substitution iterations you would like' ...
        ' the algorithm to perform. Associated with the ''Iterative TIE.'''], ...
        'Number of Iterations', 'help');
    
% --- Executes on button press in factor_help.
function factor_help_Callback(hObject, eventdata, handles)
msgbox(['Enter a value which will be used as a constant weighting factor' ...
        ' in each iteration. Associated with the ''Iterative TIE.'''], ...
        'Weighting Factor', 'help');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%               H I G H E R   O R D E R   T I E                     %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% --- Executes on button press in numimgshelp.
function numimgshelp_Callback(hObject, eventdata, handles)
msgbox(['Enter a value, N, that is less than half of the height of the' ...
        ' image stack. When the algorithm executes, the images' ...
        ' considered will be in the range [center - N, center + N].' ...
        ' Associated with the ''Higher Order TIE.'''], ...
        'Number of Images','help');

% --- Executes on button press in indexstephelp.
function indexstephelp_Callback(hObject, eventdata, handles)
msgbox(['Enter the step size for images to be used in the Higher Order '...
        'TIE computation. For example, a value of 1 will use all ' ...
        'images in the range [center - Num. Images, center + Num. ' ...
        'Images] while a value of 2 will use every other image in the ' ...
        'range [center - 2*Num. Images, center + 2*Num. Images].'], ...
        'Image index step size','help');
    
% --- Executes on button press in polydeghelp.
function polydeghelp_Callback(hObject, eventdata, handles)
msgbox(['Enter a value, d. Each pixel stack in the input image stack' ...
        ' will be interpolated to a polynomial of degree d. The value' ...
        ' chosen must be between 1 and 20. One can expect that very' ...
        ' high degrees will generally output noisier results and take' ...
        ' more time to generate them.'],'Polynomial Degree','help');

% --- Executes on button press in sigmahelp.
function sigmahelp_Callback(hObject, eventdata, handles)
msgbox('Enter a regularization value for polynomial interpolation.', ...
       'Sigma','help');
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%        G E R C H B E R G - S A X T O N   A L G O R I T H M        %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
   
% --- Executes on button press in gsiterhelp.
function gsiterhelp_Callback(hObject, eventdata, handles)
msgbox(['Enter the number of propagation iterations you would like the '...
        'selected variant of the Gerchberg-Saxton algorithm to '...
        'perform.'],'G-S Iterations','help');

% --- Executes on button press in gsnumimgshelp.
function gsnumimgshelp_Callback(hObject, eventdata, handles)
msgbox(['Enter the number of images on either side of the center plane '...
        ' that you would like the multiple-plane Gerchberg-Saxton ' ...
        ' algorithm to use.'],'G-S Number of Images','help');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
   
% --- Executes on button press in binshelp.
function binshelp_Callback(hObject, eventdata, handles)
msgbox(['Enter the number of bins to divide the frequency into. This ' ...
        'reduces the computational complexity of the GP Regression ' ...
        'method.'],'Number of bins','help');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%                  A C T I O N   B U T T O N S                      %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%                      L E F T   S I D E                            %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in dispimstack.
function dispimstack_Callback(hObject, eventdata, handles)
% extract variable name
contents = cellstr(get(handles.imstack2load,'String'));
stackname = contents{get(handles.imstack2load, 'Value')};

if(~(strcmp(stackname,'Select image stack variable ...')))
    evalin('base',['assignin(''caller'',''im_stack'',' stackname ');']);
    
    % plot middle image in stack
    set(handles.stackslider, 'enable', 'on');
    set(handles.stackslider, 'min', 1);
    set(handles.stackslider, 'max', size(im_stack,3));
    set(handles.stackslider, 'SliderStep', ...
        [1/size(im_stack,3) 1/size(im_stack,3)]);

    val = round(size(im_stack,3)/2);
    set(handles.stacknum, 'String', num2str(val));
    set(handles.stackslider, 'value', val);
    
    axes(handles.imstackaxes);
    ps = str2double(get(handles.pixszedit, 'String'));
    [m,n,~] = size(im_stack);
    
    imagesc([ps,ps*m],[ps,ps*n],im_stack(:,:,val), ...
        [min(min(min(im_stack))),max(max(max(im_stack)))]);
    colorbar

    % disable display button
    set(hObject, 'Enable', 'off');
    set(handles.imstack2load, 'Enable', 'off');
end

% --- Executes on button press in browsebutton.
function browsebutton_Callback(hObject, eventdata, handles)
% cd datasets
[filename, pathname] = uigetfile('*.mat','Select Image Stack Data to Load');
fullpathname = [pathname, filename];
if(ischar(fullpathname))
    set(handles.filepathedit, 'String', fullpathname);
end
cd ..

% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
imstackname = get(handles.filepathedit, 'String');
inst = ['load(''' imstackname ''');'];
try
    evalin('base',inst);
    load_vars_from_base(handles,1);
    str = get(handles.filepathedit, 'String');
    set(handles.filepathedit, 'String', str(max(strfind(str,filesep))+1:end));
    set(handles.filepathedit, 'enable', 'off');
    set(handles.browsebutton, 'enable', 'off');
    set(handles.loadbutton, 'enable', 'off');
    
    evalin('base',['if(exist(''lambda'',''var'')) ' ...
                   '    assignin(''caller'',''lambda'',num2str(lambda)); ' ...
                   'elseif(exist(''lam'',''var''))' ...
                   '    assignin(''caller'',''lambda'',num2str(lam)); ' ...
                   'else ' ...
                   '    assignin(''caller'',''lambda'',''''); ' ...
                   'end']);
    
    evalin('base',['if(exist(''ps'',''var'')) ' ...
                   '    assignin(''caller'',''ps'',num2str(ps)); ' ...
                   'else ' ...
                   '    assignin(''caller'',''ps'',''''); ' ...
                   'end']);
    
    set(handles.lambdaedit, 'String', lambda);
    set(handles.pixszedit, 'String', ps);
    
catch err
    msgbox(['Invalid file path entered. Selected file must have a ''-.mat''' ...
            ' extension.'], 'Invalid file', 'error');
end

% --- Executes on slider movement.
function stackslider_Callback(hObject, eventdata, handles)
contents = cellstr(get(handles.imstack2load,'String'));
stackname = contents{get(handles.imstack2load, 'Value')};
evalin('base',['assignin(''caller'', ''im_stack'',' stackname ');']);
val = round(get(hObject,'Value'));
set(handles.stacknum, 'String', num2str(val));
ps = str2double(get(handles.pixszedit, 'String'));
[m,n,~] = size(im_stack);

axes(handles.imstackaxes)
imagesc([ps,ps*m],[ps,ps*n],im_stack(:,:,val), ...
        [min(min(min(im_stack))),max(max(max(im_stack)))]);
colorbar

% --- Executes on button press in contrastbutton.
function contrastbutton_Callback(hObject, eventdata, handles)
contents = cellstr(get(handles.imstack2load,'String'));
stackname = contents{get(handles.imstack2load, 'Value')};
try
    evalin('base', ['assignin(''caller'',''im_stack'', ' stackname ');']);
    n = size(im_stack,3); contrasts = zeros(1,n);
    for i=1:n
        a = max(max(im_stack(:,:,i)));
        b = min(min(im_stack(:,:,i)));
        contrasts(i) = (a-b)/(a+b);
    end
    figure; plot(1:n, contrasts);
    title('Contrast vs. Image Index in Stack');
    ylabel('Contrast: (max-min)/(max+min)');
    xlabel('Image Index in Stack');
catch err
end
    
% --- Executes on button press in reset_button.
function reset_button_Callback(hObject, eventdata, handles)
% Reset axes to black
axes(handles.imstackaxes);
imagesc(zeros(500));
axes(handles.resultaxes);
imagesc(zeros(500));

ALL_OFF(handles);
reset_zvec_loader(handles);
        
% Turn on things
set(handles.i0posedit, 'enable', 'on');
set(handles.iplusedit, 'enable', 'on');
set(handles.iminusedit, 'enable', 'on');
set(handles.dzedit, 'enable', 'on');
set(handles.eps1edit, 'enable', 'on');
set(handles.eps2edit, 'enable', 'on');
set(handles.sweepparam, 'enable', 'on');

% Reset Data/Algorithm selection panel
set(handles.algo_select, 'Value', 1);
set(handles.stacknum, 'String', '');
set(handles.stackslider, 'enable', 'off');
set(handles.imstack2load, 'enable', 'on');
set(handles.imstack2load, 'String', 'Select image stack variable ...');
set(handles.imstack2load, 'Value', 1);
set(handles.filepathedit, 'enable', 'on');
set(handles.filepathedit, 'String', 'Enter file path ...');
set(handles.browsebutton, 'enable', 'on');
set(handles.loadbutton, 'enable', 'on');
set(handles.dispimstack, 'enable', 'on');
set(handles.sweepvalues, 'string', '');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%                     R I G H T   S I D E                           %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on selection change in gstype.
function gstype_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
type = contents{get(hObject,'Value')};

if(strcmp(type,'Single-plane propagation'))
    set(handles.gsnumimgsedit, 'Enable', 'off');
    
    set(handles.iplusedit, 'Enable', 'on');
    set(handles.iminusedit, 'Enable', 'on');
    set(handles.dzedit, 'Enable', 'on');
    
    reset_zvec_loader(handles);
    
elseif(strcmp(type,'Multiple-plane propagation'))
    set(handles.gsnumimgsedit, 'Enable', 'on');
    
    set(handles.iplusedit, 'Enable', 'off');
    set(handles.iminusedit, 'Enable', 'off');
    set(handles.dzedit, 'Enable', 'off');
    set(handles.zvec, 'Value', 1);
    set(handles.zvec, 'Enable', 'off');
    set(handles.dz_select, 'Value', 1);
    set(handles.dz_select, 'String', 'N/A');
    set(handles.zvec_select, 'Enable', 'On');
    set(handles.load_zvec, 'Enable', 'On');
    load_vars_from_base(handles, 2);
    
end

% --- Executes on slider movement.
function resultslider_Callback(hObject, eventdata, handles)
evalin('base','assignin(''caller'', ''Result'', RESULT);');
val = round(get(hObject,'Value'));
contents = cellstr(get(handles.sweepparam, 'String')); 
sweep = contents{get(handles.sweepparam, 'Value')};

if(~strcmp(sweep, '(None)'))
    expr = get(handles.sweepvalues, 'String');
    eval(['svals = ' expr ';']);
    set(handles.resultnum, 'String', num2str(svals(val)));    
else
    set(handles.resultnum, 'String', num2str(val));
end

axes(handles.resultaxes)
ps = str2double(get(handles.pixszedit, 'String'));
[m,n,~] = size(Result);
imagesc([ps,ps*m],[ps,ps*n],Result(:,:,val), ...
    [min(min(min(Result))), max(max(max(Result)))]);
colorbar

% --- Executes during object creation, after setting all properties.
function resultslider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'enable', 'off');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%      A L T E R N A T E   &   E X T R A   P A R A M E T E R S      %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in zvec.
function zvec_Callback(hObject, eventdata, handles)
x = get(hObject,'Value');
if(x == 1)
    set(handles.iplusedit, 'enable', 'off');
    set(handles.iminusedit, 'enable', 'off');
    set(handles.dzedit, 'enable', 'off');
    set(handles.zvec_select, 'enable', 'on');
    set(handles.load_zvec, 'enable', 'on');
    load_vars_from_base(handles,2);
else
    set(handles.iplusedit, 'enable', 'on');
    set(handles.iminusedit, 'enable', 'on');
    set(handles.dzedit, 'enable', 'on')
    
    set(handles.zvec_select, 'enable', 'off');
    set(handles.zvec_select, 'String', 'Select z-vector ...');
    set(handles.zvec_select, 'Value', 1);
    
    set(handles.dz_select, 'String', 'Select dz value ...');
    set(handles.dz_select, 'Value', 1);
    set(handles.dz_select, 'Enable', 'off');
end

% --- Executes on button press in load_zvec.
function load_zvec_Callback(hObject, eventdata, handles)
set(handles.zvec_select, 'enable', 'off');
set(hObject, 'enable', 'off');

contents = cellstr(get(handles.algo_select,'String'));
algo = contents{get(handles.algo_select,'Value')};

ok = 1;

switch algo
    case 'Higher Order TIE'
        ok = 0;
    case 'GP Regression'
        ok = 0;
    case 'Gerchberg-Saxton'
        contents = cellstr(get(handles.gstype,'String'));
        type = contents{get(handles.gstype,'Value')};
        if(strcmp(type,'Multiple-plane propagation'))
            ok = 0;
        end
end

if(ok)
    set(handles.dz_select, 'Enable', 'on');

    % get z_vector
    contents = cellstr(get(handles.zvec_select,'String'));
    zvec_name = contents{get(handles.zvec_select,'Value')};
    evalin('base', ['assignin(''caller'',''zvec'', ' zvec_name ');']);

    len = length(zvec);
    dzs = cell(len,1);
    for x = 1:len
        if (zvec(x) > 0 && ~isempty(find((zvec == -1*zvec(x)),1)))
            dzs{x} = num2str(zvec(x));
        end
    end
    dzs = dzs(~cellfun('isempty',dzs));

    set(handles.dz_select, 'String', dzs);
end

% --- Executes on selection change in dz_select.
function dz_select_Callback(hObject, eventdata, handles)
% Get number selected
contents = cellstr(get(hObject,'String'));
value = str2double(contents{get(hObject, 'Value')});
set(handles.dzedit, 'String', num2str(value));

% Get zvec name
contents = cellstr(get(handles.zvec_select,'String'));
zvec = contents{get(handles.zvec_select, 'Value')};

evalin('base', ['assignin(''caller'',''zvec'',' zvec ');']);
Ip_idx = find(((zvec - value).^2 < eps^2),1);
Im_idx = find(((zvec + value).^2 < eps^2),1);
I0_idx = find((zvec.^2 < eps^2),1);

set(handles.iplusedit, 'String', num2str(Ip_idx));
set(handles.iminusedit, 'String', num2str(Im_idx));
set(handles.i0posedit, 'String', num2str(I0_idx));

% --- Executes on button press in reflect.
function reflect_Callback(hObject, eventdata, handles)
x = get(hObject, 'Value');
if(x)
    msgbox(['Warning: Selecting this option quadruples the size of' ...
            ' the input image, and may therefore quadruple computation' ...
            ' time.'], 'Warning', 'warn');
end

% --- Executes on button press in bw.
function bw_Callback(hObject, eventdata, handles)
axes(handles.imstackaxes);
colormap gray

% --- Executes on button press in jet.
function jet_Callback(hObject, eventdata, handles)
axes(handles.imstackaxes);
colormap jet

% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
cd bin
result_exist;
cd ..
try
    if(~isempty(Result))
        name = get(handles.saveedit, 'String');
        if(~strcmp(name,'Save Result as ...'))
            cd results
            save([name '.mat'], 'Result');
            msgbox('Saved successfully!','Save complete','help');
            cd ..
        end
    end
catch err
    msgbox(['Invalid file name entered. Please choose a different name' ...
            ' for your save file.'],'Invalid file name', 'error');
end

% --- Executes on selection change in sweepparam.
function sweepparam_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
sel = contents{get(hObject,'Value')};

contents = cellstr(get(handles.algo_select,'String'));
algo = contents{get(handles.algo_select,'Value')};

switch sel
    case 'Laplacian'
        set(handles.eps1edit, 'enable', 'off');
        set(handles.eps2edit, 'enable', 'on');
        if(strcmp(algo,'Higher Order TIE'))
            set(handles.sigmaedit, 'enable', 'on');
        end
        set(handles.sweepvalues, 'enable', 'on');
    case 'Intensity'
        set(handles.eps2edit, 'enable', 'off');
        set(handles.eps1edit, 'enable', 'on');
        if(strcmp(algo,'Higher Order TIE'))
            set(handles.sigmaedit, 'enable', 'on');
        end
        set(handles.sweepvalues, 'enable', 'on');
    case 'Interpolation'
        set(handles.sigmaedit, 'enable', 'off');
        set(handles.eps1edit, 'enable', 'on');
        set(handles.eps2edit, 'enable', 'on');
        set(handles.sweepvalues, 'enable', 'on');
    otherwise
        set(handles.sweepvalues, 'enable', 'off');
        set(handles.eps1edit, 'enable', 'on');
        set(handles.eps2edit, 'enable', 'on');
        if(strcmp(algo,'Higher Order TIE'))
            set(handles.sigmaedit, 'enable', 'on');
        end
end

% --- Executes during object creation, after setting all properties.
function sweepparam_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%              A L G O R I T H M   S E L E C T I O N                %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in algo_select.
function algo_select_Callback(hObject, eventdata, handles)

contents = cellstr(get(hObject,'String')); 
sel = contents{get(hObject,'Value')};

switch sel
    case 'Standard TIE'
        
        ALL_OFF(handles);
        reset_zvec_loader(handles);
        
        % Turn on things
        set(handles.i0posedit, 'enable', 'on');
        set(handles.iplusedit, 'enable', 'on');
        set(handles.iminusedit, 'enable', 'on');
        set(handles.dzedit, 'enable', 'on');
        set(handles.eps1edit, 'enable', 'on');
        set(handles.eps2edit, 'enable', 'on');
        set(handles.sweepparam, 'enable', 'on');
        set(handles.sweepparam, 'value', 1);
        str = get(handles.sweepparam, 'string');
        set(handles.sweepparam, 'string', str(1:3));
        
    case 'Iterative TIE'
        
        ALL_OFF(handles);
        reset_zvec_loader(handles);
        
        % Turn on things that may have been turned off
        set(handles.nloopsedit, 'enable', 'on');
        set(handles.factoredit, 'enable', 'on');
        set(handles.i0posedit, 'enable', 'on');
        set(handles.iplusedit, 'enable', 'on');
        set(handles.iminusedit, 'enable', 'on');
        set(handles.dzedit, 'enable', 'on');
        set(handles.eps1edit, 'enable', 'on');
        set(handles.eps2edit, 'enable', 'on');
        set(handles.sweepparam, 'enable', 'on');
        set(handles.sweepparam, 'value', 1);
        str = get(handles.sweepparam, 'string');
        set(handles.sweepparam, 'string', str(1:3));
    
    case 'Higher Order TIE'

        % Turn off unnecessary stuff
        ALL_OFF(handles);
        set(handles.dz_select, 'String', 'N/A');
        set(handles.dz_select, 'Value', 1);
        
        % Turn on things
        set(handles.eps1edit, 'enable', 'on');
        set(handles.eps2edit, 'enable', 'on');
        
        set(handles.numimgsedit, 'enable', 'on');
        set(handles.indexstepedit, 'enable', 'on');
        set(handles.polydegedit, 'enable', 'on');
        set(handles.sigmaedit, 'enable', 'on');

        set(handles.zvec, 'Value', 1);
        set(handles.zvec, 'Enable', 'off');
        set(handles.zvec_select, 'enable', 'on');
        load_vars_from_base(handles, 2);
        set(handles.load_zvec, 'enable', 'on');
        
        set(handles.sweepparam, 'enable', 'on');
        set(handles.sweepparam, 'value', 1);
        str = get(handles.sweepparam, 'string');
        set(handles.sweepparam, 'string', [str; 'Interpolation']);
        
        
    case 'GP Regression'
        
        % Turn off unnecessary stuff
        ALL_OFF(handles);
        reset_zvec_loader(handles);
        
        % Turn on things that may have been turned off
        
        set(handles.i0posedit, 'enable', 'on');
        set(handles.eps1edit, 'enable', 'on');
        set(handles.eps2edit, 'enable', 'on');
        set(handles.zvec, 'Value', 1);
        set(handles.zvec, 'Enable', 'off');
        set(handles.zvec_select, 'enable', 'on');
        set(handles.dz_select, 'String', 'N/A');
        set(handles.dz_select, 'Value', 1);
        load_vars_from_base(handles, 2);
        set(handles.load_zvec, 'enable', 'on');
        set(handles.binsedit, 'enable', 'on');
        set(handles.sweepparam, 'enable', 'on');
        set(handles.sweepparam, 'value', 1);
        
    case 'Gerchberg-Saxton'
        
        ALL_OFF(handles);
        reset_zvec_loader(handles);
        
        set(handles.i0posedit, 'enable', 'on');
        set(handles.iplusedit, 'enable', 'on');
        set(handles.iminusedit, 'enable', 'on');
        set(handles.dzedit, 'enable', 'on');
        set(handles.gsiteredit, 'enable', 'on');
        set(handles.gstype, 'enable', 'on');
        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%       G E N E R A T E   A L L   R E S U L T S   ( R U N )         %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in runbutton.
function runbutton_Callback(hObject, eventdata, handles)
% Clear current result display window
axes(handles.resultaxes);
imagesc(zeros(500));
drawnow

curr_folder = pwd;

try
    
% Get image stack name
contents = cellstr(get(handles.imstack2load,'String'));
stackname = contents{get(handles.imstack2load, 'Value')};

% Determine the algorithm the user selected
contents = cellstr(get(handles.algo_select,'String')); 
sel = contents{get(handles.algo_select,'Value')};

% Check if sweep is necessary
contents = cellstr(get(handles.sweepparam, 'String')); 
sweep = contents{get(handles.sweepparam, 'Value')};
if(~strcmp(sweep,'(None)'))
    expr = get(handles.sweepvalues, 'String');
    eval(['svals = ' expr ';']);
    evalin('base',['temp = zeros(size(' stackname ',1),size(' stackname ...
        ',2),' num2str(length(svals)) ');']);
end

switch sel
    case 'Standard TIE'
        switch sweep
            case '(None)'
                std_recur_TIE(handles,'standard');
            case 'Laplacian'
                for q = 1: length(svals);
                    set(handles.eps1edit, 'string', num2str(svals(q)));
                    std_recur_TIE(handles,'standard');
                    evalin('base',['temp(:,:,' num2str(q) ') = RESULT;']);
                end
                evalin('base','RESULT = temp; clear temp;')
                set(handles.eps1edit, 'string', '');
                
            case 'Intensity'
                for q = 1: length(svals);
                    set(handles.eps2edit, 'string', num2str(svals(q)));
                    std_recur_TIE(handles,'standard');
                    evalin('base',['temp(:,:,' num2str(q) ') = RESULT;']);
                end
                evalin('base','RESULT = temp; clear temp;')
                set(handles.eps2edit, 'string', '');
                
        end
        handle_result(handles);
        
    case 'Iterative TIE'
        switch sweep
            case '(None)'
                std_recur_TIE(handles,'recursive');
            case 'Laplacian'
                for q = 1: length(svals);
                    set(handles.eps1edit, 'string', num2str(svals(q)));
                    std_recur_TIE(handles,'recursive');
                    evalin('base',['temp(:,:,' num2str(q) ...
                        ') = RESULT(:,:,end);']);
                end
                evalin('base','RESULT = temp; clear temp;')
                set(handles.eps1edit, 'string', '');
                
            case 'Intensity'
                for q = 1: length(svals);
                    set(handles.eps2edit, 'string', num2str(svals(q)));
                    std_recur_TIE(handles,'recursive');
                    evalin('base',['temp(:,:,' num2str(q) ...
                        ') = RESULT(:,:,end);']);
                end
                evalin('base','RESULT = temp; clear temp;')
                set(handles.eps2edit, 'string', '');
                
        end
        handle_result(handles);
        
    case 'Higher Order TIE'
        switch sweep
            case '(None)'
                ho_tie_run(handles);
            case 'Laplacian'
                for q = 1: length(svals);
                    set(handles.eps1edit, 'string', num2str(svals(q)));
                    ho_tie_run(handles);
                    evalin('base',['temp(:,:,' num2str(q) ') = RESULT;']);
                end
                evalin('base','RESULT = temp; clear temp;')
                set(handles.eps1edit, 'string', '');
                
            case 'Intensity'
                for q = 1: length(svals);
                    set(handles.eps2edit, 'string', num2str(svals(q)));
                    ho_tie_run(handles);
                    evalin('base',['temp(:,:,' num2str(q) ') = RESULT;']);
                end
                evalin('base','RESULT = temp; clear temp;')
                set(handles.eps2edit, 'string', '');
                
            case 'Interpolation'
                for q = 1: length(svals);
                    set(handles.sigmaedit, 'string', num2str(svals(q)));
                    ho_tie_run(handles);
                    evalin('base',['temp(:,:,' num2str(q) ') = RESULT;']);
                end
                evalin('base','RESULT = temp; clear temp;')
                set(handles.sigmaedit, 'string', '');
                
        end
        handle_result(handles);
        
    case 'GP Regression'
        switch sweep
            case '(None)'
                gp_tie(handles);
            case 'Laplacian'
                for q = 1: length(svals);
                    set(handles.eps1edit, 'string', num2str(svals(q)));
                    gp_tie(handles);
                    evalin('base',['temp(:,:,' num2str(q) ...
                        ') = RESULT(:,:,end);']);
                end
                evalin('base','RESULT = temp; clear temp;')
                set(handles.eps1edit, 'string', '');
                
            case 'Intensity'
                for q = 1: length(svals);
                    set(handles.eps2edit, 'string', num2str(svals(q)));
                    gp_tie(handles,'recursive');
                    evalin('base',['temp(:,:,' num2str(q) ...
                        ') = RESULT(:,:,end);']);
                end
                evalin('base','RESULT = temp; clear temp;')
                set(handles.eps2edit, 'string', '');
                
        end
        handle_result(handles);
        
    case 'Gerchberg-Saxton'
        % Get image stack name
        contents = cellstr(get(handles.gstype,'String'));
        gs_type = contents{get(handles.gstype, 'Value')};
        
        if(strcmp(gs_type,'Single-plane propagation'))
            gs_sp_run(handles);
        elseif(strcmp(gs_type,'Multiple-plane propagation'))
            gs_mp_run(handles);
        end
                
end
catch err
    message = {'Something went wrong. Here are some suggestions:'; ...
            ' '; ...
            ' (1) Make sure image stack has been loaded properly.'; ...
            ' '; ...
            ' (2) Check entered parameters for errors. Check that'; ...
            ' numbers are in a form that can be converted from strings.';...
            ' For example, "10^3" will not work, but "1e3" will.'; ...
            ' Similarly, "1/2" will not work, but "0.5" will.'; ...
            ' '; ...
            ' (3) Some algorithms require a valid z-vector to'; ...
            ' function correctly. This must be a row or column vector'; ...
            ' whose length is equal to the number of images in the'; ...
            ' chosen image stack.'; ...
            ' '; ...
            ' (4) Make sure your computer has enough memory for the'; ...
            ' computation.'};
    msgbox(message, 'Oops...', 'error');
    evalin('base',['cd(' curr_folder ');']);
end

function std_recur_TIE(handles,str)
% Extract user input data from edit text boxes
% The next executed line is equivalent to one of the following:
% STANDARD:  arr = [ i0pos, i+pos, i-pos, ps, lam, dz, eps, epsI, reflect ];
% RECURSIVE: arr = [ i0pos, i+pos, i-pos, ps, lam, dz, eps, epsI, reflect, nloops, factor ];

ok = 1;
arr = [ str2double(get(handles.i0posedit, 'String')), ...
        str2double(get(handles.iplusedit, 'String')), ...
        str2double(get(handles.iminusedit, 'String')), ...
        str2double(get(handles.pixszedit, 'String')), ...
        str2double(get(handles.lambdaedit, 'String')), ...
        str2double(get(handles.dzedit, 'String')), ...
        str2double(get(handles.eps1edit, 'String')), ...
        str2double(get(handles.eps2edit, 'String')), ...
        get(handles.reflect, 'Value')   ];
    
% If recursive, arr needs to contain two more function inputs    
if(strcmp(str,'recursive'))
    nloops = str2double(get(handles.nloopsedit, 'String'));
    factor = str2double(get(handles.factoredit, 'String'));
    arr = [arr, nloops, factor];
end

% Check that no input values are NaN
if(ok && ismember(1,isnan(arr)))
    ok = 0;
end

if(ok)
    
    % Get image stack name
    contents = cellstr(get(handles.imstack2load,'String'));
    stackname = contents{get(handles.imstack2load, 'Value')};
    
    % Construct command to be evaluated in base
    assignin('base', 'IN_DATA', arr);
    if(strcmp(str,'standard'))
        command = 'tie';
        x_args =  '';
    elseif(strcmp(str,'recursive'))
        command = 'tie_recur';
        x_args =  ', IN_DATA(10), IN_DATA(11)';
    end

    inst1 =   'RESULT = ';

    inst2 = [ '(' stackname '(:,:,IN_DATA(3)), ' stackname '(:,:,IN_DATA(1))'...
              ', ' stackname '(:,:,IN_DATA(2)),', ...
              '       IN_DATA(4), IN_DATA(5), IN_DATA(6),', ...
              '       IN_DATA(7), IN_DATA(8), IN_DATA(9)'];


    inst = ['cd ' command ';' inst1 command inst2 x_args ');'];
    clear command x_args inst1 inst2

    try
        evalin('base', inst);        
                    
    catch err
        throw(ME);
    end
    evalin('base','cd ..');
end

function ho_tie_run(handles)
% Extract user input data from edit text boxes
% The next executed line is equivalent to the following:
% arr = [ num_img, indx_step, ps, lambda, deg, sigma, eps, epsI, reflect ];

ok = 1;
arr = [ str2double(get(handles.numimgsedit, 'String')), ...
        str2double(get(handles.indexstepedit, 'String')), ...
        str2double(get(handles.pixszedit, 'String')), ...
        str2double(get(handles.lambdaedit, 'String')), ...
        str2double(get(handles.polydegedit, 'String')), ...
        str2double(get(handles.sigmaedit, 'String')), ...
        str2double(get(handles.eps1edit, 'String')), ...
        str2double(get(handles.eps2edit, 'String')), ...
        get(handles.reflect, 'Value')   ];

% Check that no input values are NaN
if(ismember(1,isnan(arr)))
    ok = 0;
end

% Get z_vector name
contents = cellstr(get(handles.zvec_select,'String'));
zvec_name = contents{get(handles.zvec_select, 'Value')};
    
% Check that a z_vector exists and is valid
evalin('base', ['assignin(''caller'',''zvec_exist'',exist(''' ... 
    zvec_name ''',''var''));']);
if(ok && ~zvec_exist)
    ok = 0;
elseif(ok && zvec_exist)
    ok = check_zvec(handles);
end

% Check that order is greater than 0
if(ok && (arr(5) < 1 ))
    ok = 0;
end

if(ok)
    assignin('base', 'IN_DATA', arr);
    
    % Get image stack name
    contents = cellstr(get(handles.imstack2load,'String'));
    stackname = contents{get(handles.imstack2load, 'Value')};
        
    inst = ['cd ho_tie; ' ... 
            'RESULT = ho_tie(' stackname ',IN_DATA(1),IN_DATA(2),' ...
            'IN_DATA(3),IN_DATA(4),' zvec_name ',IN_DATA(5),IN_DATA(6),'...
            'IN_DATA(7),IN_DATA(8),IN_DATA(9));'   ];
         
    try
        evalin('base',inst);
        handle_result(handles);
    
    catch err
        throw(ME);
    end
    
    evalin('base','cd ..');
    
end

function gp_tie(handles)
% Extract user input data from edit text boxes
ok = 1;

arr = [ str2double(get(handles.lambdaedit, 'String')), ...
        str2double(get(handles.pixszedit, 'String')), ...
        str2double(get(handles.i0posedit, 'String')), ...
        str2double(get(handles.eps1edit, 'String')), ...
        str2double(get(handles.eps2edit, 'String')), ...
        str2double(get(handles.binsedit, 'String')), ...
        get(handles.reflect, 'Value')                   ];

% Check that no input values are NaN
if(ismember(1,isnan(arr)))
    ok = 0;
end

% Get z_vector name
contents = cellstr(get(handles.zvec_select,'String'));
zvec_name = contents{get(handles.zvec_select, 'Value')};

% Check that a z_vector exists and is valid
evalin('base', ['assignin(''caller'',''zvec_exist'',exist(''' ... 
    zvec_name ''',''var''));']);

if(ok && ~zvec_exist)
    ok = 0;
elseif(ok && zvec_exist)
    ok = check_zvec(handles);
end

% Check that number of bins is greater than 1
if(ok && (arr(6) < 1))
    ok = 0;
end

if(ok)
    assignin('base', 'IN_DATA', arr);
    
    % Get image stack name
    contents = cellstr(get(handles.imstack2load,'String'));
    stackname = contents{get(handles.imstack2load, 'Value')};
    
    %GP_TIE(Ividmeas1,z1,lambda,ps,zfocus1,Nsl,eps1,eps2,reflect)
    inst = ['cd gp_tie; ' ... 
             'RESULT = GP_TIE(' stackname ',' zvec_name ',IN_DATA(1),' ...
             'IN_DATA(2),IN_DATA(3),IN_DATA(6),' ...
             'IN_DATA(4),IN_DATA(5),IN_DATA(7));'   ];
         
    try
        evalin('base',inst);
    
    catch err
        throw(err);
    end
    
    evalin('base','cd ..');  
end

function gs_sp_run(handles)
ok = 1;
arr = [ str2double(get(handles.iminusedit, 'String')), ...
        str2double(get(handles.i0posedit, 'String')), ...
        str2double(get(handles.iplusedit, 'String')), ...        
        str2double(get(handles.dzedit, 'String')), ...
        str2double(get(handles.pixszedit, 'String')), ...
        str2double(get(handles.lambdaedit, 'String')), ...
        str2double(get(handles.gsiteredit, 'String')) ];
    
% Check that no input values are NaN
if(ismember(1,isnan(arr)))
    ok = 0;
end   

if(get(handles.zvec, 'Value') == 1)
    % Get z_vector name
    contents = cellstr(get(handles.zvec_select,'String'));
    zvec_name = contents{get(handles.zvec_select, 'Value')};

    % Check that a z_vector exists and is valid
    evalin('base', ['assignin(''caller'',''zvec_exist'',exist(''' ... 
        zvec_name ''',''var''));']);
    if(ok && zvec_exist)
        ok = check_zvec(handles);
    end
end

if(ok)
    assignin('base', 'IN_DATA', arr);
    
    % Get image stack name
    contents = cellstr(get(handles.imstack2load,'String'));
    stackname = contents{get(handles.imstack2load, 'Value')};
        
    inst = ['cd gerchberg-saxton; ' ... 
            'RESULT = gs_single_plane(' stackname '(:,:,IN_DATA(1)),' ...
            stackname '(:,:,IN_DATA(2)),' stackname '(:,:,IN_DATA(3)),' ...
            'IN_DATA(4),IN_DATA(5),IN_DATA(6),IN_DATA(7));'   ];
         
    try
        evalin('base',inst);
        handle_result(handles);
        
    catch err
        throw(ME);
    end
  
    evalin('base','cd ..');
end

function gs_mp_run(handles)
ok = 1;
arr = [ str2double(get(handles.i0posedit, 'String')), ...
        str2double(get(handles.gsnumimgsedit, 'String')), ...
        str2double(get(handles.pixszedit, 'String')), ...
        str2double(get(handles.lambdaedit, 'String')), ...
        str2double(get(handles.gsiteredit, 'String')) ];
    
% Check that no input values are NaN
if(ismember(1,isnan(arr)))
    ok = 0;
end   

% Get z_vector name
contents = cellstr(get(handles.zvec_select,'String'));
zvec_name = contents{get(handles.zvec_select, 'Value')};

% Check that a z_vector exists and is valid
evalin('base', ['assignin(''caller'',''zvec_exist'',exist(''' ... 
    zvec_name ''',''var''));']);
if(ok && zvec_exist)
    ok = check_zvec(handles);
end

if(ok)
    assignin('base', 'IN_DATA', arr);
    
    % Get image stack name
    contents = cellstr(get(handles.imstack2load,'String'));
    stackname = contents{get(handles.imstack2load, 'Value')};
        
    inst = ['cd gerchberg-saxton; ' ... 
            'RESULT = gs_multiple_plane(' stackname ',IN_DATA(1),' ...
            zvec_name ',IN_DATA(2),IN_DATA(3),IN_DATA(4),IN_DATA(5));'];
         
    try
        evalin('base',inst);
        handle_result(handles);
        
    catch err
        throw(ME);
    end

    evalin('base','cd ..');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%            A C T I O N   B U T T O N   H E L P E R S              %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ ok ] = check_zvec(handles)
ok = 1;    

% get im_stack
contents = cellstr(get(handles.imstack2load,'String'));
stackname = contents{get(handles.imstack2load, 'Value')};
evalin('base', ['assignin(''caller'',''im_stack'', ' stackname ');']);

% get z_vector
contents = cellstr(get(handles.zvec_select,'String'));
zvec_name = contents{get(handles.zvec_select,'Value')};
evalin('base', ['assignin(''caller'',''zvec'', ' zvec_name ');']);

a = (isrow(zvec) || iscolumn(zvec));
b = (length(zvec) == size(im_stack,3));
c = (length(unique(zvec)) == length(zvec));
zvec_valid = (a && b && c);

if(~zvec_valid)
    ok = 0;
end

function load_vars_from_base(handles, opt)
% takes in a handle to a popup menu and loads a list of variables from the
% base workspace to its 'String' parameter.

evalin('base','vars = who;');
evalin('base','assignin(''caller'',''vars'',vars);');
evalin('base','clear vars');

vars = filter_vars(vars);

switch opt
    case 1
        vars = vars(~strcmp(vars,'zvec'));
        vars = vars(~strcmp(vars,'z_vector'));
    case 2
        vars = vars(~strcmp(vars,'im_stack'));
end
if(isempty(vars))
    vars = {'No viable z-vectors found.'};
    set(handles.load_zvec, 'enable', 'off');
    set(handles.zvec_select, 'enable', 'off');
    set(handles.iplusedit, 'enable', 'on');
end
switch opt
    case 1
        set(handles.imstack2load, 'String', vars);
    case 2
        set(handles.zvec_select,'String',vars);
end

function [ ] = handle_result(handles)
evalin('base','assignin(''caller'',''Result'', RESULT);');
ps = str2double(get(handles.pixszedit, 'string'));
[m,n,h] = size(Result);
contents = cellstr(get(handles.sweepparam, 'String')); 
sweep = contents{get(handles.sweepparam, 'Value')};

if(h > 1)
    if(~strcmp(sweep, '(None)'))
        expr = get(handles.sweepvalues, 'String');
        eval(['svals = ' expr ';']);
        set(handles.resultnum, 'String', num2str(svals(h)));    
    else
        set(handles.resultnum, 'String', num2str(h));
    end
    
    set(handles.resultslider, 'enable', 'on');
    set(handles.resultslider, 'min', 1);
    set(handles.resultslider, 'max', size(Result,3));
    set(handles.resultslider, 'SliderStep', ...
        [1/size(Result,3) 1/size(Result,3)]);
    set(handles.resultslider, 'value', h);
end

axes(handles.resultaxes);
imagesc([ps,ps*m],[ps,ps*n],Result(:,:,h), [min(min(min(Result))), ...
    max(max(max(Result)))]);
colorbar

function [ vars ] = filter_vars(vars)
% Remove internal/inappropriate variables from selection list
vars = vars(~strcmp(vars,'vars'));
vars = vars(~strcmp(vars,'lambda'));
vars = vars(~strcmp(vars,'lam'));
vars = vars(~strcmp(vars,'ps'));
vars = vars(~strcmp(vars,'TIE_IN_DATA'));
vars = vars(~strcmp(vars,'RESULT'));

function ALL_OFF(handles)
% General parameters
set(handles.i0posedit, 'enable', 'off');
set(handles.iplusedit, 'enable', 'off');
set(handles.iminusedit, 'enable', 'off');
set(handles.dzedit, 'enable', 'off');

% Standard TIE parameters
set(handles.eps1edit, 'enable', 'off');
set(handles.eps2edit, 'enable', 'off');

% Iterative TIE parameters
set(handles.nloopsedit, 'enable', 'off');
set(handles.factoredit, 'enable', 'off');
set(handles.resultslider, 'enable', 'off');
set(handles.resultnum, 'enable', 'off');

% Higher Order TIE parameters 
set(handles.numimgsedit, 'enable', 'off');
set(handles.indexstepedit, 'enable', 'off');
set(handles.polydegedit, 'enable', 'off');
set(handles.sigmaedit, 'enable', 'off');

% GP Regression parameters
set(handles.binsedit, 'enable', 'off');

% Gerchberg-Saxton parameters
set(handles.gsiteredit, 'enable', 'off');
set(handles.gstype, 'Value', 1);
set(handles.gstype, 'Enable', 'off');
set(handles.gsnumimgsedit, 'enable', 'off');

% Regularization Sweep
set(handles.sweepparam, 'enable', 'off');
set(handles.sweepparam, 'value', 1);
set(handles.sweepvalues, 'enable' , 'off');

function reset_zvec_loader(handles)
set(handles.zvec, 'Value', 0);
set(handles.zvec, 'Enable', 'on');
set(handles.load_zvec, 'enable', 'off');
set(handles.zvec_select, 'enable', 'off');
set(handles.zvec_select, 'value', 1);
set(handles.zvec_select, 'String', 'Select z vector ...');
set(handles.dz_select, 'String', 'Select dz value ...');
set(handles.dz_select, 'enable', 'off');
set(handles.dz_select, 'value', 1);

% -------------------------------------------------------------------------
% SHAMELESS SELF-PROMOTION BUTTON
function about_Callback(hObject, eventdata, handles)
cd bin
img = imread('seal.jpg');
cd ..
msgbox(['This application was created by Gautam Gunjala,' ...
    ' B.S. Electrical Engineering & Computer Science, B.S. Engineering' ...
    ' Mathematics and Statistics, 2016, at the University of California,' ...
    ' Berkeley. Affiliated with the Computational Imaging Lab and Prof.' ...
    ' Laura Waller (http://www.laurawaller.com).'], ...
    'About','custom',img)


