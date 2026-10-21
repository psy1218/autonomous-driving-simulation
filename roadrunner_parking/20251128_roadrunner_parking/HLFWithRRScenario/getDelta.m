function [delta] = getDelta(x,y,yaw,xt,yt)


    global L Ld presentLane
    if presentLane == 1
        gain = 1;
        Lu = L(1);
        Ld0 = Ld(1);
    elseif presentLane == 2
        yaw = yaw + pi;
        gain = -1;
        Lu = L(2);
        Ld0 = Ld(2);
    end
    alpha = atan2(yt - y, xt - x) - yaw;
    alpha = atan2(sin(alpha), cos(alpha));           % [-pi, pi] 래핑
    delta = gain*atan2(2*Lu*sin(alpha), Ld0);

end