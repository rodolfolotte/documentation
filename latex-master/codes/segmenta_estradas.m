function [segmentosFinais] = segmenta_estradas(estr,pad_lin,con,desc)

    qtd_segmentos = 1;
    estradasH = zeros(size(estr,2));
    ponto = 1;
    flag = 0;

    % Limiares de continuidades e descontinuidades, respectivamente
    continuo = con;
    descontinuo = desc;
    v_continuo = 1;

    % Controla os pontos de cada segmento
    cont = 1;

    % Separa somente os segmentos HORIZONTAIS
    while flag == 0
        if ((estr(cont+1)-estr(cont)) > descontinuo) && (v_continuo >= continuo)
            estradasH(qtd_segmentos,ponto) = estr(cont);
            v_continuo = 1;
            qtd_segmentos = qtd_segmentos + 1;
            ponto = 1;
            cont = cont + 1;
        elseif ((estr(cont+1)-estr(cont)) > descontinuo) && (v_continuo < continuo)
            estradasH(qtd_segmentos,:) = 0;
            ponto = 1;
            v_continuo = 1;
            cont = cont + 1;
        elseif (mod(estr(cont)/pad_lin,1) == 0) && (v_continuo >= continuo)
            estradasH(qtd_segmentos,ponto) = estr(cont);
            v_continuo = 1;
            qtd_segmentos = qtd_segmentos + 1;
            ponto = 1;
            cont = cont + 1;
        elseif mod(estr(cont)/pad_lin,1) == 0
            estradasH(qtd_segmentos,:) = 0;
            v_continuo = 1;
            ponto = 1;
            cont = cont + 1;
        else
            estradasH(qtd_segmentos,ponto) = estr(cont);
            ponto = ponto + 1;
            v_continuo = v_continuo + 1;
            cont = cont + 1;
        end

        if cont == size(estr,2)
            if (v_continuo >= continuo)
                estradasH(qtd_segmentos,ponto) = estr(cont);
            end
            qtd_segmentos = qtd_segmentos + 1;
            flag = 1;
        end
    end

    flag = 0;
    ponto = 1;
    v_continuo = 1;
    cont = 1;

    % Reordena padroes na variavel estradas
    % estradas = [13 20 23 30 33 37 40 43 47 50 53 55 60 65 75 85 87 93];
    % estradas = [13 23 33 43 53 93 20 30 40 50 60 37 47 87 55 65 75 85];
    estradas = 0;
    estradas = ordena(estr,pad_lin,1);

    % Separa somente os segmentos VERTICAIS
    while flag == 0
        if (estradas(cont+1) < estradas(cont)) || ((estradas(cont+1) - estradas(cont)) < pad_lin)
            estradasH(qtd_segmentos,ponto) = estradas(cont);
            if (v_continuo >= continuo)
                qtd_segmentos = qtd_segmentos + 1;
            else
                estradasH(qtd_segmentos,:) = 0;
            end
            v_continuo = 1;
            ponto = 1;
            cont = cont + 1;
        elseif ((((estradas(cont+1) - estradas(cont)) - pad_lin)/pad_lin) > descontinuo) && (v_continuo >= continuo)
            estradasH(qtd_segmentos,ponto) = estradas(cont);
            v_continuo = 1;
            qtd_segmentos = qtd_segmentos + 1;
            ponto = 1;
            cont = cont + 1;
        elseif ((((estradas(cont+1) - estradas(cont)) - pad_lin)/pad_lin) > descontinuo) && (v_continuo < continuo)
            estradasH(qtd_segmentos,:) = 0;
            ponto = 1;
            v_continuo = 1;
            cont = cont + 1;
        elseif (mod(estradas(cont)/pad_lin,pad_lin) > (pad_lin - 1)) && (v_continuo >= continuo)
            estradasH(qtd_segmentos,ponto) = estradas(cont);
            v_continuo = 1;
            qtd_segmentos = qtd_segmentos + 1;
            ponto = 1;
            cont = cont + 1;
        elseif mod(estradas(cont)/pad_lin, pad_lin) > (pad_lin - 1)
            estradasH(qtd_segmentos,:) = 0;
            v_continuo = 1;
            ponto = 1;
            cont = cont + 1;
        else
            estradasH(qtd_segmentos,ponto) = estradas(cont);
            ponto = ponto + 1;
            v_continuo = v_continuo + 1;
            cont = cont + 1;
        end

        if cont == size(estradas,2)
            if (v_continuo >= continuo) && (estradas(cont) < estradas(cont-1)) || ((estradas(cont) - estradas(cont-1)) < pad_lin)
                estradasH(qtd_segmentos,ponto) = estradas(cont);
            end
            qtd_segmentos = qtd_segmentos + 1;
            flag = 1;
        end
    end

     ponto = 1;
     flag = 0;
     v_continuo = 1;
     cont = 1;
 
     % Reordena padroes na variavel estradas
     estradas = 0;
     estradas = ordena(estr,pad_lin,2);

     % Separa somente os segmentos DIAGONAIS -45
     while flag == 0
         if (estradas(cont+1) < estradas(cont)) || ((estradas(cont+1) - estradas(cont)) < pad_lin+1)
             estradasH(qtd_segmentos,ponto) = estradas(cont);
             if (v_continuo >= continuo)
                 qtd_segmentos = qtd_segmentos + 1;
             else
                 estradasH(qtd_segmentos,:) = 0;
             end
             v_continuo = 1;
             ponto = 1;
             cont = cont + 1;
         elseif ((((estradas(cont+1) - estradas(cont)) - (pad_lin+1))/(pad_lin+1)) > descontinuo) && (v_continuo >= continuo)
             estradasH(qtd_segmentos,ponto) = estradas(cont);
             v_continuo = 1;
             qtd_segmentos = qtd_segmentos + 1;
             ponto = 1;
             cont = cont + 1;
         elseif ((((estradas(cont+1) - estradas(cont)) - (pad_lin+1))/(pad_lin+1)) > descontinuo) && (v_continuo < continuo)
             estradasH(qtd_segmentos,:) = 0;
             ponto = 1;
             v_continuo = 1;
             cont = cont + 1;
         elseif (mod(estradas(cont)/pad_lin,pad_lin) > (pad_lin - 1)) && (v_continuo >= continuo)
             estradasH(qtd_segmentos,ponto) = estradas(cont);
             v_continuo = 1;
             qtd_segmentos = qtd_segmentos + 1;
             ponto = 1;
             cont = cont + 1;
         elseif mod(estradas(cont)/pad_lin, pad_lin) > (pad_lin - 1)
             estradasH(qtd_segmentos,:) = 0;
             v_continuo = 1;
             ponto = 1;
             cont = cont + 1;
         else
             estradasH(qtd_segmentos,ponto) = estradas(cont);
             ponto = ponto + 1;
             v_continuo = v_continuo + 1;
             cont = cont + 1;
         end
 
         if cont == size(estradas,2)
             if (v_continuo >= continuo) && ((estradas(cont) < estradas(cont-1)) || ((estradas(cont) - estradas(cont-1)) < pad_lin+1))
                 estradasH(qtd_segmentos,ponto) = estradas(cont);
             end
             qtd_segmentos = qtd_segmentos + 1;
             flag = 1;
         end
     end
 
     ponto = 1;
     flag = 0;
     v_continuo = 1;
     cont = 1;
 
     % Reordena padroes na variavel estradas
     estradas = 0;
     estradas = ordena(estr,pad_lin,3);
 
     % Separa somente os segmentos DIAGONAIS 45
     while flag == 0
         if (estradas(cont+1) < estradas(cont)) || ((estradas(cont+1) - estradas(cont)) < pad_lin-1)
             estradasH(qtd_segmentos,ponto) = estradas(cont);
             if (v_continuo >= continuo)
                 qtd_segmentos = qtd_segmentos + 1;
             else
                 estradasH(qtd_segmentos,:) = 0;
             end
             v_continuo = 1;
             ponto = 1;
             cont = cont + 1;
         elseif ((((estradas(cont+1) - estradas(cont)) - (pad_lin-1))/(pad_lin-1)) > descontinuo) && (v_continuo >= continuo)
             estradasH(qtd_segmentos,ponto) = estradas(cont);
             v_continuo = 1;
             qtd_segmentos = qtd_segmentos + 1;
             ponto = 1;
             cont = cont + 1;
         elseif ((((estradas(cont+1) - estradas(cont)) - (pad_lin-1))/(pad_lin-1)) > descontinuo) && (v_continuo < continuo)
             estradasH(qtd_segmentos,:) = 0;
             ponto = 1;
             v_continuo = 1;
             cont = cont + 1;
         elseif (mod(estradas(cont)/pad_lin,pad_lin) > (pad_lin - 1)) && (v_continuo >= continuo)
             estradasH(qtd_segmentos,ponto) = estradas(cont);
             v_continuo = 1;
             qtd_segmentos = qtd_segmentos + 1;
             ponto = 1;
             cont = cont + 1;
         elseif mod(estradas(cont)/pad_lin, pad_lin) > (pad_lin - 1)
             estradasH(qtd_segmentos,:) = 0;
             v_continuo = 1;
             ponto = 1;
             cont = cont + 1;
         else
             estradasH(qtd_segmentos,ponto) = estradas(cont);
             ponto = ponto + 1;
             v_continuo = v_continuo + 1;
             cont = cont + 1;
         end
 
         if cont == size(estradas,2)
             if (v_continuo >= continuo) && ((estradas(cont) < estradas(cont-1)) || ((estradas(cont) - estradas(cont-1)) < pad_lin-1))
                 estradasH(qtd_segmentos,ponto) = estradas(cont);
             end
             flag = 1;
         end
     end

    counterLine = 1;
    segmentosFinais = zeros(size(nonzeros(estradasH(:,1)),1),size(estradasH,2));

    for i=1:size(estradasH,1)
        if (size(nonzeros(estradasH(i,:)),1) >= 1)
            for j=1:size(estradasH,2)
                segmentosFinais(counterLine,j) = estradasH(i,j);
            end
            counterLine = counterLine + 1;
        else
            continue;
        end
    end

    return

end
