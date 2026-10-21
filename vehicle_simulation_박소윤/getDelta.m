function [delta] = getDelta(x, y ,yaw, xt, yt)
    global L Ld0
    
    % 3) 헤딩 오차(alpha)와 조향각(delta)
    alpha = atan2(yt - y, xt - x) - yaw;
    alpha = atan2(sin(alpha), cos(alpha));           % [-pi, pi] 래핑
    delta = atan2(2*L*sin(alpha), Ld0);               % 수치적으로 안전한 atan2

end