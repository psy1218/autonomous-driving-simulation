function [taget] = getTarget(pos)
    x = pos(1);
    y = pos(2);

    global x_ref1 y_ref1 Ld0 
    [~, i_near] = min((x_ref1-x).^2 + (y_ref1-y).^2);

    Ld = Ld0;
    
    ds = 0.35;
    i_t = i_near + ceil(Ld0/ds);
    
    if i_t>length(x_ref1)
        i_t = mod(i_t, length(x_ref1));
    end
    
    xt = x_ref1(i_t); yt = y_ref1(i_t);
    taget = [xt;yt];
end