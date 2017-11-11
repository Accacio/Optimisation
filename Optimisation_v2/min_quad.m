function [A]=min_quad(t_exp,m,h,H_exp,U,met,x0,tol)
%
%
%               TRABALHO FINAL - OTIMIZAÇÃO
%   Realiza a identificação de parâmetros de um Sistema.
%
%
%       -Modo de uso
%   [A]=min_quad(t_exp,m,h,H_exp,U,met,x0,tol)
%   
%       Onde:
%           't_exp' é o tempo experimental
%           'm' é o valor da resposta para cada tempo em 't_exp'
%           'h' é a função da resposta em função dos parâmetros e de t
%           'H_exp' é a expressão da ~Função de Transferência do Sistema
%           'U' é a Transformada de Laplace da entrada
%           'met' é o método de minimização escolhido
%           'xo' é o ponto inicial
%           'tol' é a tolerância, usada como critério de parada
%
%       -Métodos de Minimização
%           'p'     Simplex (Nelder-Mead) (Recomendado)
%           'g'     Genético
%           's'     Gradiente
%           'gc'    Gradiente Conjugado
%           'n'     Newton
%           'qn'    Quase Newton
%           'nm'    Newton Modificado



close all
% valores da questão 2
t_exp1 = 0.5:0.5:5;
m1 = [1.65 -1.3 0.5 -0.1 -0.15 0.15 -0.05 0.05 0.01 0];
eval(['s=tf(''s''); U=' char(U) ';'])
syms x y t s
h1 = (x^2/x*sqrt(1-y^2))*exp(-y*x*t)*sin(x*sqrt(1-y^2)*t);
H_exp1=x^2/(s^2+2*y*x*s+x^2);

% somatório dos erros:
%% a) 3 amostras
c = 1;
t_exp_3=[];
m_3=[];
while c<11
    t_exp_3=[t_exp_3 t_exp(c)];
    m_3=[m_3 m(c)];
    erro3(c) = (m(c)-subs(h, t, t_exp(c)))^2;
    c = c+4;
end
soma3 = sum(erro3);

%% b) 5 amostras
c = 1;
t_exp_5=[];
m_5=[];
while c<11
    t_exp_5=[t_exp_5 t_exp(c)];
    m_5=[m_5 m(c)];
    erro5(c) = (m(c)-subs(h, t, t_exp(c)))^2;
    c = c+2;
end
soma5 = sum(erro5);

%% a) 10 amostras
c = 1;
t_exp_10=[];
m_10=[];
while c<11
    t_exp_10=[t_exp_10 t_exp(c)];
    m_10=[m_10 m(c)];
    erro10(c) = (m(c)-subs(h, t, t_exp(c)))^2;
    c = c+1;
end
soma10 = sum(erro10);
charsoma3=char(soma3);
charsoma5=char(soma5);
charsoma10=char(soma10);
%% 3 5 10


for pontos=[3 5 10]
    
switch met
    case 'p'
        eval(['[minimum,F_min,elapsed_time,iter_num]=ploft(charsoma' num2str(pontos) ',x0,tol,tol,200,0);']);
    case 'g'
        eval(['[minimum, f_min, elapsed_time, Iter_num] = genetico(charsoma' num2str(pontos) ',x0,tol, 100);'])
    case 's'
        eval(['[minimum, f_min, elapsed_time, Iter_num] = stegrades(charsoma' num2str(pontos) ',x0,tol, 100);'])
    case 'qn'
        eval(['[minimum, f_min, elapsed_time, Iter_num] = QuaseNewton(charsoma' num2str(pontos) ',x0,tol, 100);'])
    case 'nm'
        eval(['[minimum, f_min, elapsed_time, Iter_num] = newton_mod(charsoma' num2str(pontos) ',x0,tol, 100);'])
    case 'n'
        eval(['[minimum, f_min, elapsed_time, Iter_num] = newton_mod(charsoma' num2str(pontos) ',x0,tol, 100);'])
    case 'gc'
        eval(['[minimum, f_min, elapsed_time, Iter_num] = grad_con(charsoma' num2str(pontos) ',x0,tol, 100);'])
    otherwise
    eval(['[minimum,F_min,elapsed_time,iter_num]=ploft(charsoma' num2str(pontos) ',x0,tol,tol,100,0);']);
end
%Save iteration plot
set(gcf, 'PaperPosition', [0 0 8 8]);
set(gcf, 'PaperSize', [8 8]);
eval(['saveas(gcf,[''Plots/'' met ''_iter_' num2str(pontos) '.pdf'']);'])

eval(['A_' num2str(pontos) '=[ minimum];'])
H=subs(H_exp,[x y],minimum);
eval(['s=tf(''s''); H=' char(H) ';'])
figure
set(gcf, 'PaperPosition', [0 0 8 8]);
set(gcf, 'PaperSize', [8 8]);
impulse(H*U)
hold on
plot(t_exp,m,'*b')
eval(['plot(t_exp_' num2str(pontos) ',m_' num2str(pontos) ',''*r'')'])
axis([0 6 -4 4])
title([num2str(pontos) ' Points Approximation'])
legend('Least Squares','Experimental Not Used','Experimental Used')
eval(['saveas(gcf,[''Plots/'' met ''_impulse_' num2str(pontos) '.pdf'']);'])
hold off
syms s
end







