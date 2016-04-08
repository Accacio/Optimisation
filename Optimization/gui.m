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

% Last Modified by GUIDE v2.5 28-Nov-2015 14:40:45

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
func = get(hObject,'String');   %gets what's written on the func text box
func(func==',') = '.';
handles.func = func;    %sending the value of func to the handles struct
set(hObject,'ForegroundColor',[0 0 0],'String',func); %making the correct number appear onscreen (with . instead of ,)
guidata(hObject,handles) %sending the struct back to the program   

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
xi = handles.num.xi; %getting the necessary parameters from the handles struct
xf = handles.num.xf;
func = handles.func;
tol = handles.num.tol;
it = handles.num.it;
switch method
    case get(handles.button_fibo,'String')  %in case the name of the button is the same as the fibonacci button
        [handles.num.min, handles.num.fmin, handles.num.time, handles.num.xi_lim, handles.num.xf_lim, handles.num.it_max] = Fibonacci(func,xi,xf,tol,it); %storing the result of interpol in handles
        min = num2str(handles.num.min); %preparing the result to be displayed in the gui
        resultx = ['x = ' min];
        set(handles.result_x,'String',resultx)
        fmin = num2str(handles.num.fmin);
        resultfx = ['f(x) = ' fmin];
        set(handles.result_fx,'String',resultfx)
        if handles.num.it_max == it %if the minimum wasn't found, inform the final interval reached
            warning_it = ['[' num2str(handles.num.xi_lim) ' ' num2str(handles.num.xf_lim) '].'];
            warning = {'Máximo de iterações alcançado.' 'Intervalo final igual a:' warning_it};
            warndlg(warning,'Aviso');
        end
        %         warndlg('Método selecionado: Fibonacci','Aviso'); %just for testing
%         % TODO call fibonacci function
%         set(handles.result_x,'String','x = ponto de mínimo') 
%         set(handles.result_fx,'String','f(x) = valor do mínimo')
    case get(handles.button_aurea,'String') %in case the name of the button is the same as the aurea button
        [handles.num.min, handles.num.fmin, handles.num.time, handles.num.xi_lim, handles.num.xf_lim, handles.num.it_max] = aurea(func,xi,xf,tol,it); %storing the result of aurea in handles
        min = num2str(handles.num.min); %preparing the result to be displayed in the gui
        resultx = ['x = ' min];
        set(handles.result_x,'String',resultx)
        fmin = num2str(handles.num.fmin);
        resultfx = ['f(x) = ' fmin];
        set(handles.result_fx,'String',resultfx)
        if handles.num.it_max == it %if the minimum wasn't found, inform the final interval reached
            warning_it = ['[' num2str(handles.num.xi_lim) ' ' num2str(handles.num.xf_lim) '].'];
            warning = {'Máximo de iterações alcançado.' 'Intervalo final igual a:' warning_it};
            warndlg(warning,'Aviso');
        end
    case get(handles.button_poly,'String')  %in case the name of the button is the same as the polinomial button
        [handles.num.min, handles.num.fmin, handles.num.time, handles.num.xi_lim, handles.num.xf_lim, handles.num.it_max] = interpol(func,xi,xf,tol,it); %storing the result of interpol in handles
        min = num2str(handles.num.min); %preparing the result to be displayed in the gui
        resultx = ['x = ' min];
        set(handles.result_x,'String',resultx)
        fmin = num2str(handles.num.fmin);
        resultfx = ['f(x) = ' fmin];
        set(handles.result_fx,'String',resultfx)
        if handles.num.it_max == it %if the minimum wasn't found, inform the final interval reached
            warning_it = ['[' num2str(handles.num.xi_lim) ' ' num2str(handles.num.xf_lim) '].'];
            warning = {'Máximo de iterações alcançado.' 'Intervalo final igual a:' warning_it};
            warndlg(warning,'Aviso');
        end

end
guidata(hObject,handles)


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



function tol_Callback(hObject, eventdata, handles)
% hObject    handle to tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tol as text
%        str2double(get(hObject,'String')) returns contents of tol as a double

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
function tol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function it_Callback(hObject, eventdata, handles)
% hObject    handle to it (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
it = get(hObject,'String');   %gets what's written on the it text box
it(it==',') = '.';      %substitutes the , for .
it = str2double(it);    %transforms into a double

if isnan(it) %in case the user inputs something that isn't a number
    set(hObject, 'String', '[erro]','ForegroundColor',[1 0 0]);
    errordlg('it deve ser um número','Erro','modal');
    return
end

handles.num.it = it;    %sending the value of it to the handles struct
set(hObject,'ForegroundColor',[0 0 0],'String',it); %making the correct number appear onscreen (with . instead of ,)
guidata(hObject,handles) %sending the struct back to the program
% Hints: get(hObject,'String') returns contents of it as text
%        str2double(get(hObject,'String')) returns contents of it as a double


% --- Executes during object creation, after setting all properties.
function it_CreateFcn(hObject, eventdata, handles)
% hObject    handle to it (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_result.
function button_result_Callback(hObject, eventdata, handles)
% hObject    handle to button_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xi = handles.num.xi;
xf = handles.num.xf;
func = handles.func;
tol = handles.num.tol;
it = handles.num.it;
min = handles.num.min;
xi_lim = handles.num.xi_lim;
xf_lim = handles.num.xf_lim;
it_max = handles.num.it_max;
time = handles.num.time;
selected_func = ['Função selecionada: ' func];
selected_method = '';
h = get(handles.panel_method,'SelectedObject'); %store in h the radio button that is selected
method = get(h,'String');    %store in method the name of the selected radio button
switch method
    case get(handles.button_fibo,'String')  %in case the name of the button is the same as the fibonacci button
        selected_method = 'Método selecionado: Fibonacci';
    case get(handles.button_aurea,'String') %in case the name of the button is the same as the aurea button
        selected_method = 'Método selecionado: Seção Áurea';
    case get(handles.button_poly,'String')  %in case the name of the button is the same as the polinomial button
        selected_method = 'Método selecionado: Interpolação Polinomial';
end
selected_it = ['Número máximo de iterações = ' num2str(it)];
selected_tol = ['Tolerância selecionada = ' num2str(tol)];
selected_interval = ['Intervalo inicial = [' num2str(xi) ' ' num2str(xf) ']'];
result_min = 'Minímo encontrado em x = ';
result_min = [result_min num2str(min)];
result_it = ['Foram feitas ' num2str(it_max) ' iterações.'];
if it_max == 1
    result_it = ['Foi feita ' num2str(it_max) ' iteração.']
end
result_interval = [];
        if it_max == it
            result_interval = ['[' num2str(xi_lim) ' ' num2str(xf_lim) '].'];
            result_interval = ['Intervalo final igual a: ' result_interval];
            result_min = 'Último ponto alcançado em x = ';
            result_min = [result_min num2str(min)];
        end
result_time = ['Tempo de processamento = ' num2str(time) 's'];
message = {selected_func selected_method selected_it selected_tol selected_interval ...
    result_min result_it result_time result_interval};
msgbox(message,'Valores');
