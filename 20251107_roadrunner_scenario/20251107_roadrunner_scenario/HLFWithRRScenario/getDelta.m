function [delta] = getDelta(x,y,yaw,xt,yt)


    global L Ld0
    alpha = atan2(yt - y, xt - x) - yaw;
    alpha = atan2(sin(alpha), cos(alpha));           % [-pi, pi] 래핑
    delta = atan2(2*L*sin(alpha), Ld0); 
end