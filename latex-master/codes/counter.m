function [lengthReference lengthExtracted lengthReferenceMatched lengthExtractedMatched] = counter(ref, result, finalSnakeX, finalSnakeY, row, col, largPred)

    lengthReference = 0;
    lengthExtracted = 0;
    lengthReferenceMatched = 0;
    lengthExtractedMatched = 0;

    im = ones(row, col)*255;
    file = 'C:\counterTemp.jpg';

    for i=1:size(ref,1)
        for j=1:size(ref,2)
            if (ref(i,j) == 1)
                lengthReference = lengthReference + 1;
            end
            if ((ref(i,j) == 1) && (result(i,j) == 1))
                lengthReferenceMatched = lengthReferenceMatched + 1;
            end
        end
    end

    for i=1:size(nonzeros(finalSnakeX(:,2)), 1)
        imshow(im,[]);
        [r c] = size(im);
        set(gca,'Units','normalized','Position',[0 0 1 1]);
        set(gcf,'Units','pixels','Position',[200 200 c r]);
        hold on
        plot(nonzeros(finalSnakeX(i,:))', nonzeros(finalSnakeY(i,:))', '-r', 'LineWidth', 1);

        h = getframe(gcf);
        imwrite(h.cdata, file);

        tpItem = imread(file);
        imagem = limiariza(tpItem);
        imagem = dilata(largPred, imagem);

        for lin=1:row
            for col=1:col
                if (imagem(lin,col) == 1)
                    lengthExtracted = lengthExtracted + 1;
                end
                if ((imagem(lin,col) == 1) && (ref(lin,col) == 1))
                    lengthExtractedMatched = lengthExtractedMatched + 1;
                end
            end
        end
        im = ones(row,col)*255;
    end

    return
    
end


