function [minimum,F_min,elapsed_time,Iter_num] =  grad_con(exp,x0,tol,it)
x0 = transpose(x0);
%Metodo do gradiente conjugado
%Primeira versao do programa sera feita com base em funcoes quadraticas
%Depois vai ser adaptado para o caso geral
tic;
exp = sym(exp);
Iter_num = 0;
x = transpose(symvar(exp)); %vetor com as variaveis
%A = hessian(exp); %Matriz hessiana
gradsym = gradient(exp); %gradiente com variaveis simbolicas
beta = 0; %inercia da direcao, comeca com 0
%dir = 0; %vetor direcao
xk = x0;
grad = subs(gradsym,x,x0);
alphasym = sym('alpha');
alpha=100;dir=100;%zuera so pra comecar verdadeiro o while

h = waitbar(0, 'Aguarde');      %Inicializa a barra de progresso

while double(norm(alpha*dir)) > tol
    
    if Iter_num >= it
        disp('Atingiu numero maximo de iteracoes');
        break
    end
    
    grad_atual = double(grad);      %gradiente no ponto
    dir = double(-grad_atual + beta*dir);   %direcao de avanco
    %Para quadraticas, temos:
    %alpha = -transpose(dir)*grad_atual/(transpose(dir)*A*dir); %quantidade de avanco
    
    f_alpha = subs(exp,x,(xk + alphasym*dir));
    alpha = double(aurea(f_alpha, -20, 20,1e-3,30));
    
    if isnan(alpha) %corrigindo erro de divisao por 0
        break
    end
    
    old_xk = xk;
    xk = double(xk  + alpha*dir);  %avancando para um novo x
    
    %calculos para o ponto seguinte:
    grad = double(subs(gradsym,x,xk));      %gradiente no novo ponto
    %beta = norm(grad)/norm(grad_atual);
    beta = (norm(grad)-transpose(grad)*grad_atual)/norm(grad_atual); %calculo do proximo beta
    
    %CARTEADA MONUMENTAAAALLL
    if beta >= 0.9 % > 0.5
        beta = 0.5; % 0.3;
    end
    

    
    if abs(subs(exp,x,xk)-(subs(exp,x,old_xk)))/abs(subs(exp,x,old_xk)) < tol
        break
    end
    
    if norm(xk - old_xk)/norm(old_xk) < tol %outro criterio de parada
         break
    end
    
    Iter_num = Iter_num + 1;
    
    saturated_ratio = min(1, max(0, tol/norm(xk - old_xk)));
    percent = saturated_ratio*100;
    h = waitbar(tol/norm(xk - old_xk), h, ['Aguarde    ', num2str(percent, 3), '%']);                %Atualiza barra de progesso
%     if norm(alpha*dir) < tol && (abs(subs(exp,x,xk)-(subs(exp,x,old_xk)))/abs(subs(exp,x,old_xk)) < 0.001
%         break
%     end

end
close(h)
minimum = xk;
F_min = double(subs(exp,x,xk));
F_0 = double(subs(exp,x,x0));
elapsed_time = toc;

if max(size(minimum)) == 2
max_x = max(minimum(1), x0(1));
max_y = max(minimum(2), x0(2));
min_x = min(minimum(1), x0(1));
min_y = min(minimum(2), x0(2));

ezsurf(exp,[min_x-5, max_x+5, min_y-5, max_y+5])
hold on
scatter3(x0(1), x0(2),F_0,100,'white','filled')
scatter3(minimum(1),minimum(2),F_min,100,'red','filled')
hold off
end

disp(['Iterações: ', num2str(Iter_num), '/', num2str(it)])
disp(['Tempo de simulação: ', num2str(elapsed_time)])
disp(['Coordenadas do mínimo: ', '(', num2str(minimum(1)), ',' , num2str(minimum(2)), ',', num2str(F_min), ')'])


end