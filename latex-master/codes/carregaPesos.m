function [wk_final wk_norm] = carregaPesos(loadFile, entradas, saidas)

    if(loadFile == 0)
        wk_final = rand(saidas,saidas,entradas);
    else
        fprintf('Carregando pesos da rede SOM...\n');
        load 'wk.mat';
    end

    SomaVets = zeros(saidas);
    wk_norm = wk_final;

    for i=1:entradas
        SomaVets = SomaVets + wk_norm(:,:,i);
    end

    for i=1:entradas
        wk_norm(:,:,i) = wk_norm(:,:,i)./SomaVets;
    end

    return

end

