function [minimum,F_min,elapsed_time,iter_num]=  ploft(exp,x0,tol,tol2,n,anim)
tic
%% Defininitions

x=[x0;x0+[0 5];x0+[5 0]];
ploft_sound = audioread('Easter Egg/ploft.wav');
if anim==1
load handel.mat;
end
iter_num=0;
xf=0;
alpha = 1;
gamma = 2;
rho = 1/2;
sigma =1/2;
exp=sym(exp);
vars=symvar(exp);
figure
if anim==0
    h = waitbar(0, 'Aguarde');
end
x_f=[ x(1,:) double(subs(exp,vars,x(1,:))); x(2,:) double(subs(exp,vars,x(2,:))); x(3,:) double(subs(exp,vars,x(3,:)))];
x_f_sorted=sortrows(x_f,[3]);

while iter_num<n
    sd=sqrt(sum((x_f(:,3)-sum(x_f(:,3))/3).^2));
    iter_num=iter_num+1;
    if anim==0
        h = waitbar(iter_num/n,h,['Aguarde ',num2str(iter_num*100/n,3),'%']);
    end
    %% 1 Order
    x_f_sorted=sortrows(x_f_sorted,[3]);
    P =double([x_f_sorted(1) x_f_sorted(4); x_f_sorted(2) x_f_sorted(5) ;x_f_sorted(3) x_f_sorted(6)]);
    DT = delaunayTriangulation(P);
    if (anim==1) && (iter_num>1)
        waitforbuttonpress
    end
    triplot(DT,'color',[rand(1) rand(1) rand(1)])
    if anim==1
        soundsc(ploft_sound,44000)
    end
    CC=circumcenter(DT);
    if double(sqrt((x_f_sorted(1,1)-CC(1)).^2+(x_f_sorted(1,2)-CC(2)).^2))<tol
        disp(['Radius'])
        break;
    end
    if sd<tol2
        disp(['SD'])
        break;
    end
    
    hold on
    x_l=x_f_sorted(1,1:2);
    x_s=x_f_sorted(2,1:2);
    x_h=x_f_sorted(3,1:2);
    %% 2 Centroid
    x_o=double((x_l-x_s)/2+x_s);
    %% 3 Reflection
    x_r=double(x_o+alpha*(x_o-x_h));
    x_r_f=[x_r double(subs(exp,vars,x_r))];
    if sum(x_r_f(3)<x_f_sorted(:,3))==2
        x_f_sorted(3,:)=x_r_f;
        continue;
    end
    
    %% 4 Expansion
    if sum(x_r_f(3)<x_f_sorted(:,3))==3
        x_e=double(x_o+gamma*(x_r-x_o));
        x_e_f=[x_e double(subs(exp,vars,x_e))];
        if x_e_f(3)<x_r_f(3)
            x_f_sorted(3,:)=x_e_f;
            continue;
        else
            x_f_sorted(3,:)=x_r_f;
            continue;
        end
    end
    %% 5 Contraction
    if sum(x_r_f(3)<x_f_sorted(:,3))==1
        % Outside
        x_c=double(x_o+rho*(x_r-x_o));
        x_c_f=[x_c double(subs(exp,vars,x_c))];
        if x_c_f(3)<=x_r_f(3)
            x_f_sorted(3,:)=x_c_f;
            continue;
            
        end
        
        
    end
    if sum(x_r_f(3)<x_f_sorted(:,3))==0
        % Inside
        x_c=double(x_o+rho*(x_h-x_o));
        x_c_f=[x_c double(subs(exp,vars,x_c))];
        if x_c_f(3)<=x_f_sorted(3,3)
            x_f_sorted(3,:)=x_c_f;
            continue;
            
        end
    end
    
    
    
    %% 6 Reduction or Shrink
    x_s2=double(x_f_sorted(1,1:2)+sigma*(x_f_sorted(2,1:2)-x_f_sorted(1,1:2)));
    x_f_sorted(2,:)=[x_s2 double(subs(exp,vars,x_s2))];
    x_s3=double(x_f_sorted(1,1:2)+sigma*(x_f_sorted(3,1:2)-x_f_sorted(1,1:2)));
    x_f_sorted(3,:)=[x_s3 double(subs(exp,vars,x_s3))];
end
if anim==0
    close(h)
end
hold off
elapsed_time=toc;
x_f_sorted=double(sortrows(x_f_sorted,[3]));
minimum=x_f_sorted(1,1:2);
F_min=x_f_sorted(1,3);

disp(['Iterações: ', num2str(iter_num), '/', num2str(n)])
disp(['Tempo de simulação: ', num2str(elapsed_time)])
disp(['Coordenadas do mínimo: ', '(', num2str(minimum(1)), ',' , num2str(minimum(2)), ',', num2str(F_min), ')'])

if anim==1
    soundsc(y, Fs)
end
end