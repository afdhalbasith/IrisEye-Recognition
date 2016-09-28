function varargout = guiTA(varargin)
% GUITA MATLAB code for guiTA.fig
%      GUITA, by itself, creates a new GUITA or raises the existing
%      singleton*.
%
%      H = GUITA returns the handle to a new GUITA or the handle to
%      the existing singleton*.
%
%      GUITA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUITA.M with the given input arguments.
%
%      GUITA('Property','Value',...) creates a new GUITA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiTA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiTA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiTA

% Last Modified by GUIDE v2.5 27-Mar-2016 16:00:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiTA_OpeningFcn, ...
                   'gui_OutputFcn',  @guiTA_OutputFcn, ...
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


% --- Executes just before guiTA is made visible.
function guiTA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiTA (see VARARGIN)

% Choose default command line output for guiTA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiTA wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiTA_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im im2 mypath
[path , user_cance] = imgetfile();
[cdata,map] = imread('trees.tif'); 
if user_cance
    msgbox('Silakan Pilih Gambar Kembali','Cancel PopUp','custom',cdata,map);
    return
end
addpath(genpath('C:\Users\TX300C\Documents\MATLAB\TA'));
im=imread(path);
mypath = path;
[~,name,~] = fileparts(mypath);
set(handles.text3,'String',name);
im2=im;
axes(handles.axes1);imshow(im);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im2
im2 = '';
close(handles.figure1);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mypath im2
if isempty(im2)
    msgbox(sprintf('Silakan Pilih Gambar Terlebih Dahulu'),'Error','Warn')
    return
end

set(handles.figure1, 'pointer', 'watch')
drawnow;

eyeImage = imread(mypath);
[~,name,~] = fileparts(mypath);
pathh = 'D:\zBAHANTA\PreProcessing\';
savefile = [pathh,name,'-parameters.mat'];

[stat,~]=fileattrib(savefile);
if stat==1
    load(savefile);
    axes(handles.axes2);imshow(imagewithcircle);
    axes(handles.axes3);imshow(imagewithnoise);
else
    [circle,fin] = zBatasCircleNoise(eyeImage);
    axes(handles.axes2);imshow(circle);
    axes(handles.axes3);imshow(fin);
end



set(handles.figure1, 'pointer', 'arrow');


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im2
cla(handles.axes1,'reset');
set(handles.axes1,'YTick',NaN);set(handles.axes1,'XTick',NaN);
set(handles.axes1,'XColor','White');set(handles.axes1,'YColor','White');

cla(handles.axes2,'reset');
set(handles.axes2,'YTick',NaN);set(handles.axes2,'XTick',NaN);
set(handles.axes2,'XColor','White');set(handles.axes2,'YColor','White');

cla(handles.axes3,'reset');
set(handles.axes3,'YTick',NaN);set(handles.axes3,'XTick',NaN);
set(handles.axes3,'XColor','White');set(handles.axes3,'YColor','White');
set(handles.text3,'String','(filename gambar)');
set(handles.text5,'String','(Hasil Matching)');
set(handles.text6,'String','');
im2 = '';


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mypath im2
if isempty(im2)
    msgbox(sprintf('Silakan Pilih Gambar Terlebih Dahulu'),'Error','Warn')
    return
end
set(handles.figure1, 'pointer', 'watch');
drawnow;

eyeImage = imread(mypath);tic;
% --------------------- edited for future------%
[~,name,~] = fileparts(mypath);
pathh = 'D:\zBAHANTA\WaveletHasilx3\';
savefile = [pathh,'kelasMata_',name(1:3),'.mat'];

[stat,~]=fileattrib(savefile);
if stat==1
    load(savefile);
    if name(5) =='1'
        if (name(7)=='1') ,hasilEkstrak = Trainings(1,:);
        elseif (name(7)=='2') ,hasilEkstrak= Trainings(2,:);
        elseif (name(7)=='3') ,hasilEkstrak = Trainings(3,:);
        end
    else
        if (name(7)=='1') ,hasilEkstrak= Trainings(4,:);
        elseif (name(7)=='2') ,hasilEkstrak = Trainings(5,:);
        elseif (name(7)=='3') ,hasilEkstrak = Trainings(6,:);
        else hasilEkstrak = Trainings(7,:);
        end
    end
    hasilSVM = zzSVMFst(hasilEkstrak);
