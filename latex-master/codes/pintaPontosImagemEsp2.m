function [padroes_por_linha] = pintaPontosImagemEsp(file, estradas, mult, opcao, fig, pathResult, esp)

    ponto = [0 255 0];

    Im_final  = imread(file);

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

    Im_final = double(Im_final);
    padroes_por_linha = floor((col+(esp-mult))/esp);
    indices_imagem = zeros(padroes_por_linha,2);

    % Transforma os indices dos padroes em coordenadas na imagem
    for i=1:size(estradas,2)
        if estradas(i) ~= 0
            linha_do_padrao = ceil(estradas(i)/padroes_por_linha);
            linha = ((linha_do_padrao-1)*esp) + floor(mult/2);
            coluna_do_padrao = estradas(i) - ((linha_do_padrao - 1) * padroes_por_linha);
            coluna = ((coluna_do_padrao-1)*esp) + floor(mult/2);
            indices_imagem(i,1) = linha;
            indices_imagem(i,2) = coluna;
        end
    end

    h = figure(fig);
    imshow(Im_final);
    hold on;
    
    for i=1:size(indices_imagem,1)
        if indices_imagem(i,1)~=0
            plot(indices_imagem(i,2),indices_imagem(i,1),'ro','MarkerFaceColor','r', 'MarkerSize', 5);
        else
            break;
        end
    end

    print(h,'-djpeg',strcat(pathResult,'/noPruning_',date));    

end

