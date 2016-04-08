function varargout = gui2(varargin)
% GUI2 MATLAB code for gui2.fig
%      GUI2, by itself, creates a new GUI2 or raises the existing
%      singleton*.
%
%      H = GUI2 returns the handle to a new GUI2 or the handle to
%      the existing singleton*.
%
%      GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2.M with the given input arguments.
%
%      GUI2('Property','Value',...) creates a new GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI2 before gui2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui2_OpeningFcn via varargin.
%
%      *See GUI2 Options on GUIDE's Tools menu.  Choose "GUI2 allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui2

% Last Modified by GUIDE v2.5 06-Mar-2016 16:15:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui2_OpeningFcn', @gui2_OpeningFcn, ...
                   'gui2_OutputFcn',  @gui2_OutputFcn, ...
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


% --- Executes just before gui2 is made visible.
function gui2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui2 (see VARARGIN)

% Choose default command line output for gui2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui2 wait for user response (see UIRESUME)
% uiwait(handles.guiwindow);


% --- Outputs from this function are returned to the command line.
function varargout = gui2_OutputFcn(hObject, eventdata, handles) 
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
xi = str2num(xi);
func = handles.func;
transfunc = handles.transfunc;
tol = handles.num.tol;
it = handles.num.it;
switch method
    case get(handles.button_gradient,'String')  %in case the name of the button is the same as the gradient button
        A=min_quad(0.5:0.5:5,[1.65 -1.3 0.5 -0.1 -0.15 0.15 -0.05 0.05 0.01 0],func,transfunc,'1','s',xi,tol)
        min = sprintf('%g,',transpose(handles.num.min)); %preparing the result to be displayed in the gui
        resultx = ['x, y, ... =' min];
        set(handles.result_x,'String',resultx)
        fmin = num2str(handles.num.fmin);
        resultfx = ['f(x,y,...) = ' fmin];
        set(handles.result_fx,'String',resultfx)
        if handles.num.it_max == it %if the minimum wasn't found, inform the final interval reached
            warning_it = min;
            warning = {'Máximo de iterações alcançado.' 'Ponto final igual a:' warning_it};
            warndlg(warning,'Aviso');
        end
     case get(handles.simplex,'String')  %in case the name of the button is the same as the gradient button
        A=min_quad(0.5:0.5:5,[1.65 -1.3 0.5 -0.1 -0.15 0.15 -0.05 0.05 0.01 0],func,transfunc,'1','p',xi,tol)
        min = sprintf('%g,',transpose(handles.num.min)); %preparing the result to be displayed in the gui
        resultx = ['x, y, ... =' min];
        set(handles.result_x,'String',resultx)
        fmin = num2str(handles.num.fmin);
        resultfx = ['f(x,y,...) = ' fmin];
        set(handles.result_fx,'String',resultfx)
        if handles.num.it_max == it %if the minimum wasn't found, inform the final interval reached
            warning_it = min;
            warning = {'Máximo de iterações alcançado.' 'Ponto final igual a:' warning_it};
            warndlg(warning,'Aviso');
        end
    case get(handles.button_gradcon,'String') %in case the name of the button is the same as the gradiente conjugado button
        [handles.num.min, handles.num.fmin, handles.num.time, handles.num.it_max] = grad_con(func,xi,tol,it); %XI YI AS COLUMN VECTOR
        min = sprintf('%g,',transpose(handles.num.min));
        resultx = ['x, y, ... = ' min];
        set(handles.result_x,'String',resultx)
        fmin = num2str(handles.num.fmin);
        resultfx = ['f(x,y,...) = ' fmin];
        set(handles.result_fx,'String',resultfx)
        if handles.num.it_max == it %if the minimum wasn't found, inform the final interval reached
            warning_it = min;
            warning = {'Máximo de iterações alcançado.' 'Ponto final igual a:' warning_it};
            warndlg(warning,'Aviso');
        end
    case get(handles.button_newton,'String')  %in case the name of the button is the same as the newton button
        [handles.num.min, handles.num.fmin, handles.num.time, handles.num.it_max] = newton(func,xi,tol,it); %storing the result in handles
        min = sprintf('%g,',transpose(handles.num.min)); %preparing the result to be displayed in the gui
        resultx = ['x, y, ... =' min];
        set(handles.result_x,'String',resultx)
        fmin = num2str(handles.num.fmin);
        resultfx = ['f(x,y,...) = ' fmin];
        set(handles.result_fx,'String',resultfx)
        if handles.num.it_max == it %if the minimum wasn't found, inform the final interval reached
            warning_it = min;
            warning = {'Máximo de iterações alcançado.' 'Ponto final igual a:' warning_it};
            warndlg(warning,'Aviso');
        end
    case get(handles.button_qnewton,'String')  %in case the name of the button is the same as the quase newton button
        [handles.num.min, handles.num.fmin, handles.num.time, handles.num.it_max] = QuaseNewton(func,xi,tol,it); %storing the result in handles
        min = sprintf('%g,',transpose(handles.num.min)); %preparing the result to be displayed in the gui
        resultx = ['x, y, ... =' min];
        set(handles.result_x,'String',resultx)
        fmin = num2str(handles.num.fmin);
        resultfx = ['f(x,y,...) = ' fmin];
        set(handles.result_fx,'String',resultfx)
        if handles.num.it_max == it %if the minimum wasn't found, inform the final interval reached
            warning_it = min;
            warning = {'Máximo de iterações alcançado.' 'Ponto final igual a:' warning_it};
            warndlg(warning,'Aviso');
        end
    case get(handles.button_newtonmod,'String')  %in case the name of the button is the same as the modified newton button
        [handles.num.min, handles.num.fmin, handles.num.time, handles.num.it_max] = newton_mod(func,xi,tol,it); %storing the result in handles
        min = sprintf('%g,',transpose(handles.num.min)); %preparing the result to be displayed in the gui
        resultx = ['x, y, ... =' min];
        set(handles.result_x,'String',resultx)
        fmin = num2str(handles.num.fmin);
        resultfx = ['f(x,y,...) = ' fmin];
        set(handles.result_fx,'String',resultfx)
        if handles.num.it_max == it %if the minimum wasn't found, inform the final interval reached
            warning_it = min;
            warning = {'Máximo de iterações alcançado.' 'Ponto final igual a:' warning_it};
            warndlg(warning,'Aviso');
        end

