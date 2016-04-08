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

% Last Modified by GUIDE v2.5 10-Mar-2016 11:30:05

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



function func_box_Callback(hObject, eventdata, handles)
% hObject    handle to func_box (see GCBO)
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

% Hints: get(hObject,'String') returns contents of func_box as text
%        str2double(get(hObject,'String')) returns contents of func_box as a double


% --- Executes during object creation, after setting all properties.
function func_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to func_box (see GCBO)
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
if max(size(xi)) == 6
    x0 = xi(1:2);
    x1 = xi(3:4);
    x2 = xi(5:6);
end

func = handles.func;
tol = handles.num.tol;
it = handles.num.it;

if (get(handles.box_anim,'Value') == get(handles.box_anim,'Max'))
	anim = 1;
else
	anim = 0;
end

%  if exist('handles.anim')
%      anim = handles.anim;
%  else anim = 0;
%  end

if (get(handles.box_impulso,'Value') == get(handles.box_impulso,'Max'))
	impulso = 1;
else
	impulso = 0;
end

switch method
    case get(handles.button_gradient,'String')  %in case the name of the button is the same as the gradient button
        [handles.num.min, handles.num.fmin, handles.num.time, handles.num.it_max] = stegrades(func,xi,tol,it); %storing the result in handles
        min = sprintf('%g,',transpose(handles.num.min)); %preparing the result to be displayed in the gui
        resultx = ['x, y, ... =' min];
        set(handles.result_x,'String',resultx)
        fmin = num2str(handles.num.fmin);
        resultfx = ['f(x,y,...) = ' fmin];
        set(handles.result_fx,'String',resultfx)
%         load handel.mat;
%         soundsc(y,Fs);
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
    case get(handles.button_simplex,'String')  %in case the name of the button is the same as the modified newton button
        [handles.num.min, handles.num.fmin, handles.num.time, handles.num.it_max] = simplex(func,x0,x1,x2,tol,tol,it,anim,impulso); %storing the result in handles
        min = sprintf('%g,',transpose(handles.num.min)); %preparing the result to be displayed in the gui
        resultx = ['x, y, ... =' min];
        set(handles.result_x,'String',resultx)
        fmin = num2str(handles.num.fmin);
        resultfx = ['f(x,y,...) = ' fmin];
        set(handles.result_fx,'String',resultfx)
 
        % plot(t_exp,m,'*b')
% plot(t_exp_10,m_10,'*r')
% axis([0 6 -4 4])
% title('10 Points Approximation')
% legend('Least Squares','Experimental Not Used','Experimental Used')
% hold off

        if impulso == 1
            t_exp = [0.500000000000000,1,1.50000000000000,2,2.50000000000000,3,3.50000000000000,4,4.50000000000000,5];
            t_exp_10 = [0.500000000000000,1,1.50000000000000,2,2.50000000000000,3,3.50000000000000,4,4.50000000000000,5];
            t_exp_2 = [1,4.50000000000000];
            t_exp_3 = [0.500000000000000,2.50000000000000,4.50000000000000];
            t_exp_5 = [0.500000000000000,1.50000000000000,2.50000000000000,3.50000000000000,4.50000000000000];
            m = [1.65000000000000,-1.30000000000000,0.500000000000000,-0.100000000000000,-0.150000000000000,0.150000000000000,-0.0500000000000000,0.0500000000000000,0.0100000000000000,0];
            m_10 = [1.65000000000000,-1.30000000000000,0.500000000000000,-0.100000000000000,-0.150000000000000,0.150000000000000,-0.0500000000000000,0.0500000000000000,0.0100000000000000,0];
            m_2 = [-1.30000000000000,0.0100000000000000];
            m_3 = [1.65000000000000,-0.150000000000000,0.0100000000000000];
            m_5 = [1.65000000000000,0.500000000000000,-0.150000000000000,-0.0500000000000000,0.0100000000000000];
            if func == handles.charsoma10
                plot(t_exp_10,m_10,'*r')
                axis([0 6 -4 4])
                title('10 Points Approximation')
                legend('Least Squares','Experimental Not Used','Experimental Used')
                hold off
            end
            if func == handles.charsoma5
                plot(t_exp_5,m_5,'*r')
                axis([0 6 -4 4])
                title('5 Points Approximation')
                legend('Least Squares','Experimental Not Used','Experimental Used')
                hold off
            end
            if func == handles.charsoma3
                plot(t_exp_3,m_3,'*r')
                axis([0 6 -4 4])
                title('3 Points Approximation')
                legend('Least Squares','Experimental Not Used','Experimental Used')
                hold off
            end
            if func == handles.charsoma2
                plot(t_exp_2,m_2,'*r')
                axis([0 6 -4 4])
                title('2 Points Approximation')
                legend('Least Squares','Experimental Not Used','Experimental Used')
                hold off
            end
                
                   if handles.num.it_max == it %if the minimum wasn't found, inform the final interval reached
            warning_it = min;
            warning = {'Máximo de iterações alcançado.' 'Ponto final igual a:' warning_it};
            warndlg(warning,'Aviso');
        end
            
        end
            
    case get(handles.button_genetico,'String')  %in case the name of the button is the same as the modified newton button
        [handles.num.min, handles.num.fmin, handles.num.time, handles.num.it_max] = genetico(func,xi,tol,it); %storing the result in handles
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


