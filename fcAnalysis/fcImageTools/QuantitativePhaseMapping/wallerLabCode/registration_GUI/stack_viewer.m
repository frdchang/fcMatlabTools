function varargout = stack_viewer(varargin)
% STACK_VIEWER MATLAB code for stack_viewer.fig
%      STACK_VIEWER, by itself, creates a new STACK_VIEWER or raises the existing
%      singleton*.
%
%      H = STACK_VIEWER returns the handle to a new STACK_VIEWER or the handle to
%      the existing singleton*.
%
%      STACK_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STACK_VIEWER.M with the given input arguments.
%
%      STACK_VIEWER('Property','Value',...) creates a new STACK_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stack_viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stack_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stack_viewer

% Last Modified by GUIDE v2.5 05-Oct-2014 20:20:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stack_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @stack_viewer_OutputFcn, ...
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

% --- Executes just before stack_viewer is made visible.
function stack_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
axes(handles.dispaxes)
imagesc(zeros(500));

% --- Outputs from this function are returned to the command line.
function varargout = stack_viewer_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% -------------------------------------------------------------------------
% EDIT FILE PATH
function filepathedit_Callback(hObject, eventdata, handles)

function filepathedit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% BROWSE BUTTON
function browsebutton_Callback(hObject, eventdata, handles)
cd datasets
[filename, pathname] = uigetfile('*.mat','Select Image Stack Data to Load');
fullpathname = [pathname, filename];
if(ischar(fullpathname))
    set(handles.filepathedit, 'String', fullpathname);
end
cd ..
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% LOAD BUTTON
function loadbutton_Callback(hObject, eventdata, handles)
imstackname = get(handles.filepathedit, 'String');
inst = ['load(''' imstackname ''');'];
try
    evalin('base',inst);
    load_vars(handles);

catch err
    msgbox('Error loading data set. Try again.', 'Error', 'error');
end
% ------------------------------------------------------------------------- 

% -------------------------------------------------------------------------
% SLIDER ACTIONS
function slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_Callback(hObject, eventdata, handles)
contents = cellstr(get(handles.stack_select,'String'));
stackname = contents{get(handles.stack_select, 'Value')};
evalin('base',['assignin(''caller'', ''stack'', ' stackname ');']);

val = round(get(hObject,'Value'));
set(handles.curr_val, 'String', num2str(val));

axes(handles.dispaxes)
imagesc(stack(:,:,val), [min(min(min(stack))),max(max(max(stack)))])

% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% VARIABLE SELECTION MENU
function stack_select_Callback(hObject, eventdata, handles)

function stack_select_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% INITIALIZE DISPLAY
function dispbutton_Callback(hObject, eventdata, handles)
contents = cellstr(get(handles.stack_select,'String'));
stackname = contents{get(handles.stack_select, 'Value')};

evalin('base',['assignin(''caller'', ''stack'', ' stackname ');']);
set(handles.slider, 'min', 1);
set(handles.slider, 'max', size(stack,3));
set(handles.slider, 'SliderStep', [1/size(stack,3) 1/size(stack,3)]);

val = round(size(stack,3)/2);
set(handles.curr_val, 'String', num2str(val));
set(handles.slider, 'value', val);

axes(handles.dispaxes)
imagesc(stack(:,:,val), [min(min(min(stack))),max(max(max(stack)))])
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% COLORMAP SELECTION BUTTONS 
function graybutton_Callback(hObject, eventdata, handles)
axes(handles.dispaxes)
colormap gray

% --- Executes on button press in jetbutton.
function jetbutton_Callback(hObject, eventdata, handles)
axes(handles.dispaxes)
colormap jet
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% CURRENT VALUE DISPLAY
function curr_val_Callback(hObject, eventdata, handles)

function curr_val_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'enable', 'off')
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% HELPER FUNCTIONS
function load_vars(handles)
evalin('base','vars = who;');
evalin('base','assignin(''caller'',''vars'',vars);');
evalin('base','clear vars');
vars = filter_vars(vars);
set(handles.stack_select, 'String', vars);

function [ vars ] = filter_vars(vars)
vars = vars(~strcmp(vars,'vars'));
vars = vars(~strcmp(vars,'lambda'));
vars = vars(~strcmp(vars,'lam'));
vars = vars(~strcmp(vars,'ps'));
vars = vars(~strcmp(vars,'zvec'));
vars = vars(~strcmp(vars,'z_vector'));
% -------------------------------------------------------------------------

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
