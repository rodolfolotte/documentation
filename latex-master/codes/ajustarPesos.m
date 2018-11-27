function [wk] = ajustarPesos(X,wk,viz,l,c,eta,NumSaidas,p)

    WidthSq = viz^2;

    %Inicia ajuste dos pesos do vencedor e dos vizinhos
    for i=1:NumSaidas
        for j=1:NumSaidas                
            % Distancia de cada no para o vencedor
            distNo = ((l-i)^2) + ((c-j)^2); 
            % Se estiver dentro da vizinhanca: ajusta pesos
            if distNo < WidthSq
               % Calculo de quanto o peso deve ser ajustado
               influen = exp(-((distNo)/(2*WidthSq)));
               for t=1:size(X,1)
                   wk(i,j,t) = wk(i,j,t) + eta * influen * (X(t,p) - wk(i,j,t));
               end                      
            end           
        end % Fim do ajuste os pesos do vencedor e dos vizinhos       
    end

    return       

end

