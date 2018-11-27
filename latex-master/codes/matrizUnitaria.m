function [matrizU] = matrizUnitaria(wk_final, pathResult)

    matrizU = zeros(size(wk_final,1));
    
    for i=1:size(wk_final,1)
        for j=1:size(wk_final,1)
            matrizU(i,j) = sqrt(sum(wk_final(i,j,:).^2));
        end
    end
    
    % Apresenta os pesos em imagem colorida com base na norma dos dados.
     h = figure(1);
     imagesc(matrizU);
     title('Norma dos vetores de pesos do mapa de Kohonen');
     print(h,'-djpeg',strcat(pathResult,'/norma'));
    
    return
end

