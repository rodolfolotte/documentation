function [ind] = localizaCluster(xTrain_norm, wk_norm, NumSaidas, w_norma)

    NumPadroes = size(xTrain_norm,2);

    for p=1:NumPadroes

        d = zeros(NumSaidas);
        
        for x=1:NumSaidas
            for y=1:NumSaidas
                a = wk_norm(x,y,:);
                b = xTrain_norm(:,p);
                d(x,y) = sum((a(:) - b(:)).^2);
            end
        end

        % Encontrar o vencedor
        [vec_l vec_c] = find(d == min(min(d)));
        l = vec_l(1);
        c = vec_c(1);
        
        ind(p,1) = l;
        ind(p,2) = c;        

    end

    return

end

