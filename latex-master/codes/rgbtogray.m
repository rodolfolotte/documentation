function [IGray] = rgbtogray(File, I)
      
    [lin,col] = size(File);
    verExt = strfind(File,'.jpg');
    [lin2,col2] = size(verExt);

    if col2 ~= 0
        if (col-3) == verExt(col2)
            IGray = rgb2gray(I);
        end
    end  
      
    return

end

