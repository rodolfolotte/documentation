function [countSegm finalSnakeX finalSnakeY row col] = snakes(indice, file, sigma, alpha, beta, gamma, kappa, wl, max_iter, param)

    initialSnakeX = zeros(size(indice,1),150);
    initialSnakeY = zeros(size(indice,1),150);
    
    % Interpola os pontos
    for i=1:size(indice,1)
              
        if(size(nonzeros(indice(i,:,1)),1) <= 3) 
            indice(i,:,1) = 0;
            indice(i,:,2) = 0;
            continue;
        end
       
        n = size(nonzeros(indice(i,:,1))',2);
        indices = [nonzeros(indice(i,:,1))';nonzeros(indice(i,:,2))'];
        
        points = 1:n; pointsInterp = 1:0.3:n;
        cordXY = spline(points,indices,pointsInterp);
        
        initialSnakeX(i,1:size(cordXY,2)) = cordXY(2,:);
        initialSnakeY(i,1:size(cordXY,2)) = cordXY(1,:);
        
    end
    
    countSegm = size(initialSnakeX,1);
    finalSnakeX = zeros(size(initialSnakeX,1),size(initialSnakeX,2));
    finalSnakeY = zeros(size(initialSnakeY,1),size(initialSnakeY,2));
        
    im = imread(file);

    % se tiver 3 bandas, converte para tons de cinza
    if (size(im,3) == 3)
        im = rgb2gray(im);
    end

    im = double(im);
    [row col] = size(im);
    
    smask = fspecial('gaussian', ceil(3*sigma), sigma);
    im_smth = filter2(smask, im, 'same');

    % Obtem a energia da linha, que e a propria imagem
    e_line = im_smth;
  
    % A energia externa e entao calculada, sendo esta a soma das energias
    e_ext = -wl * e_line;

    % Obtem o gradiente da enerngia externa
    [Fx, Fy] = gradient(e_ext);   
    
    h = figure(6);
    
    if(param == 1)
        im = ones(row,col);
        im = im*255; % Fundo branco
    end
    
    imshow(im,[]);
    hold on
    
    % Aplica o processo para cada segmento da estrada
    for i=1:size(initialSnakeX,1)
        % Se nao tiver pontos suficientes, analisa proximo segmento de reta        
        if(size(nonzeros(initialSnakeX(i,:)),1) <= 4)    
            countSegm = countSegm - 1;
            continue;
        end  
        
        cordX_temp = nonzeros(initialSnakeX(i,:));
        cordY_temp = nonzeros(initialSnakeY(i,:));

        pointsOnCurve = size(cordX_temp,1);
               
        alphaVt = alpha*ones(1,pointsOnCurve);
        betaVt = beta*ones(1,pointsOnCurve);
        
        % Produz a matriz pentadiagonal
        alphap1 = [alphaVt(pointsOnCurve) alphaVt(1:pointsOnCurve-1)];
        betam1 = [betaVt(2:pointsOnCurve) betaVt(1)];
        betap1 = [betaVt(pointsOnCurve) betaVt(1:pointsOnCurve-1)];
        
        a = betam1;
        b = -alphaVt - 2*betaVt - 2*betam1;
        c = alphaVt + alphap1 + betam1 + 4*betaVt + betap1;
        d = -alphap1 - 2*betaVt - 2*betap1;
        e = betap1;
        
        % Gera os parametros da matriz
        A = diag(a(1:pointsOnCurve-2),-2) + diag(a(pointsOnCurve-1:pointsOnCurve),pointsOnCurve-2);
        A = A + diag(b(1:pointsOnCurve-1),-1) + diag(b(pointsOnCurve), pointsOnCurve-1);
        A = A + diag(c);
        A = A + diag(d(1:pointsOnCurve-1),1) + diag(d(pointsOnCurve),-(pointsOnCurve-1));
        A = A + diag(e(1:pointsOnCurve-2),2) + diag(e(pointsOnCurve-1:pointsOnCurve),-(pointsOnCurve-2));
        
        A_inv = inv(A + gamma * diag(ones(1,pointsOnCurve)));

        ssx = zeros(pointsOnCurve,1);
        ssy = zeros(pointsOnCurve,1);

        motionX(1) = cordX_temp(1); ssx(pointsOnCurve) = cordX_temp(pointsOnCurve);
        motionY(1) = cordY_temp(1); ssy(pointsOnCurve) = cordY_temp(pointsOnCurve);
                
        % A cada iteracao, obtem uma nova posicao para a curva
        for v=1:max_iter
            
            motionX(2:pointsOnCurve-1) = gamma * cordX_temp(2:pointsOnCurve-1) - (kappa * interp2(fx,cordX_temp(2:pointsOnCurve-1),cordY_temp(2:pointsOnCurve-1)));
            motionY(2:pointsOnCurve-1) = gamma * cordY_temp(2:pointsOnCurve-1) - (kappa * interp2(fy,cordX_temp(2:pointsOnCurve-1),cordY_temp(2:pointsOnCurve-1)));
            
            % Calcula a nova posicao da snake
            cordX_temp = A_inv * motionX;
            cordY_temp = A_inv * motionY;            

        end

        finalSnakeX(i,2:size(cordX_temp,1)-1) = cordX_temp(2:pointsOnCurve-1)';
        finalSnakeY(i,2:size(cordY_temp,1)-1) = cordY_temp(2:pointsOnCurve-1)';
     
        plot(nonzeros(finalSnakeX(i,:))', nonzeros(finalSnakeY(i,:))', '-r', 'LineWidth', 2);
           
    end
    
    im = ones(row,col);
    im = im*255; % Fundo branco
    
    h = figure(7);
    imshow(im,[]);
    hold on
    for j=1:size(finalSnakeX,1)
        plot(nonzeros(finalSnakeX(j,:))', nonzeros(finalSnakeY(j,:))', '-r', 'LineWidth', 2);
    end
    
    return    
end 