end
guidata(hObject,handles)


function xi_Callback(hObject, eventdata, handles)
% hObject    handle to xi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

xi = get(hObject,'String');   %gets what's written on the xi text box
% xi(xi==',') = '.';      %substitutes the , for .
% xi = str2double(xi);    %transforms into a double
% 
% if isnan(xi) %in case the user inputs something that isn't a number
%     set(hObject, 'String', '[erro]','ForegroundColor',[1 0 0]);
%     errordlg('xi deve ser um número','Erro','modal');
%     return
% end

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



function yi_Callback(hObject, eventdata, handles)
% hObject    handle to yi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

yi = get(hObject,'String');   %gets what's written on the xf text box
yi(yi==',') = '.';      %substitutes the , for .
yi = str2double(yi);    %transforms into a double

if isnan(yi) %in case the user inputs something that isn't a number
    set(hObject, 'String', '[erro]','ForegroundColor',[1 0 0]);
    errordlg('xf deve ser um número','Erro','modal');
    return
end

handles.num.yi = yi;    %sending the value of xf to the handles struct
set(hObject,'ForegroundColor',[0 0 0],'String',yi); %making the correct number appear onscreen (with . instead of ,)
guidata(hObject,handles) %sending the struct back to the program


% Hints: get(hObject,'String') returns contents of yi as text
%        str2double(get(hObject,'String')) returns contents of yi as a double


% --- Executes during object creation, after setting all properties.
function yi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yi (see GCBO)
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
func = handles.func;
tol = handles.num.tol;
it = handles.num.it;
min = handles.num.min;
% xi_lim = handles.num.xi_lim;
% xf_lim = handles.num.xf_lim;
it_max = handles.num.it_max;
time = handles.num.time;
selected_func = ['Função selecionada: ' func];
selected_method = '';
h = get(handles.panel_method,'SelectedObject'); %store in h the radio button that is selected
method = get(h,'String');    %store in method the name of the selected radio button
switch method
    case get(handles.button_gradient,'String')  %in case the name of the button is the same as the fibonacci button
        selected_method = 'Método selecionado: Gradiente Simples';
    case get(handles.button_gradcon,'String') %in case the name of the button is the same as the aurea button
        selected_method = 'Método selecionado: Gradiente Conjugado';
        case get(handles.button_qnewton,'String')  %in case the name of the button is the same as the polinomial button
    selected_method = 'Método selecionado: Quase Newton';
    case get(handles.button_newton,'String')  %in case the name of the button is the same as the polinomial button
        selected_method = 'Método selecionado: Newton Puro';
    case get(handles.button_newtonmod,'String')  %in case the name of the button is the same as the polinomial button
        selected_method = 'Método selecionado: Newton Modificado';
end
selected_it = ['Número máximo de iterações = ' num2str(it)];
selected_tol = ['Tolerância selecionada = ' num2str(tol)];
selected_interval = ['Ponto inicial = [' sprintf(xi) ']'];
result_min = 'Minímo encontrado em [';
result_min = [result_min sprintf(num2str(min)) ']'];
result_it = ['Foram feitas ' num2str(it_max) ' iterações.'];
if it_max == 1
    result_it = ['Foi feita ' num2str(it_max) ' iteração.'];
end
result_interval = [];
        if it_max == it
%             result_interval = ['[' num2str(xi_lim) ' ' num2str(xf_lim) '].'];
%             result_interval = ['Intervalo final igual a: ' result_interval];
            result_min = 'Último ponto alcançado em  ';
            result_min = [result_min sprintf('%g,',(transpose(min)))];
        end
result_time = ['Tempo de processamento = ' num2str(time) 's'];
message = {selected_func selected_method selected_it selected_tol selected_interval ...
    result_min result_it result_time result_interval};
msg = msgbox(message,'Valores');


% --- Executes on button press in buttonplot.
function buttonplot_Callback(hObject, eventdata, handles)
% hObject    handle to buttonplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xi = handles.num.xi;
x0 = str2num(xi);
func = handles.func;

exp = sym(func);
x = symvar(exp);
F_0 = double(subs(exp,x,x0));

%if size(x) == 2
ezsurf(exp,[x0(1)-5, x0(1)+5, x0(2)-5, x0(2)+5])
hold on
scatter3(x0(1), x0(2),F_0,100,'white','filled')
hold off
%end



function transfunc_Callback(hObject, eventdata, handles)
% hObject    handle to transfunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of transfunc as text
%        str2double(get(hObject,'String')) returns contents of transfunc as a double


% --- Executes during object creation, after setting all properties.
function transfunc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transfunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
