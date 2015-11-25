function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 25-Nov-2015 18:23:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.guiwindow);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function func_Callback(hObject, eventdata, handles)
% hObject    handle to func (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If user inputs something that isn't a function
% if isnan(f) % TODO change isnan to something that detects a function
%     set(hObject, 'String', '[erro]','ForegroundColor',[1 0 0]);
%     errordlg('Entrada deve ser uma função','Erro','modal')
%     return
% end
    

% Hints: get(hObject,'String') returns contents of func as text
%        str2double(get(hObject,'String')) returns contents of func as a double


% --- Executes during object creation, after setting all properties.
function func_CreateFcn(hObject, eventdata, handles)
% hObject    handle to func (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_calc.
function button_calc_Callback(hObject, eventdata, handles)
% hObject    handle to button_calc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = get(handles.panel_method,'SelectedObject'); %store in h the radio button that is selected
method = get(h,'String');    %store in method the name of the selected radio button
switch method
    case get(handles.button_fibo,'String')  %in case the name of the button is the same as the fibonacci button
        warndlg('Função selecionada: Fibonacci','Aviso');
        % TODO call fibonacci function
        set(handles.result_x,'String','x = ponto de mínimo')
        set(handles.result_fx,'String','f(x) = valor do mínimo')
    case get(handles.button_aurea,'String') %in case the name of the button is the same as the aurea button
        warndlg('Função selecionada: Razão Áurea','Aviso');
        % TODO call aurea function
        set(handles.result_x,'String','x = ponto de mínimo')
        set(handles.result_fx,'String','f(x) = valor do mínimo')
    case get(handles.button_poly,'String')  %in case the name of the button is the same as the polinomial button
        warndlg('Função selecionada: Interpolação Polinomial','Aviso');
        % TODO call polynomial interpolation function
        set(handles.result_x,'String','x = ponto de mínimo')
        set(handles.result_fx,'String','f(x) = valor do mínimo')
end



function xi_Callback(hObject, eventdata, handles)
% hObject    handle to xi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

xi = get(hObject,'String');   %gets what's written on the xi text box
xi(xi==',') = '.';      %substitutes the , for .
xi = str2double(xi);    %transforms into a double

if isnan(xi) %in case the user inputs something that isn't a number
    set(hObject, 'String', '[erro]','ForegroundColor',[1 0 0]);
    errordlg('xi deve ser um número','Erro','modal');
    return
end

handles.num.xi = xi;    %sending the value of xi to the handles struct
set(hObject,'ForegroundColor',[0 0 0],'String',xi); %making the correct number appear onscreen (with . instead of ,)
guidata(hObject,handles) %sending the struct back to the program

% Hints: get(hObject,'String') returns contents of xi as text
%        str2double(get(hObject,'String')) returns contents of xi as a double


% --- Executes during object creation, after setting all properties.
function xi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xf_Callback(hObject, eventdata, handles)
% hObject    handle to xf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

xf = get(hObject,'String');   %gets what's written on the xf text box
xf(xf==',') = '.';      %substitutes the , for .
xf = str2double(xf);    %transforms into a double

if isnan(xf) %in case the user inputs something that isn't a number
    set(hObject, 'String', '[erro]','ForegroundColor',[1 0 0]);
    errordlg('xf deve ser um número','Erro','modal');
    return
end

handles.num.xf = xf;    %sending the value of xf to the handles struct
set(hObject,'ForegroundColor',[0 0 0],'String',xf); %making the correct number appear onscreen (with . instead of ,)
guidata(hObject,handles) %sending the struct back to the program


% Hints: get(hObject,'String') returns contents of xf as text
%        str2double(get(hObject,'String')) returns contents of xf as a double


% --- Executes during object creation, after setting all properties.
function xf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tolerance_Callback(hObject, eventdata, handles)
% hObject    handle to tolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tolerance as text
%        str2double(get(hObject,'String')) returns contents of tolerance as a double

tol = get(hObject,'String');   %gets what's written on the tolerância text box
tol(tol==',') = '.';      %substitutes the , for .
tol = str2double(tol);    %transforms into a double

if isnan(tol) %in case the user inputs something that isn't a number
    set(hObject, 'String', '[erro]','ForegroundColor',[1 0 0]);
    errordlg('A tolerância deve ser um número','Erro','modal');
    return
end

handles.num.tol = tol;    %sending the value of xi to the handles struct
set(hObject,'ForegroundColor',[0 0 0],'String',tol); %making the correct number appear onscreen (with . instead of ,)
guidata(hObject,handles) %sending the struct back to the program


% --- Executes during object creation, after setting all properties.
function tolerance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
