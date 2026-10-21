function [taget] = getTarget(pos)
    x = pos(1);
    y = pos(2);

    global x_ref1 y_ref1 Ld x_ref2 y_ref2 presentLane checkPoint
    
    if norm(checkPoint(1:2)-pos(1:2)) < 1
        presentLane = 2;
    elseif norm([-14;-15]-pos(1:2)) < 1
        presentLane = 1;
    end



    if presentLane == 1
        X = x_ref1;
        Y = y_ref1;
        Ld0 = Ld(1);
    elseif presentLane == 2
        X = x_ref2;
        Y = y_ref2;
        Ld0 = Ld(2);
    end
    

    [~, i_near] = min((X-x).^2 + (Y-y).^2);
    
    
    ds = 0.35;
    i_t = i_near + ceil(Ld0/ds);
    
    if i_t>length(X)
        i_t = mod(i_t, length(Y));
    end
    
    xt = X(i_t); yt = Y(i_t);
    taget = [xt;yt];

    % if presentLane ==2
    % plot(x,y,'ro')
    % hold on
    % plot(xt,yt,'bo')
    % pause(0.01)
    % end
end