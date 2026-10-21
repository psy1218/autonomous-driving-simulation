function [taget] =getTarget(x, y)

    global x_ref y_ref Ld0 s
    
    % 1) 경로에서 가장 가까운 점
    [~, i_near] = min((x_ref-x).^2 + (y_ref-y).^2);
    
    % 2) 호길이 기준 look-ahead 타깃 선택 (경로를 "앞"으로 고정)
    % Ld = max(Ld0, 0.5*v);                % (옵션) 속도 비례 가변 Ld
    Ld = Ld0;
    s_target = s(i_near) + Ld;
    i_t = find(s >= s_target, 1, 'first');
    if isempty(i_t)
        i_t = numel(s); 
    end
    xt = x_ref(i_t); yt = y_ref(i_t);
    taget = [xt;yt];
end