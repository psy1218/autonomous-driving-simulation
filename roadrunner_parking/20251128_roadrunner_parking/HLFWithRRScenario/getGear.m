function [gear] = getGear()
    global presentLane

    if presentLane == 1
        gear = 1;
    elseif presentLane == 2
        gear = -1;
    end
end