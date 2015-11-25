function [minimo, numI] = Fibonacci(expr, inicio_intervalo, fim_intervalo, numero_reducoes, indice_fibonacci, tol)
    %dados
    a = inicio_intervalo;
    b = fim_intervalo;
    n = numero_reducoes;
    k = indice_fibonacci;
    numI = 0;
   
    %operacoes
    p = (1-sqrt(5))/(1+sqrt(5));
    alfa = (2/(1+sqrt(5)))*((1-p^k)/(1-p^(k+1)));    
    
    %loop
    while numI < n
        x1 = a;
        x4 = b;
        x = symvar(expr);
        Lini = b-a;
        x2 = alfa*x1 + (1-alfa)*x4;
        f2 = subs(expr,x,x2);
        fx2 = eval(f);
        x3 = alfa*x4 + (1-alfa)*x1;
        f3 = subs(expr,x,x3);
        fx3 = eval(f);
        if fx2 < fx3
            a = x1;
            b = x3;
            Lfin = b-a;
            if b-a < tol
                minimo = fx2;
                break;
            end;
            alfa = (Lini - Lfin)/Lfin;
            numI = numI + 1;
            if numI >= n
                minimo = fx2;
                break;
            end;
        else
            a = x2;
            b = x4;
            Lfin = b-a;
            if b-a < tol
                minimo = fx3;
                break;
            end;
            alfa = (Lini-Lfin)/Lfin;
            numI = numI+1;
            if numI >= n
                minimo = fx3;
                break;
            end
        end
    end
end
            
            