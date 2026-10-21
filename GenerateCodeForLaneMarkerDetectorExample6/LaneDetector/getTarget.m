function [taget] = getTarget(x, y)
    global x_ref y_ref Ld0 s
    [~, i_near] = min((x_ref-x).^2 + (y_ref-y).^2);

    Ld = Ld0;
    s_target = s(i_near) + Ld;
    i_t = find(s >= s_target, 1, 'first');
    if isempty(i_t)
        i_t = numel(s);
    end
    xt = x_ref(i_t); yt = y_ref(i_t);
    taget = [xt;yt];
end