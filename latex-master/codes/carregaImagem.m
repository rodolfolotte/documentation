function [I file] = carregaImagem

    % Filtra somente arquivos .tif
    [filename, pathname] = uigetfile({'*.tif'},'Selecione uma imagem');
    file = strcat(pathname,filename);
    Im = imread(file);

    % Se tiver 3 bandas, converte para tons de cinza
    if (size(Im,3) == 3)
        I = rgb2gray(Im);
    end

    I = double(Im);
    
    return

end