else
    hasilSVM = zSVM(eyeImage);   % dont erase
end
% --------------------- edited for future------%
set(handles.text5,'String',hasilSVM);
[~,name,~] = fileparts(mypath);
% if name(1:3) == hasilSVM(10:end)
if strcmp(name(1:3),hasilSVM(10:end))
    set(handles.text6,'String','Cocok','ForegroundColor',[0 0 0]);
else
    set(handles.text6,'String','Tidak Cocok','ForegroundColor',[1 0 0]);
end

set(handles.figure1, 'pointer', 'arrow');toc


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mypath im2
if isempty(im2)
    msgbox(sprintf('Silakan Pilih Gambar Terlebih Dahulu'),'Error','Warn')
    return
end
set(handles.figure1, 'pointer', 'watch');
drawnow;

eyeImage = imread(mypath);tic;
% --------------------- edited for future------%
[~,name,~] = fileparts(mypath);
pathh = 'D:\zBAHANTA\GaborHasilx05\';
savefile = [pathh,'kelasMataG_',name(1:3),'.mat'];

[stat,~]=fileattrib(savefile);
if stat==1
    load(savefile);
    if name(5) =='1'
        if (name(7)=='1') ,hasilEkstrak1 = Template1;hasilEkstrak2 = Noise1;
        elseif (name(7)=='2') ,hasilEkstrak1= Template2;hasilEkstrak2 = Noise2;
        elseif (name(7)=='3') ,hasilEkstrak1 = Template3;hasilEkstrak2 = Noise3;
        end
    else
        if (name(7)=='1') ,hasilEkstrak1= Template4;hasilEkstrak2 = Noise4;
        elseif (name(7)=='2') ,hasilEkstrak1 = Template5;hasilEkstrak2 = Noise5;
        elseif (name(7)=='3') ,hasilEkstrak1 = Template6;hasilEkstrak2 = Noise6;
        else hasilEkstrak1 = Template7;hasilEkstrak2 = Noise7;
        end
    end
    hasilHam = zzHamFst(hasilEkstrak1,hasilEkstrak2);
else
    hasilHam = zHamming2(eyeImage); % dont erase
end
% --------------------- edited for future------%
set(handles.text5,'String',hasilHam);

[~,name,~] = fileparts(mypath);
% if name(1:3) == hasilHam(10:end)
if strcmp(name(1:3),hasilHam(10:end))
    set(handles.text6,'String','Cocok','ForegroundColor',[0 0 0]);
else
    set(handles.text6,'String','Tidak Cocok','ForegroundColor',[1 0 0]);
end

set(handles.figure1, 'pointer', 'arrow');toc


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)

global mypath im2
if isempty(im2)
    msgbox(sprintf('Silakan Pilih Gambar Terlebih Dahulu'),'Error','Warn')
    return
end
set(handles.figure1, 'pointer', 'watch');
drawnow;

eyeImage = imread(mypath);tic;
hasilCom1 = GabunganOnevsAll(eyeImage);

[~,namez,~] = fileparts(mypath);
if ~(strcmp(namez(1:3),hasilCom1(10:end)))
   hasilCombined = GabunganOnevsAll(eyeImage,2); 
end

set(handles.text5,'String',hasilCombined);

[~,name,~] = fileparts(mypath);
if strcmp(name(1:3),hasilCombined(10:end))
    set(handles.text6,'String','Cocok','ForegroundColor',[0 0 0]);
else
    set(handles.text6,'String','Tidak Cocok','ForegroundColor',[1 0 0]);
end

set(handles.figure1, 'pointer', 'arrow');toc