% %% 3 Amostras
% switch met
%     case 'p'
%     [minimum,F_min,elapsed_time,iter_num]=ploft(charsoma3,x0,tol,tol,100,0);
%     case 'g'
%     [minimum, f_min, elapsed_time, Iter_num] = genetico(charsoma3,x0,tol, 100);
%     case 's'
%     [minimum,F_min,elapsed_time,Iter_num]=stegrades(charsoma3,x0,tol,100);
%     case 'qn'
%     [minimum, F_min, elapsed_time, Iter_num] = QuaseNewton(charsoma3,x0, tol, 100);
%     case 'nm'
%     [minimum,F_min,elapsed_time,Iter_num] =  newton_mod(charsoma3,x0,tol,100);
%     case 'n'
%     [minimum,F_min,elapsed_time,Iter_num] =  newton_mod(charsoma3,x0,tol,100);
%     case 'gc'
%     [minimum,F_min,elapsed_time,Iter_num] =  grad_con(charsoma3,x0,tol,100);
%     otherwise
%     [minimum,F_min,elapsed_time,iter_num]=ploft(charsoma3,x0,tol,tol,100,0);
% end
% A=[minimum'];
% H=subs(H_exp,[x y],minimum);
% eval(['s=tf(''s''); H=' char(H) ';U=' char(U) ';'])
% figure
% impulse(H*U)
% hold on
% plot(t_exp,m,'*b')
% plot(t_exp_3,m_3,'*r')
% axis([0 6 -4 4])
% title('3 Points Approximation')
% legend('Least Squares','Experimental Not Used','Experimental Used')
% hold off
% syms s
% %% 5 Amostras
% switch met
%     case 'p'
%     [minimum,F_min,elapsed_time,iter_num]=ploft(charsoma5,x0,tol,tol,100,0);
%     case 'g'
%     [minimum, f_min, elapsed_time, Iter_num] = genetico(charsoma5,x0,tol, 100);
%     case 's'
%     [minimum,F_min,elapsed_time,Iter_num]=stegrades(charsoma5,x0,tol,100);
%     case 'qn'
%     [minimum, F_min, elapsed_time, Iter_num] = QuaseNewton(charsoma5,x0, tol, 100);
%     case 'nm'
%     [minimum,F_min,elapsed_time,Iter_num] =  newton_mod(charsoma5,x0,tol,100);
%     case 'n'
%     [minimum,F_min,elapsed_time,Iter_num] =  newton_mod(charsoma5,x0,tol,100);
%     case 'gc'
%     [minimum,F_min,elapsed_time,Iter_num] =  grad_con(charsoma5,x0,tol,100);
%     otherwise
%     [minimum,F_min,elapsed_time,iter_num]=ploft(charsoma5,x0,tol,tol,100,0);
% end
% set(gcf, 'PaperPosition', [0 0 8 8]);
% set(gcf, 'PaperSize', [8 8]);
% saveas(gcf,[met '_iter_5.pdf']);
% A=[A minimum'];
% H=subs(H_exp,[x y],minimum);
% eval(['s=tf(''s''); H=' char(H) ';'])
% figure
% impulse(H*U)
% hold on
% plot(t_exp,m,'*b')
% plot(t_exp_5,m_5,'*r')
% axis([0 6 -4 4])
% title('5 Points Approximation')
% legend('Least Squares','Experimental Not Used','Experimental Used')
% saveas(gcf,[met '_impulse_5.pdf']);
% 
% hold off
% syms s
% %% 10 Amostras
% switch met
%     case 'p'
%     [minimum,F_min,elapsed_time,iter_num]=ploft(charsoma10,x0,tol,tol,100,0);
%     case 'g'
%     [minimum, f_min, elapsed_time, Iter_num] = genetico(charsoma10,x0, tol, 100);
%     case 's'
%     [minimum,F_min,elapsed_time,Iter_num]=stegrades(charsoma10,x0,tol,100);
%     case 'qn'
%     [minimum, F_min, elapsed_time, Iter_num] = QuaseNewton(charsoma10,x0, tol, 100);
%     case 'nm'
%     [minimum,F_min,elapsed_time,Iter_num] =  newton_mod(charsoma10,x0,tol,100);
%     case 'n'
%     [minimum,F_min,elapsed_time,Iter_num] =  newton_mod(charsoma10,x0,tol,100);
%     case 'gc'
%     [minimum,F_min,elapsed_time,Iter_num] =  grad_con(charsoma10,x0,tol,100);
%     otherwise
%     [minimum,F_min,elapsed_time,iter_num]=ploft(charsoma10,x0,tol,tol,100,0);
% end
% A=[A minimum'];
% H=subs(H_exp,[x y],minimum);
% eval(['s=tf(''s''); H=' char(H) ';'])
% figure
% impulse(H*U)
% hold on
% plot(t_exp_10,m_10,'*r')
% axis([0 6 -4 4])
% title('10 Points Approximation')
% legend('Least Squares','Experimental Used')
% hold off
% syms s
end