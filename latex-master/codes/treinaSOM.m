function [wk_norm] = treinaSOM(xTrain_norm, wk_norm, saidas, taxa, epocas)

    fprintf('Treinando a rede SOM...\n');
    t = tic;
    
    % Definir o mapa topologico
    raioMap0 = saidas - (saidas * 0.3);
    raioMap = raioMap0;
    eta = taxa;
    eta0 = eta;
    NumEpMax = epocas;
    lambda = NumEpMax/log(raioMap);
     
    for ep = 1:NumEpMax
        p = ceil(rand(1) * size(xTrain_norm,2));
        raioViz = floor(raioMap * exp(-(ep/lambda)));

        % Calcular as distancias euclidianas entre os vetores de entrada e
        % de pesos para cada neuronio
        d = zeros(saidas);

        for x=1:saidas
            for y=1:saidas
                %err(x,y) = sum(wk_norm(x,y,:).^2);
                a = wk_norm(x,y,:);
                b = xTrain_norm(:,p);
                d(x,y) = sum((a(:) - b(:)).^2);
            end
        end

        % Encontrar o vencedor
        [vec_l vec_c] = find(d == min(min(d)));
        l = vec_l(1);
        c = vec_c(1);
                
        % Ajusta os pesos do vencedor e dos vizinhos
        wk_norm = ajustarPesos(xTrain_norm, wk_norm, raioViz, l, c, eta, saidas, p);

        % Ajustar taxa de aprendizagem e influencia da Gaussiana
        eta = eta0 * exp(-(ep/NumEpMax));

    end

    fprintf('Treinamento concluido em %0.2f minutos!\n', (toc(t)/60));        
    return

end

