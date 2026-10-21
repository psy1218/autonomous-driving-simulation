function [vel] = getRefVel()
global presentLane v_ref
    if presentLane == 1
        vel = v_ref(1);
    elseif presentLane == 2
        vel = v_ref(2);
    end
end