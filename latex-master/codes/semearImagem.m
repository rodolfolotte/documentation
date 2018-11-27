function [pontosSementes] = semearImagem(xAmostra_norm, wk_norm, centros, saidas)

    cont = 1;
    NumPadroes = size(xAmostra_norm,3);
    pontosSementes = zeros(1,NumPadroes);

    for p=1:NumPadroes
        dist_Estrada = zeros(1,size(centros,1));

        % Calcular as distancias euclidianas entre os vetores de entrada e
        % de pesos para cada neuronio
        d = zeros(saidas);
        minOrient = zeros(1,size(xAmostra_norm,1));
        
        for x=1:saidas
            for y=1:saidas
                a = wk_norm(x,y);
                % Qual orientacao tem mais semelhanca com algum dos padroes
                for orient=1:size(xAmostra_norm,1)
                    b = xAmostra_norm(orient,:,p);
                    d(x,y) = sum((a - b(:)).^2);
                    minOrient(1,orient) = d(x,y);
                end
                [menorValor indiceOrientacao] = min(minOrient);
                
                b = xAmostra_norm(indiceOrientacao,:,p);
                d(x,y) = sum((a(:) - b(:)).^2);
            end
        end

        % Encontrar o vencedor
        [vec_l vec_c] = find(d == min(min(d)));
        l = vec_l(1);
        c = vec_c(1);
        
        % Verifica se ha algum outro centro com distancia menor para o padrao "p".
        % Se tiver, entao o padrao e relacionado como sendo uma estrada.
        for i=1:size(centros,1)
            dist_Estrada(1,i) = sqrt((l - centros(i,1))^2 + (c - centros(i,2))^2);
        end
        [distMin padraoMin] = min(dist_Estrada);
        
        if padraoMin >= (size(centros,1)/2)      
            pontosSementes(cont) = p;
            cont = cont + 1;
        end
    end

    return

end

