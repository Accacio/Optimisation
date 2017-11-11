function [minimum, F_min, elapsed_time, Iter_num] = QuaseNewton(exp, x0, tol, n)
    %dados
    x0 = transpose(x0);
    tic;
    f = sym(exp);
    vars = symvar(f);
    array_size = size(vars);
    H0 = eye(array_size(2),array_size(2));
    syms alfa
    Iter_num = 0;
    xk = x0;%
    Hk = H0;
    grad = gradient(f);
    
    
    while  Iter_num < n  
    Iter_num = Iter_num + 1;
    gk = double(subs(grad, vars, transpose(xk))); %gradiente de f(xk)?
    dk = double((-1)*Hk*gk);
    ftil = subs(f,vars,transpose(xk + (alfa*dk)));
    alfak = double(Fibonacci(ftil,-100,100,1e-9,1000)); %encontrar forma melhor de limitar
    xk1 = double(xk + alfak*dk);
    t = double(xk1 - xk);
    if norm(t) < tol
        xk = double(xk1);
        break;
    end
    gk1 = double(subs(grad, vars, transpose(xk1)));
    gama = double(gk1 - gk);
    Hk1 = double(Hk - (((t*transpose(gama)*Hk)+(Hk*gama*transpose(t)))/(transpose(t)*gama))+(1+((transpose(gama)*Hk*gama)/(transpose(t)*gama)))*((t*transpose(t))/(transpose(t)*gama)));
    Hk = double(Hk1);
    xk = double(xk1);
    end
    elapsed_time = toc;
    minimum = xk;
    F_min = double(subs(f,vars,transpose(xk)));

minimum = double(xk);
F_0 = double(subs(f,vars,transpose(x0)));

min_size = size(minimum);
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

