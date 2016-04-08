function [minimum,F_min,elapsed_time,Iter_num]=  stegrades(exp,x0,tol,n)
tic   

   Iter_num=1;
   xf=0;
   syms a;
   exp=sym(exp);
   x=symvar(exp);
   gradf=gradient(exp,x).';
   h = waitbar(0, 'Aguarde');
   %1
   xk = x0;
   f_0=double(subs(exp,x,xk));
   while true
    h = waitbar(Iter_num/n);
    %2
    f_xk=double(subs(exp,x,xk));
    g=subs(gradf,x,xk);
    %3
    norm_g=norm(g);
    norm_f_xk=norm(f_xk);
    if norm_g<tol
        xf=xk;
        xk1=xk;
        f_xk1=f_xk;
        break;
    end
    %4
    dk=-g/norm_g;
    %5
    f_a=subs(exp,x,xk+a*dk);
    %6
    [ak, dummy] = aurea(f_a, -50,50, 1e-5, 30);
    %7
    xk1=double(xk+ak*dk);
    f_xk1=double(subs(exp,x,xk1));
    norm_f_xkk1=double(norm(f_xk1-f_xk));
    Iter_num=Iter_num+1;

    if (norm(xk1-xk)<tol)
        disp(['DiferenÃ§a entre x.']);
        break;
    end
    if (Iter_num==n)
        disp(['Número de iterações de simulação estourou.']);
        break;
    end
    xk=xk1;
   end
   close(h)
   xf=double(xk1);
   elapsed_time=toc;
   minimum=xf;
   F_min=f_xk1;

F_0 = double(subs(exp,x,x0));

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