% --- Executes on button press in box_anim.
function box_anim_Callback(hObject, eventdata, handles)
% hObject    handle to box_anim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if (get(box_anim_Callback,'Value') == get(box_anim_Callback,'Max'))
% 	anim = 1;
% else
% 	anim = 0;
% end
% guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of box_anim


% --- Executes on button press in button_10am.
function button_10am_Callback(hObject, eventdata, handles)
% hObject    handle to button_10am (see GCBO)
charsoma10 = '((x*sin((3*x*(1 - y^2)^(1/2))/2)*exp(-(3*x*y)/2))/(1 - y^2)^(1/2) - 1/2)^2 + ((x*sin(2*x*(1 - y^2)^(1/2))*exp(-2*x*y))/(1 - y^2)^(1/2) + 1/10)^2 + ((x*sin(x*(1 - y^2)^(1/2))*exp(-x*y))/(1 - y^2)^(1/2) + 13/10)^2 + ((x*sin(3*x*(1 - y^2)^(1/2))*exp(-3*x*y))/(1 - y^2)^(1/2) - 3/20)^2 + ((x*sin(4*x*(1 - y^2)^(1/2))*exp(-4*x*y))/(1 - y^2)^(1/2) - 1/20)^2 + ((x*sin((5*x*(1 - y^2)^(1/2))/2)*exp(-(5*x*y)/2))/(1 - y^2)^(1/2) + 3/20)^2 + ((x*sin((7*x*(1 - y^2)^(1/2))/2)*exp(-(7*x*y)/2))/(1 - y^2)^(1/2) + 1/20)^2 + ((x*sin((x*(1 - y^2)^(1/2))/2)*exp(-(x*y)/2))/(1 - y^2)^(1/2) - 33/20)^2 + ((x*sin((9*x*(1 - y^2)^(1/2))/2)*exp(-(9*x*y)/2))/(1 - y^2)^(1/2) - 1/100)^2 - (x^2*sin(5*x*(1 - y^2)^(1/2))^2*exp(-10*x*y))/(y^2 - 1)';
set(handles.func_box,'String',charsoma10);
handles.func = charsoma10;
handles.charsoma10 = charsoma10;
guidata(hObject,handles);
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in button_5am.
function button_5am_Callback(hObject, eventdata, handles)
% hObject    handle to button_5am (see GCBO)
charsoma5 = '((x*sin((3*x*(1 - y^2)^(1/2))/2)*exp(-(3*x*y)/2))/(1 - y^2)^(1/2) - 1/2)^2 + ((x*sin((5*x*(1 - y^2)^(1/2))/2)*exp(-(5*x*y)/2))/(1 - y^2)^(1/2) + 3/20)^2 + ((x*sin((7*x*(1 - y^2)^(1/2))/2)*exp(-(7*x*y)/2))/(1 - y^2)^(1/2) + 1/20)^2 + ((x*sin((x*(1 - y^2)^(1/2))/2)*exp(-(x*y)/2))/(1 - y^2)^(1/2) - 33/20)^2 + ((x*sin((9*x*(1 - y^2)^(1/2))/2)*exp(-(9*x*y)/2))/(1 - y^2)^(1/2) - 1/100)^2';
set(handles.func_box,'String',charsoma5);
handles.func = charsoma5;
handles.charsoma5 = charsoma5;
guidata(hObject,handles);

% --- Executes on button press in button_3am.
function button_3am_Callback(hObject, eventdata, handles)
charsoma3 = '((x*sin((5*x*(1 - y^2)^(1/2))/2)*exp(-(5*x*y)/2))/(1 - y^2)^(1/2) + 3/20)^2 + ((x*sin((x*(1 - y^2)^(1/2))/2)*exp(-(x*y)/2))/(1 - y^2)^(1/2) - 33/20)^2 + ((x*sin((9*x*(1 - y^2)^(1/2))/2)*exp(-(9*x*y)/2))/(1 - y^2)^(1/2) - 1/100)^2';
set(handles.func_box,'String',charsoma3);
handles.func = charsoma3;
handles.charsoma3 = charsoma3;
guidata(hObject,handles);

% hObject    handle to button_3am (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in button_2am.
function button_2am_Callback(hObject, eventdata, handles)
charsoma2 = '((x*sin(x*(1 - y^2)^(1/2))*exp(-x*y))/(1 - y^2)^(1/2) + 13/10)^2 + ((x*sin((9*x*(1 - y^2)^(1/2))/2)*exp(-(9*x*y)/2))/(1 - y^2)^(1/2) - 1/100)^2';
set(handles.func_box,'String',charsoma2);
handles.func = charsoma2;
handles.charsoma2 = charsoma2;
guidata(hObject,handles);
% hObject    handle to button_2am (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in box_impulso.
function box_impulso_Callback(hObject, eventdata, handles)
% hObject    handle to box_impulso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
	handles.impulso = 1;
else
	handles.impulso = 0;
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of box_impulso
