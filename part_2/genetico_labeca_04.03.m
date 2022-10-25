% ALGORITMO GENÉTICO

function [min, f_min, elapsed_time, Iter_num] = genetico(exp, x0, tol, n)

tic;             %Comeca a contar o tempo

Iter_num = 0;
exp = sym(exp);
x = symvar(exp);
Pfit = [inf inf];

%% Primeira geração

density = 100;
limits = 100;
g1x = 2*limits*rand(1,density) -limits+x0(1);
g1y = 2*limits*rand(1,density) -limits+x0(2);
% plot(g1x, g1y, 'xb', 'LineWidth',2)
% axis([-limits+x0(1),limits+x0(1),-limits+x0(2),limits+x0(2)])

%% Calcular todos os valores de exp para os pontos da primeira geração

while Iter_num < n
    Iter_num = Iter_num+1;
    
    c = 1;
    exp_g = zeros(1, length(g1x));
    gsize = size(g1x);
    
    while c < gsize(2)
        exp_g(c) = subs(exp, [x(1), x(2)], [g1x(c), g1y(c)]);
        c = c+1;
    end
    
    %% Selecionar os mais aptos (com duplicação)
    
    mfit = mean(exp_g);
    fit = zeros(length(g1x),1);
    int_fit = zeros(length(g1x),1);
    dec_fit = zeros(length(g1x),1);
    prob_fit = zeros(length(g1x),1);
    R = 2;
    
    c = 1;
    while c < length(g1x)+1
        fit(c) = mfit/exp_g(c);            % fitness de toda a população
        fit(c) = fit(c)/R;                 % fator de redução de população
        int_fit(c) = floor(fit(c));        % parte inteira da fitness
        
%         if int_fit(c) > 1/tol             % saturação
%             int_fit(c) = 1/tol;
%         end
        
        dec_fit(c) = fit(c)-int_fit(c);    % parte decimal da fitness
        prob_fit(c) = rand > 1-dec_fit(c); % 1 ou 0 para a segunda duplicação
        c = c+1;
    end
    
    
    fit = int_fit+prob_fit; % Número de vezes que os pontos serão clonados para a proxima geração
    
   
    %% População intermediária
    
    g1x_inter = [];                        % inicia a matriz nula
    g1y_inter = [];
    
    
    c = 1;
    while c < length(g1x)+1
        g1x_inter = [g1x_inter repmat(g1x(c),1,fit(c))];   % append nos últimos valores da matriz
        g1y_inter = [g1y_inter repmat(g1y(c),1,fit(c))];
        c = c+1;
    end
    
    %% Recombinar os selecionados para a próxima geração
    
    g_inter = [g1x_inter; g1y_inter];
    
    g_inter_shuffled = g_inter(:,randperm(size(g_inter,2)));
    sz = size(g_inter);
    dec_sz = sz(2)/3-floor(sz(2)/3);
    restox = [];
    restoy = [];
    
    % checa se é multiplo de 3
    if dec_sz ~= 0
        if round(dec_sz)
            restox = mean(g_inter_shuffled(1,end-1:end));   % média dos dois últimos valores em x
            restoy = mean(g_inter_shuffled(2,end-1:end));   % média dos dois últimos valores em y
            g_inter_shuffled = g_inter_shuffled(:,1:end-2); % multiplo de 3
        else
            restox = g_inter_shuffled(1,end);               % último valor em x
            restoy = g_inter_shuffled(2,end);               % último valor em y
            g_inter_shuffled = g_inter_shuffled(:,1:end-1); % multiplo de 3
        end
    end
    
    sz_shuf = size(g_inter_shuffled);
    
    g2x = zeros(1,sz_shuf(2));
    g2y = zeros(1,sz_shuf(2));
    
    c = 1;
    d = 1;
    
    while c < sz_shuf(2)+1   % numero de colunas de g_inter_shuffled   g2x(d) = mean(g_inter_shuffled(1, c:c+2));
        g2x(d) = mean(g_inter_shuffled(1, c:c+2));
        g2y(d) = mean(g_inter_shuffled(2, c:c+2));
        d = d+1;
        c = c+3;
    end
    
    g2x = g2x(:,1:d);
%     g2x = [g2x restox];
    g2y = g2y(:,1:d);
%     g2y = [g2y restoy];
    
    g2 = [g2x; g2y];
    
  %% Critério de parada
    
    [~, I] = max(fit);
    Pfit_old = [g1x(I) g1y(I)];
    Pdif = abs(Pfit_old-Pfit);
    norm = sqrt(Pdif(1)^2 + Pdif(2)^2); 
    if norm < tol
        break
    else Pfit = Pfit_old;
    end
    
    %% Plota os gráficos das populações
    disp(['Numero de Iteracoes: ', num2str(Iter_num)])
    
    hold off
    plot(g1x, g1y, 'bx', g1x_inter, g1y_inter, 'ro', g2x, g2y, 'g+', 'LineWidth',2)
    drawnow;
    hold on
       
    %% Voltar à primeira geração
    
    g1x = g2x;
    g1y = g2y;
    
end

elapsed_time=toc;

min = [g1x(I) g1y(I)];
f_min = subs(exp, [x(1), x(2)], [g1x(I), g1y(I)]);
f_min = double(f_min);

hold off
ezsurf(exp)
hold on
scatter3(g1x(I), g1y(I),0,100,'red','filled')
drawnow;

end

