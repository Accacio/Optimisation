% TRABALHO FINAL - OTIMIZAÇÃO
clear

% valores da questão 2
t_exp = 0.5:0.5:5;
m = [1.65 -1.3 0.5 -0.1 -0.15 0.15 -0.05 0.05 0.01 0];

syms x y t
wd = x*sqrt(1-y^2);
h = (x^2/wd)*exp(-y*x*t)*sin(wd*t);
s=tf('s');
% somatório dos erros:
%% 2 amostras
c = 2;
t_exp_2=[];
m_2=[];
while c<11
    t_exp_2=[t_exp_2 t_exp(c)];
    m_2=[m_2 m(c)];
    erro2(c) = (m(c)-subs(h, t, t_exp(c)))^2;
    c = c+7;
end
soma2 = sum(erro2);

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
charsoma2=char(soma2);
charsoma3=char(soma3);
charsoma5=char(soma5);
charsoma10=char(soma10);

%% 3 Amostras
[minimum,F_min,elapsed_time,iter_num]=ploft(charsoma3,[0 0],1e-8,1e-8,100,0);
H=minimum(1)^2/(s^2+2*minimum(2)*minimum(1)*s+minimum(1)^2);
figure
impulse(H)
hold on
plot(t_exp,m,'*b')
plot(t_exp_3,m_3,'*r')
axis([0 6 -4 4])
title('3 Points Approximation')
legend('Least Squares','Experimental Not Used','Experimental Used')
hold off
%% 5 Amostras
[minimum,F_min,elapsed_time,iter_num]=ploft(charsoma5,[0 0],1e-8,1e-8,100,0);
H=minimum(1)^2/(s^2+2*minimum(2)*minimum(1)*s+minimum(1)^2);
figure
impulse(H)
hold on
plot(t_exp,m,'*b')
plot(t_exp_5,m_5,'*r')
axis([0 6 -4 4])
title('5 Points Approximation')
legend('Least Squares','Experimental Not Used','Experimental Used')
hold off
%% 10 Amostras
[minimum,F_min,elapsed_time,iter_num]=ploft(charsoma10,[0 0],1e-8,1e-8,100,0);
H=minimum(1)^2/(s^2+2*minimum(2)*minimum(1)*s+minimum(1)^2);
figure
impulse(H)
hold on
plot(t_exp_10,m_10,'*r')
axis([0 6 -4 4])
title('10 Points Approximation')
legend('Least Squares','Experimental Used')
hold off




% plot(t_exp,m,'*b')
% plot(t_exp_10,m_10,'*r')
% axis([0 6 -4 4])
% title('10 Points Approximation')
% legend('Least Squares','Experimental Not Used','Experimental Used')
% hold off


