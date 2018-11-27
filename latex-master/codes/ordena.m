function [estradasY] = ordena(estradas,pad_lin,opcao)

    estradasY = zeros(size(estradas));
    pivo = 1;
    contad = 2;
    flag = 0;
    estradasY(1) = estradas(1);
    
    switch(opcao)
        case 1 % VERTICAL
            while flag == 0
                for i=pivo+1:size(estradas,2)
                    vf = mod(estradas(pivo)/pad_lin,1);
                    vr = mod(estradas(i)/pad_lin,1);
                    if (vf-vr)^2 < (1*10^(-5))
                        estradasY(contad) = estradas(i);
                        contad = contad + 1;
                    end    
                end

                pivo = pivo + 1;
                flag2 = 0;

                % Obtem o proximo pivo
                % Neste caso os pivos devem ser: 13, 20, 37 e 55;
                while flag2 == 0
                    possui_num = 0;
                    for l=1:contad-1
                        v1 = mod(estradas(pivo)/pad_lin,1);
                        v2 = mod(estradasY(l)/pad_lin,1);
                            if (v1-v2)^2 < (1*10^(-5))
                                possui_num = 1;                        
                                break;
                            end
                    end
                    if possui_num == 1 && pivo < size(estradas,2)
                       pivo = pivo + 1;
                    else
                       flag2 = 1;                  
                    end
                end

                if contad == size(estradas,2) || pivo == size(estradas,2)            
                    estradasY(contad) = estradas(pivo);
                    flag = 1;
                else
                   estradasY(contad) = estradas(pivo);
                   contad = contad + 1;                    
                end
            end
        case 2 % DIAGONAL (-45 - DECAIMENTO DA ESQUERDA PARA DIREITA)
               % pad_lin = 18
               % [3 13 17 23 29 39 43 49 51 53 59 63 65 79]
               % [3 13 23 43 53 63 17 29 39 49 59 79 51 65]
            while flag == 0
                for i=pivo+1:size(estradas,2)
                    Q_var = ceil(estradas(i)/pad_lin);       
                    Q_var = Q_var - (ceil(estradas(pivo)/pad_lin));
                    vf = mod(estradas(pivo)/pad_lin,1);
                    vr = mod((estradas(i) - Q_var)/pad_lin,1);
                    if (vf-vr)^2 < (1*10^(-5))
                        estradasY(contad) = estradas(i);
                        contad = contad + 1;
                    end    
                end
                
                pivo = pivo + 1;
                flag2 = 0;

                % Obtem o proximo pivo
                % Neste caso os pivos devem ser: 3, 17, 29, 51 e 65;
                while flag2 == 0
                    possui_num = 0;
                    for l=1:contad-1
                        Q_var2 = ceil(estradasY(l)/pad_lin);                          
                        Q_var2 = Q_var2 - (ceil(estradas(pivo)/pad_lin)); 
                        v1 = mod(estradas(pivo)/pad_lin,1);
                        v2 = mod((estradasY(l) - Q_var2)/pad_lin,1);                        
                            if (v1-v2)^2 < (1*10^(-5))
                                possui_num = 1;                        
                                break;
                            end
                    end
                    if possui_num == 1 && pivo < size(estradas,2)
                       pivo = pivo + 1;
                    else
                       flag2 = 1;                  
                    end
                end

                if contad == size(estradas,2) || pivo == size(estradas,2)         
                    flag = 1;
                else
                   estradasY(contad) = estradas(pivo);
                   contad = contad + 1;                    
                end
            end
        case 3 % DIAGONAL (45 - DECAIMENTO DA DIREITA PARA ESQUERDA)
               % pad_lin = 18
               % [49 97 141 158 162 175 192 196 209 213 226 230 256 260];
               % [49 97 141 158 175 192 209 226 260 162 196 213 230 256];
            while flag == 0
                for i=pivo+1:size(estradas,2)
                    Q_var = ceil(estradas(i)/pad_lin);       
                    Q_var = Q_var - (ceil(estradas(pivo)/pad_lin));
                    vf = mod(estradas(pivo)/pad_lin,1);
                    vr = mod((estradas(i) + Q_var)/pad_lin,1);
                    if (vf-vr)^2 < (1*10^(-5))
                        estradasY(contad) = estradas(i);
                        contad = contad + 1;
                    end    
                end
                
                pivo = pivo + 1;
                flag2 = 0;

                % Obtem o proximo pivo
                % Neste caso os pivos devem ser: 3, 17, 29, 51 e 65;
                while flag2 == 0
                    possui_num = 0;
                    for l=1:contad-1
                        Q_var2 = ceil(estradasY(l)/pad_lin);                          
                        Q_var2 = Q_var2 - (ceil(estradas(pivo)/pad_lin)); 
                        v1 = mod(estradas(pivo)/pad_lin,1);
                        v2 = mod((estradasY(l) + Q_var2)/pad_lin,1);                        
                            if (v1-v2)^2 < (1*10^(-5))
                                possui_num = 1;                        
                                break;
                            end
                    end
                    if possui_num == 1 && pivo < size(estradas,2)
                       pivo = pivo + 1;
                    else
                       flag2 = 1;                  
                    end
                end

                if contad == size(estradas,2) || pivo == size(estradas,2)
                    estradasY(contad) = estradas(pivo);
                    flag = 1;
                else
                   estradasY(contad) = estradas(pivo);
                   contad = contad + 1;                    
                end
            end
        otherwise fprintf('Opcao de ordenacao invalida!\n');
    end
    
    return

end

