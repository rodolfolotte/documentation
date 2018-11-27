function [cpt,cor,qlt,rdn,unf] = evaluation(finalSnakeX, finalSnakeY, row, col, largPred)

    % Completeness => cpt
    % Correctness => cor
    % Quality => qlt
    % Redundancy => rdn
    % Unification => sqrt((cpt-1)^2 + (cor-1)^2 + (qlt-1)^2 + (rdn-0)^0)
    % --------------------------------------------------------------------
    cpt = 0; cor = 0; qlt = 0; rdn = 0; unf = 0;

    [filename, pathname] = uigetfile({'*.jpg'},'Selecione uma imagem de referencia');
    file = strcat(pathname,filename);
    reference = imread(file);

    [filename, pathname] = uigetfile({'*.jpg'},'Selecione o resultado adquirido');
    file = strcat(pathname,filename);
    result = imread(file);

    ref = limiariza(reference);
    result = limiariza(result);
    result = dilata(largPred, result);

    if((size(ref,1) ~= row) || (size(ref,2) ~= col)) || (size(ref,1) ~= size(result,1)) || (size(ref,2) ~= size(result,2))
        fprintf('Dimensoes das imagens selicionadas estao incoerentes. Verifique!!\n');
        return
    else
        [lengthReference lengthExtracted lengthReferenceMatched lengthExtractedMatched] = counter(ref, result, finalSnakeX, finalSnakeY, row, col, largPred);
              
        cpt = lengthReferenceMatched/lengthReference;
        cor = lengthExtractedMatched/lengthExtracted;
        qlt = lengthExtractedMatched/(lengthExtracted + (lengthReference - lengthReferenceMatched));
        rdn = (lengthExtractedMatched - lengthReferenceMatched)/lengthExtractedMatched;                
        unf = sqrt(((cpt-1)^2) + ((cor-1)^2) + ((qlt-1)^2) + (rdn^2));        
    end
    
    return

end
