function [coord] = bresenham(x1, y1, x2, y2)

    slope = 0;
    dx = 0;
    dy = 0;
    incE = 0;
    incNE = 0;
    d = 0;
    x = 0;
    y = 0;
    coord = zeros((y2-y1)+1,2);

    % Onde inverte a linha x1 > x2
    if (x1 > x2)
        bresenham(x2, y2, x1, y1);
        return;
    end

    dx = x2 - x1;
    dy = y2 - y1;

    if (dy < 0)
        slope = -1;
        dy = -dy;
    else
        slope = 1;
    end

    % Constante de Bresenham
    incE = 2 * dy;
    incNE = 2 * dy - 2 * dx;
    d = 2 * dy - dx;
    y = y1;
    cont = 1;

    for x=x1:x2
        coord(cont,1) = x;
        coord(cont,2) = y;
        cont = cont + 1;
        if(d <= 0)
            d = d + incE;
        else
            d = d + incNE;
            y = y + slope;
        end

    end

end

