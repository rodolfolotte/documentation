function [xTrain xTrain_norm] = carregaPadroes(loadFile)

    if(loadFile == 0)        
        xTrain(:,1) = [158 125 87 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 158 166 184]; 
        xTrain(:,2) = [186 163 168 191 199 186 176 204 1 1 1 184 212 204 201 194 204 212 201 212 207];
        xTrain(:,3) = [158 125 87 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 158 166 184];
        xTrain(:,4) = [186 163 168 191 199 186 176 204 255 255 255 184 212 204 201 194 204 212 201 212 207];      
        xTrain(:,5) = [186 186 199 173 176 168 171 207 196 201 181 186 176 194 196 189 201 186 209 196 186];
        xTrain(:,6) = [245 247 237 250 255 245 237 230 235 247 237 232 232 240 250 247 245 250 242 250 237];
        xTrain(:,7) = [255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255];
        xTrain(:,8) = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
              
        % Normalizado Dados de Treinamento
        xTrain_norm = xTrain/norm(xTrain);        
    else
        fprintf('Carregando xTrain...\n');
        load 'xTrain.mat'
        load 'xTrain_norm.mat'
    end
    
    return     
end

