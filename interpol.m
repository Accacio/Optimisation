function [minimum,F_min,elapsed_time,L_lim,R_lim,Iter_Num] = interpol(exp, a, b, tol, n)
    Sol=[];
    I=0;
    tic;
    equation=sym(exp);
    x=symvar(equation);
    xi = a;
    xf = b;
    V=[a a/2+b/2 b];
    F=[ double(subs(equation,x,V(1))) double(subs(equation,x,V(2))) double(subs(equation,x,V(3)))];

    while (((max(V(V<max(V)))- min(V) )>tol) &&(I<n))
      A=sparse([V(1)^2 V(1) 1; V(2)^2 V(2) 1 ; V(3)^2 V(3) 1]);
      %R=linsolve(A,F')
      R=A\F';
      Sol=-R(2)/(2*R(1));
      [maxvalue maxindex]=max([F double(subs(equation,x,Sol))]);
      if (maxindex==4)
        [maxvalue maxindex]=max(F);
      end


        V(maxindex)=[Sol];
        F(maxindex)=[double(subs(equation,x,Sol))];

      I=I+1;
      format long
      minimum=double(Sol);
      F_min=double(subs(equation,x,Sol));
      L_lim=min(V);
      R_lim=max(V);
      Iter_Num=I;
      
    end




    elapsed_time=toc;
    t = -5+minimum:0.1:5+minimum;
    plot_exp = subs(exp, x, t);
    plot(t, plot_exp, '-b', minimum, F_min, 'rx')
    xlim([xi xf]);
    disp(['Iterações: ', num2str(Iter_Num), '/', num2str(n)])
    disp(['Tempo de simulação: ', num2str(elapsed_time)])
    disp(['Coordenadas do mínimo: ', '(', num2str(minimum), ',', num2str(F_min), ')'])

end

%Where in the world is Camen Sandiego???
