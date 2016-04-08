tempo=0.5:0.5:5;
m_t=[1.65 -1.3 0.5 -0.1 -0.15 0.15 -0.05 0.05 0.01 0];
syms w_d x y t;
num=1;
w_d=x*sqrt(1-y^2);
h_t=(x^2/w_d)*exp(-y*x*t)*sin(w_d*t);
%%Mínimos Quadrados 
%Soma dos erros ao Quadrado é função objetivo
min_quad=0;
for i=1:num
    min_quad= min_quad + (subs(h_t,t,i)-m_t(i))^2;
end
min_quad