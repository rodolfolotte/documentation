function SSS(saidas,taxa,epocas,opcao,loadFile)
        
    % - TREINAMENTO DA RNA ------------------------------------------------
    
    % Carrega os padroes de treinamento
    %  arg: 0 - Nao carrega dados do sistema de arquivo
    %       1 - Carrega dado do sistema de arquivo (raiz do projeto)
    %  retorno: Vetores de entradas X bruta e normalizada,
    %           respectivamente. [matriz - Cada linha um padrao de treinamento]
    [xTrain xTrain_norm] = carregaPadroes(0);
    
    NumEntradas = size(xTrain_norm,1);
    JanelaVarredura = NumEntradas^2;
    
    % Inicializa os pesos de treinamento
    %  arg: 0 - Nao carrega dados do sistema de arquivo
    %       1 - Carrega dado do sistema de arquivo (raiz do projeto)
    %  retorno: Matrizes de pesos W bruta e normalizada [matriz]
    [wk wk_norm] = carregaPesos(loadFile, NumEntradas, saidas);
    
    % Treina a rede neural
    %  arg 1: Matriz de entrada normalizada [matriz]
    %  arg 2: Matriz de pesos normalizada [matriz]
    %  arg 3: Dimensao do mapa de neuronios [escalar]
    %  arg 4: Taxa de aprendizagem da rede [escalar]
    %  arg 5: Numero maximo de epocas [escalar]
    %  retorno: Mapa final de pesos apos o treinamento [matriz]
    [wk_final] = treinaSOM(xTrain_norm, wk_norm, saidas, taxa, epocas);
                
    % Obtem a matriz unitaria (norma dos pesos)
    %  arg: Matriz W, matriz final de pesos [matriz]   
    %  retorno: Matriz U [matriz]
    [matrizU] = matrizUnitaria(wk_final, pathResult);
    
    % - SEMEACAO ----------------------------------------------------------
    
    % Carrega a imagem    
    %  retorno 1: Imagem em niveis de cinza [matriz]
    %  retorno 2: Caminho da imagem      
    [I file] = carregaImagem;
    
    % Realiza a leitura das amostras
    %  arg 1: Imagem [matriz]
    %  arg 2: Dimensao da janela de leitura [escalar]
    %  arg 3: Tamanho do salto [escalar]
    %  retorno: Todas as amostras lidas, dispostas em vetores de dados e
    %           os dados normalizados correspondentes [matrizes]
    [xAmostra xAmostra_norm] = carregaAmostrasEsp(I, JanelaVarredura, esp);

    % Localiza os centros dos clusters
    %  arg 1: Padroes de treinamento [matriz]
    %  arg 2: Matriz de pesos finais [matriz]
    %  arg 3: Dimensao do mapa de neuronios [escalar]
    %  arg 4: Matriz unitaria dos pesos [escalar]
    %  retorno: Localizacao do centro de cada cluster [matriz]
    [centros] = localizaCluster(xTrain_norm, wk_final, saidas, matrizU);

    % Realiza a Semeacao
    %  arg 1: Vetores de amostras normalizados [matriz]
    %  arg 2: Matriz de pesos normalizados [matriz]
    %  arg 3: Matriz contendo as informacoes de localizacao, raio e raio
    %         de pertinencia de cada aglomerado [matriz]
    %  arg 4: Dimensao do mapa de neuronios [escalar]
    %  retorno: Vetor de indices referentes as amostras que foram apontadas
    %           como ponto semente [vetor]
    [pontosSementes] = semearImagem(xAmostra_norm, wk_final, centros, saidas);
    
    % Modifica extensao .tif para .jpg 
    file = regexprep(file,'.tif','.jpg','ignorecase');
        
    fprintf('Pontos identificados: %d\n', size(nonzeros(pontosSementes)));
    fprintf('Pintando os pontos na imagem...\n');
        
    % Pinta os pontos na imagem
    % arg 1: Caminho da imagem
    % arg 2: Vetor contendo os indices dos padroes da imagem
    % arg 3: Dimensao da janela de leitura dos padroes
    % arg 4: Se a opcao igual a 0, o resultado nao e exibido com imagem no
    %        fundo. Caso contrario, sim
    % arg 5: Sequencia da figura a ser plotada
    % arg 6: Caminho caso seja necessario armazenar a imagem
    % arg 7: Espacamento da janela de leitura a cada iteracao da varredura
    % retorno: Quantidade de padroes por linha
    [pad_lin] = pintaPontosImagemEsp(file, pontosSementes, NumEntradas, 0, 2, pathResult, esp);
    
    fprintf('Obtendo os segmentos - (Prunning)...\n');
    
    % Poda dos pontos espurios na imagem
    % arg 1: Indices das amostras que foram marcadas [vetor]
    % arg 2: Quantidade de padroes por linha [escalar]
    % arg 3: Parametro de pertinencia para a continuidade dos pontos
    % arg 4: Parametro de pertinencia para a descontinuidade dos pontos 
    % retorno: Variavel pontosSementes filtrada [vetor]
    [pontosSementesPrunning] = segmenta_estradas(pontosSementes, pad_lin, 4, 1);
    
    % Pinta os pontos na imagem, com a poda ja realizada.
    % arg 1: Caminho da imagem [string]
    % arg 2: Pontos sementes filtrado [vetor]
    % arg 3: Dimensao da janela de leitura dos padroes [escalar]
    % arg 4: Se a opcao igual a 0, o resultado nao e exibido com imagem no
    %        fundo. Caso contrario, sim
    % arg 5: Sequencia da figura a ser plotada
    % arg 6: Caminho caso seja necessario armazenar a imagem [string]
    % arg 7: Tamanho do salto [escalar]
    % retorno: Matriz com a localizacao dos pixels referentes aos pontos
    %          marcados [matriz]
    [xypontosSementes] = pintaPontosImagemEsp_seg(file, pontosSementesPrunning, NumEntradas, 0, 3, pathResult, esp);
    
    % - SNAKES ------------------------------------------------------------

    % Aplica o metodo Snakes em cada um dos segmentos de reta 
    % arg 1: Matriz com a localizacao dos pixels referentes aos pontos
    %        marcados [matriz]
    % arg 2: Caminho da imagem [string]
    % arg 3: Sigma - Fator de suavizacao gaussiana [escalar]
    % arg 4: Alpha - Especifica a elasticidade da Snake [escalar]
    % arg 5: Beta - Especifica a rigidez do contorno [escalar]
    % arg 6: Gamma - Especifica o tamanho do passo [escalar]
    % arg 7: Kappa - Age como um fator de escala para o termo de energia
    % arg 8: wl - Fator de pesagem para intensidade baseada no termo de
    %        potencial [escalar]
    % arg 9: we - Fator de pesagem para borda baseada no termo de
    %         potencial [escalar]
    % arg 10: wt - Fator de pesagem para terminacao baseada no termo de
    %         potencial [escalar]
    % arg 11: Numero de iteracao em cada processo de minimizacao [escalar]
    snakes(xypontosSementes, file, 2.0, 0.05, 0, 1.00, 0.3, 0.3, 0.4, 0.7, 500, 0);
    
    % Fim do processo  
    fprintf('Processo Concluido em %0.2f minutos!\n', (toc(t3)/60));
    fprintf('-----------------\n');
            
end
