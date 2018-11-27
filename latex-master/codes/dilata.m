function [result] = dilata(largPred, result)
    dilatacao = floor(largPred/2);
    se = strel('ball',dilatacao,0);
    result = imdilate(result,se);    
    
    return    
end
