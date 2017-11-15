%NEWTON

function [minimum,F_min,elapsed_time,Iter_num] =  newton_mod(exp,x0,tol,n)

tic;             %Comeca a contar o tempo

xk = x0;
Iter_num = 0;
alpha = sym('alpha');
exp = sym(exp);
x = symvar(exp);

grad = gradient(exp,x);
hess = hessian(exp,x);

h = waitbar(0, 'Aguarde');      %Inicializa a barra de progresso

while Iter_num < n
    
    %h = waitbar(Iter_num/n, h, ['Número de Iterações: ', num2str(Iter_num), '/', num2str(n)]);                %Atualiza barra de progesso

    Iter_num = Iter_num + 1;
    
    gk = subs(grad,x,xk);
    Gk = subs(hess,x,xk);
           
    dk = -((gk)'/Gk);
    
    f_alpha = subs(exp,x,(xk + alpha*dk));
    alpha_k = aurea(f_alpha, -20, 20,1e-3,30);
    
    xk1 = double(xk + alpha_k*dk);
    t = double(xk1 - xk);
    
    xk = double(xk1);
    
    saturated_ratio = min(1, max(0, tol/norm(t)));
    percent = saturated_ratio*100;
    h = waitbar(tol/norm(t), h, ['Aguarde    ', num2str(percent, 3), '%']);                %Atualiza barra de progesso
    
    if norm(t) < tol
        break;
    end
    
end
close(h)         %Fecha a barra de progresso

minimum = double(xk);
F_min = double(subs(exp,x,xk));
F_0 = double(subs(exp,x,x0));

elapsed_time=toc;

min_size = size(minimum);
% if min_size(2) == 1
%     minimum(2) = 0;
%     x0(2) = 0;
% end
if max(min_size) == 2
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

disp(['Iterações: ', num2str(Iter_num), '/', num2str(n)])
disp(['Tempo de simulação: ', num2str(elapsed_time)])
disp(['Coordenadas do mínimo: ', '(', num2str(minimum(1)), ',' , num2str(minimum(2)), ',', num2str(F_min), ')'])



end
