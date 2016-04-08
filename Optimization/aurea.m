function [min, f_min, elapsed_time, L_lim, R_lim, Iter_Num] = aurea(exp, a, b, tol, n)
    tic                         %começa a contar o tempo
    %ENTRADAS:
        %expr: Expressao a ser minimizada
        %a: chute inferior(esquerdo)
        %b: chute superior(direito)
        %tol: tolerancia desejada
        %n: numero maximo de iteracoes
    %SAIDAS:
        %min: valor do minimo encontrado
        %L_lim: limite esquerdo depois de convergir para o minimo
        %R_lim: limite direito depois de convergir para o minimo
        %Iter_Num: Numero de iteracoes necessarias para convergir
    
        
    new_exp = sym(exp);         %string to sym
    x=symvar(new_exp);
    Iter_Num = 0;
    Iter_Req = n;
    x1=a;
    x4=b;
    L = abs(b-a);
    u=(sqrt(5)-1)/2;
    x3 = (1-u)*x1 + u*x4;
    x2 = u*x1+(1-u)*x4;
    while (n > 0)
        Iter_Num=Iter_Num+1;
        n = n - 1;
        f2 = subs(new_exp, x, x2);
        f3 = subs(new_exp, x, x3);
        if (f2 < f3)
            x4=x3;
            L = abs(x4-x1);
            if (L<tol)
                break
            end
            x3=x2;
            x2=u*x1+(1-u)*x4;
        else
            x1=x2;
            L = abs(x4-x1);
            if(L<tol)
                break
            end
            x2=x3;
            x3=(1-u)*x1+u*x4;
        end
    end
    L_lim = x1;
    R_lim = x4;
    min = (x1+x4)/2;
    f_min = double(subs(new_exp, x, min));
    t = -100:0.1:100;
    
     
    elapsed_time = toc;             %acaba de contar o tempo
    
    plot_exp = subs(new_exp, x, t);
    plot(t, plot_exp, '-b', min, f_min, 'rx')
    xlim([a b]);
    
   % assignin
    
    disp(['Iterações: ', num2str(Iter_Num), '/', num2str(Iter_Req)])
    disp(['Tempo de simulação: ', num2str(elapsed_time)])
    disp(['Coordenadas do mínimo: ', '(', num2str(min), ',', num2str(f_min), ')'])
end