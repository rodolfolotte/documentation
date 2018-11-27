function [X X_norm] = carregaAmostrasEsp(Imagem, NumEntradas, esp)

    lin = size(Imagem,1); % Quantidade de linhas da imagem
    col = size(Imagem,2); % Quantidade de colunas da imagem
    mult = sqrt(NumEntradas); % Dimensao quadratica da janela de varredura
    l_inicio = 1; c_inicio = 1; 
    l_fim = 1; c_fim = 1;            

    % ----- Inicializa variaveis -------         
    padrao=1;
    inclinationStep = 4; 

    indicePadraoColuna = 1; 
    indicePadraoLinha = 1;
   
    % Varre a imagem e agrega cada valor do pixel a um valor de entrada
    % do padrao de entrada correspondente.
    while ((l_inicio + (mult-1)) < lin)
        
        c_fim = c_inicio + (mult-1);
        l_fim = l_inicio + (mult-1);
        c_cont = 0;
        orient = 1;        
        auxCoord = zeros(ceil(mult/inclinationStep),mult,2);
        
        for i=c_inicio:inclinationStep:c_fim
            % Orientacoes de 135 a 45 graus            
            auxCoord(orient,:,:) = bresenham(l_inicio,i,l_fim,c_fim-(c_cont));
            c_cont = c_cont + inclinationStep;
                        
            if(orient ~= 1)
                if (orient+(ceil(mult/inclinationStep)-1) <= floor((mult*2)/inclinationStep))
                    
                    orientOpost = orient+(ceil(mult/inclinationStep)-1);
                    c2_cont = c_fim;
                    
                    % Amostras na diagonal
                    if(indicePadraoLinha == indicePadraoColuna)                        
                        for h=1:mult
                            auxCoord(orientOpost,h,1) = auxCoord(orient,h,2);
                            auxCoord(orientOpost,h,2) = c2_cont;
                            c2_cont = c2_cont - 1;
                        end
                    end
                    
                    % Amostras acima da diagonal
                    if(indicePadraoLinha < indicePadraoColuna)
                        aux = (esp*(indicePadraoColuna-indicePadraoLinha));                        
                        for h=1:mult                            
                            auxCoord(orientOpost,h,1) = auxCoord(orient,h,2) - aux;
                            auxCoord(orientOpost,h,2) = c2_cont;
                            c2_cont = c2_cont - 1;
                        end
                    end
                    
                    % Amostras abaixo da diagonal
                    if(indicePadraoLinha > indicePadraoColuna)
                        aux = (esp*(indicePadraoLinha-indicePadraoColuna));                                      
                        for h=1:mult                            
                            auxCoord(orientOpost,h,1) = auxCoord(orient,h,2) + aux;
                            auxCoord(orientOpost,h,2) = c2_cont;
                            c2_cont = c2_cont - 1;
                        end
                    end
                    
                end
            end            
            orient = orient + 1;            
        end
                
        % Popula o vetor de entrada X, com as orientacoes da amostra lida
        for slope=1:size(auxCoord,1)            
            for input=1:mult                
                if (Imagem(auxCoord(slope,input,1),auxCoord(slope,input,2)) == 0)
                    X(slope,input,padrao) = 1;
                else
                    X(slope,input,padrao) = Imagem(auxCoord(slope,input,1),auxCoord(slope,input,2));
                end
            end
        end
        
        c_inicio = c_inicio + esp;
        indicePadraoColuna = indicePadraoColuna + 1;
        padrao = padrao + 1;
        
        % Se exceder o incremento de colunas: pule de linha
        if (c_inicio + (mult-1)) > col
            l_inicio = l_inicio + esp;
            c_inicio = 1;
            indicePadraoLinha = indicePadraoLinha + 1;
            indicePadraoColuna = 1;
        end 
    end

    % Normaliza dados de treinamento
    X_norm = X;
        
    for m=1:size(X,3)
        u = X(:,:,m);
        X_norm(:,:,m) = u/norm(u);
    end    
    
    return

end

