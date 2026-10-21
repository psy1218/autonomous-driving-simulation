function [delta] = getDelta(x,y,yaw,xt,yt)


    global L Ld0 presentLane
    gain = 1;
    Lu = L(1);

    if presentLane == 2
        yaw = yaw + pi;
        gain = -1;
        Lu = L(2);
    end
    alpha = atan2(yt - y, xt - x) - yaw;
    alpha = atan2(sin(alpha), cos(alpha));           % [-pi, pi] 래핑
    delta = gain*atan2(2*Lu*sin(alpha), Ld0); 

    
    plot(x,y,'ro')
    hold on
    plot(xt,yt,'bo')
    pause(0.05)
end