function [revisedVelocity] = genVel(sterring, v_ref)
    


    if sterring >= 1 || sterring < -1
        revisedVelocity = v_ref*0.3;
    elseif sterring < 1 && sterring >= 0
        revisedVelocity = -0.7*v_ref*sterring + v_ref;
    elseif sterring < 0 && sterring >= -1
        revisedVelocity = 0.7*v_ref*sterring + v_ref;
    end
    
    % revisedVelocity = ??
end