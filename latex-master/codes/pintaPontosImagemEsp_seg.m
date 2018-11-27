function [indices_imagem] = pintaPontosImagemEsp_seg(file, estradas, mult, opcao, fig, pathResult, esp, it)

    ponto = [255 0 0];
    
    Im_final = imread(file);

    lin = size(Im_final,1);
    col = size(Im_final,2);

    if opcao == 1
        % Exibe pontos com a imagem no fundo
        if size(Im_final,3)==1
            Im_final = repmat(double(Im_final)./255,[1 1 3]);
        end
    else
        % Exibe pontos sem a imagem no fundo
        Im_final = ones(lin,col,3);
        Im_final = Im_final * 255;
    end

    padroes_por_linha = floor((col+(esp-mult))/esp);
    indices_imagem = zeros(padroes_por_linha,padroes_por_linha,2);

    % Transforma os indices dos padroes em coordenadas na imagem
    for j=1:size(estradas,1)
        for i=1:size(estradas,2)            
            if estradas(j,i)~=0                
                linha_do_padrao = ceil(estradas(j,i)/padroes_por_linha);
                linha = ((linha_do_padrao-1)*esp) + floor(mult/2);
                coluna_do_padrao = estradas(j,i) - ((linha_do_padrao - 1) * padroes_por_linha);
                coluna = ((coluna_do_padrao-1)*esp) + floor(mult/2);
                indices_imagem(j,i,1) = linha;
                indices_imagem(j,i,2) = coluna;
            else
                break
            end
        end       
    end

    for j=1:size(indices_imagem,1)
        for i=1:size(indices_imagem,2)
            if indices_imagem(j,i,1)~=0
                Im_final(indices_imagem(j,i,1),indices_imagem(j,i,2),:) = ponto;
            else
                break
            end
        end
    end

    h = figure(fig);
    imshow(Im_final);
    print(h,'-djpeg',strcat(pathResult,'/Pruning_',date));
        
    return

end

