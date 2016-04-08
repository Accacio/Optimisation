function [min, f_min, elapsed_time, L_lim, R_lim, Iter_Num] = Fibonacci(expr, inicio_intervalo, fim_intervalo, tol, numero_reducoes)
    %dados
    tic
    a = inicio_intervalo;
    b = fim_intervalo;
    n = numero_reducoes;
    k = n + 1;
    Iter_Num = 0;
   
    %operacoes
    p = (1-sqrt(5))/(1+sqrt(5));
    alfa = (2/(1+sqrt(5)))*((1-p^k)/(1-p^(k+1)));    
    
    %loop
    while Iter_Num < n
        x1 = a;
        x4 = b;
        x = symvar(expr);
        Lini = b-a;
        x2 = alfa*x1 + (1-alfa)*x4;
        f2 = subs(expr,x,x2);
        fx2 = eval(f2);
        x3 = alfa*x4 + (1-alfa)*x1;
        f3 = subs(expr,x,x3);
        fx3 = eval(f3);
        if fx2 < fx3
            a = x1;
            b = x3;
            Lfin = b-a;
            if b-a < tol
                min = x2;
                f_min = fx2;
                break;
            end;
            alfa = (Lini - Lfin)/Lfin;
            Iter_Num = Iter_Num + 1;
            if Iter_Num >= n
                min = x2; 
                f_min = fx2;
                break;
            end;
        else
            a = x2;
            b = x4;
            Lfin = b-a;
            if b-a < tol
                min = x3; 
                f_min = fx3;
                break;
            end;
            alfa = (Lini-Lfin)/Lfin;
            Iter_Num = Iter_Num+1;
            if Iter_Num >= n
                min = x3;
                f_min = fx3;
                break;
            end
        end
    end
      L_lim = a;
      R_lim = b;
      elapsed_time = toc;
      t = -100:0.1:100;
    %  plot_exp = subs(expr, x, t);
    %  plot(t, plot_exp, '-b', min, f_min, 'rx')
    %  xlim([inicio_intervalo fim_intervalo]);
  %  disp(['Iterações: ', num2str(Iter_Num), '/', num2str(n)])
  %  disp(['Tempo de simulação: ', num2str(elapsed_time)])
   % disp(['Coordenadas do mínimo: ', '(', num2str(min), ',', num2str(f_min), ')'])
      
end
            
            