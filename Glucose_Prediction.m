function varargout = Glucose_Prediction(varargin)
% Glucose_Prediction MATLAB code for Glucose_Prediction.fig
%      Glucose_Prediction, by itself, creates a new Glucose_Prediction or raises the existing
%      singleton*.
%
%      H = Glucose_Prediction returns the handle to a new Glucose_Prediction or the handle to
%      the existing singleton*.
%
%      Glucose_Prediction('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Glucose_Prediction.M with the given input arguments.
%
%      Glucose_Prediction('Property','Value',...) creates a new Glucose_Prediction or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Glucose_Prediction_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Glucose_Prediction_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Glucose_Prediction

% Last Modified by GUIDE v2.5 25-Jun-2020 22:58:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Glucose_Prediction_OpeningFcn, ...
                   'gui_OutputFcn',  @Glucose_Prediction_OutputFcn, ...
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


% --- Executes just before Glucose_Prediction is made visible.
function Glucose_Prediction_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Glucose_Prediction (see VARARGIN)

% Choose default command line output for Glucose_Prediction
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Glucose_Prediction wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Glucose_Prediction_OutputFcn(hObject, eventdata, handles) 
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

% Gp=str2num(get(handles.edit1,'string'));%初始血糖浓度
% T=str2num(get(handles.edit2,'string'));%注射周期
% Tc=str2num(get(handles.edit3,'string'));%切换时间
% Dp=str2num(get(handles.edit4,'string'));%初始注射量
% Db=str2num(get(handles.edit5,'string'));%周期大剂量
% Ds=str2num(get(handles.edit6,'string'));%周期小剂量


%%
%读取输入数据
InitialGul = str2num(get(handles.edit1,'string'));         %初始血糖浓度
InjectCycle = str2num(get(handles.edit2,'string'));        %注射周期
SwitchTime = str2num(get(handles.edit3,'string'));         %切换时间
InitialInjection = str2num(get(handles.edit4,'string'));   %初始注射量
BigCycleInjection = str2num(get(handles.edit5,'string'));  %周期大剂量
SmallCycleInjection = str2num(get(handles.edit6,'string'));%周期小剂量

%%
%神经网络预测和微分方程计算
[ypredict,firstmin_data,firstmin_time,secondmax_data,secondmax_time,thirdmin_data,thirdmin_time] = jisuan1(InitialGul,InjectCycle,SwitchTime,InitialInjection,BigCycleInjection,SmallCycleInjection);
[tDiabeticInj,yDiabeticInj]=jisuan2(InitialGul,InjectCycle,SwitchTime,InitialInjection,BigCycleInjection,SmallCycleInjection);
[tNormal,yNormal,tDiabetic,yDiabetic]=jisuan3(InitialGul);
%%
%绘制预测曲线

%将数据按时间顺序进行排列
tpredict = [0, 0.2, 0.4, 0.6, 0.8, 1, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5, 2.75, 3.0,...
        3.5, 4.0, 5.0, 6.0, 7.0, 8.0];

%输出神经网络点连接而成的实线
if get(handles.togglebutton1,'Value') == 0
    plot( tpredict   ,  ypredict , 'r');
    title('血糖预测结果');
    grid on;
    axis([0,8,0,350]);
    legend('神经网络模型');
    xlabel('时间 (h)');
    ylabel('血糖浓度 (mg/dl)');

%输出微分方程和神经网络点
else
    plot(   tNormal    , yNormal   , '-'       , ... 
            tDiabetic  , yDiabetic , '--'      , ...
            tDiabeticInj, yDiabeticInj , 'r'   , ...
            tpredict   ,  ypredict , '*');
    title('血糖预测结果');
    grid on;
    axis([0,8,0,350]);
    legend('正常人','II型糖尿病','微分方程模型','神经网络模型');
    xlabel('时间 (h)');
    ylabel('血糖浓度 (mg/dl)');
end
    

%文本框输出
set(handles.edit7,'string',num2str(firstmin_data));
set(handles.edit8,'string',num2str(secondmax_data));
set(handles.edit9,'string',num2str(thirdmin_data));
set(handles.edit10,'string',num2str(firstmin_time));
set(handles.edit11,'string',num2str(secondmax_time));
set(handles.edit12,'string',num2str(thirdmin_time));

% 
% tNormalsec=tNormal*3600;
% tNormal_dif=diff(tNormalsec);
% 
% figure(2);
% plot(tNormalsec);
% 
% figure(3);
% plot(tNormal_dif);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.



function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function img_CreateFcn(hObject, eventdata, handles)
% hObject    handle to img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate img


% --- Executes during object deletion, before destroying properties.
function img_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function img_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ax1=getappdata(handles.pushbutton1,'ax1');
cla(ax1);
set(handles.edit1,'string','','Enable','on')
set(handles.edit2,'string','','Enable','on')
set(handles.edit3,'string','','Enable','on')
set(handles.edit4,'string','','Enable','on')
set(handles.edit5,'string','','Enable','on')
set(handles.edit6,'string','','Enable','on')
set(handles.edit7,'string','','Enable','on')
set(handles.edit8,'string','','Enable','on')
set(handles.edit9,'string','','Enable','on')
set(handles.edit10,'string','','Enable','on')
set(handles.edit11,'string','','Enable','on')
set(handles.edit12,'string','','Enable','on')

clear all
clc




function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
val=get(handles.popupmenu1,'value');%获取数值,从上到下依次1到3
switch val
    case 1
%%
InitialGul = 165;         %初始血糖浓度
InjectCycle = 20;        %注射周期
SwitchTime = 240;         %切换时间
InitialInjection = 4000;   %初始注射量
BigCycleInjection = 140;  %周期大剂量
SmallCycleInjection = 20;%周期小剂量

set(handles.edit1,'string',InitialGul);
set(handles.edit2,'string',InjectCycle);
set(handles.edit3,'string',SwitchTime);
set(handles.edit4,'string',InitialInjection);
set(handles.edit5,'string',BigCycleInjection);
set(handles.edit6,'string',SmallCycleInjection);

%%
%神经网络预测和微分方程求解
[ypredict,firstmin_data,firstmin_time,secondmax_data,secondmax_time,thirdmin_data,thirdmin_time] =jisuan1(InitialGul,InjectCycle,SwitchTime,InitialInjection,BigCycleInjection,SmallCycleInjection);
[tDiabeticInj,yDiabeticInj]=jisuan2(InitialGul,InjectCycle,SwitchTime,InitialInjection,BigCycleInjection,SmallCycleInjection);
[tNormal,yNormal,tDiabetic,yDiabetic]=jisuan3(InitialGul);
%%
%绘制血糖预测曲线

%将数据按时间顺序进行排列
tpredict = [0, 0.2, 0.4, 0.6, 0.8, 1, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5, 2.75, 3.0,...
        3.5, 4.0, 5.0, 6.0, 7.0, 8.0];

%输出神经网络点连接而成的实线
if get(handles.togglebutton1,'Value') == 0
    plot( tpredict   ,  ypredict , 'r');
    title('血糖预测结果');
    grid on;
    axis([0,8,0,350]);
    legend('神经网络模型');
    xlabel('时间 (h)');
    ylabel('血糖浓度 (mg/dl)');

%输出微分方程和神经网络点
else
    plot(   tNormal    , yNormal   , '-'       , ... 
            tDiabetic  , yDiabetic , '--'      , ...
            tDiabeticInj, yDiabeticInj , 'r'   , ...
            tpredict   ,  ypredict , '*');
    title('血糖预测结果');
    grid on;
    axis([0,8,0,350]);
    legend('正常人','II型糖尿病','微分方程模型','神经网络模型');
    xlabel('时间 (h)');
    ylabel('血糖浓度 (mg/dl)');
end

%文本框输出
set(handles.edit7,'string',num2str(firstmin_data));
set(handles.edit8,'string',num2str(secondmax_data));
set(handles.edit9,'string',num2str(thirdmin_data));
set(handles.edit10,'string',num2str(firstmin_time));
set(handles.edit11,'string',num2str(secondmax_time));
set(handles.edit12,'string',num2str(thirdmin_time));
   
    case 2
%%
InitialGul = 180;         %初始血糖浓度
InjectCycle = 25;        %注射周期
SwitchTime = 245;         %切换时间
InitialInjection = 4100;   %初始注射量
BigCycleInjection = 145;  %周期大剂量
SmallCycleInjection = 25;%周期小剂量

set(handles.edit1,'string',InitialGul);
set(handles.edit2,'string',InjectCycle);
set(handles.edit3,'string',SwitchTime);
set(handles.edit4,'string',InitialInjection);
set(handles.edit5,'string',BigCycleInjection);
set(handles.edit6,'string',SmallCycleInjection);

%%
%神经网络预测和微分方程求解
[ypredict,firstmin_data,firstmin_time,secondmax_data,secondmax_time,thirdmin_data,thirdmin_time] =jisuan1(InitialGul,InjectCycle,SwitchTime,InitialInjection,BigCycleInjection,SmallCycleInjection);
[tDiabeticInj,yDiabeticInj]=jisuan2(InitialGul,InjectCycle,SwitchTime,InitialInjection,BigCycleInjection,SmallCycleInjection);
[tNormal,yNormal,tDiabetic,yDiabetic]=jisuan3(InitialGul);
%%
%绘制血糖预测曲线

%将数据按时间顺序进行排列
tpredict = [0, 0.2, 0.4, 0.6, 0.8, 1, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5, 2.75, 3.0,...
        3.5, 4.0, 5.0, 6.0, 7.0, 8.0];

%输出神经网络点连接而成的实线
if get(handles.togglebutton1,'Value') == 0
    plot( tpredict   ,  ypredict , 'r');
    title('血糖预测结果');
    grid on;
    axis([0,8,0,350]);
    legend('神经网络模型');
    xlabel('时间 (h)');
    ylabel('血糖浓度 (mg/dl)');

%输出微分方程和神经网络点
else
    plot(   tNormal    , yNormal   , '-'       , ... 
            tDiabetic  , yDiabetic , '--'      , ...
            tDiabeticInj, yDiabeticInj , 'r'   , ...
            tpredict   ,  ypredict , '*');
    title('血糖预测结果');
    grid on;
    axis([0,8,0,350]);
    legend('正常人','II型糖尿病','微分方程模型','神经网络模型');
    xlabel('时间 (h)');
    ylabel('血糖浓度 (mg/dl)');
end

%文本框输出
set(handles.edit7,'string',num2str(firstmin_data));
set(handles.edit8,'string',num2str(secondmax_data));
set(handles.edit9,'string',num2str(thirdmin_data));
set(handles.edit10,'string',num2str(firstmin_time));
set(handles.edit11,'string',num2str(secondmax_time));
set(handles.edit12,'string',num2str(thirdmin_time));
    
    case 3
%%
InitialGul = 230;         %初始血糖浓度
InjectCycle = 20;        %注射周期
SwitchTime = 250;         %切换时间
InitialInjection = 4500;   %初始注射量
BigCycleInjection = 180;  %周期大剂量
SmallCycleInjection = 30;%周期小剂量

set(handles.edit1,'string',InitialGul);
set(handles.edit2,'string',InjectCycle);
set(handles.edit3,'string',SwitchTime);
set(handles.edit4,'string',InitialInjection);
set(handles.edit5,'string',BigCycleInjection);
set(handles.edit6,'string',SmallCycleInjection);

%%
%神经网络预测和微分方程求解
[ypredict,firstmin_data,firstmin_time,secondmax_data,secondmax_time,thirdmin_data,thirdmin_time] =jisuan1(InitialGul,InjectCycle,SwitchTime,InitialInjection,BigCycleInjection,SmallCycleInjection);
[tDiabeticInj,yDiabeticInj]=jisuan2(InitialGul,InjectCycle,SwitchTime,InitialInjection,BigCycleInjection,SmallCycleInjection);
[tNormal,yNormal,tDiabetic,yDiabetic]=jisuan3(InitialGul);
%%
%绘制血糖预测曲线

%将数据按时间顺序进行排列
tpredict = [0, 0.2, 0.4, 0.6, 0.8, 1, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5, 2.75, 3.0,...
        3.5, 4.0, 5.0, 6.0, 7.0, 8.0];

%输出神经网络点连接而成的实线
if get(handles.togglebutton1,'Value') == 0
    plot( tpredict   ,  ypredict , 'r');
    title('血糖预测结果');
    grid on;
    axis([0,8,0,350]);
    legend('神经网络模型');
    xlabel('时间 (h)');
    ylabel('血糖浓度 (mg/dl)');

%输出微分方程和神经网络点
else
    plot(   tNormal    , yNormal   , '-'       , ... 
            tDiabetic  , yDiabetic , '--'      , ...
            tDiabeticInj, yDiabeticInj , 'r'   , ...
            tpredict   ,  ypredict , '*');
    title('血糖预测结果');
    grid on;
    axis([0,8,0,350]);
    legend('正常人','II型糖尿病','微分方程模型','神经网络模型');
    xlabel('时间 (h)');
    ylabel('血糖浓度 (mg/dl)');
end

%文本框输出
set(handles.edit7,'string',num2str(firstmin_data));
set(handles.edit8,'string',num2str(secondmax_data));
set(handles.edit9,'string',num2str(thirdmin_data));
set(handles.edit10,'string',num2str(firstmin_time));
set(handles.edit11,'string',num2str(secondmax_time));
set(handles.edit12,'string',num2str(thirdmin_time));
end



function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
