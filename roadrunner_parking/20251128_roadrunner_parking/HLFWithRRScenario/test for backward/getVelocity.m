function [velocities] = getVelocity(u)
% u: pos of all vehicles

posOfAllVehicles = [u(1:2)';
                    u(4:5)';
                    u(7:8)';
                    u(10:11)';
                    u(13:14)'];

velocities = zeros(5,1);



global pastVelOfAllVehicles beta pastPosOfAllVehicles Ts

velOfAllVehicles = (1-beta)*pastVelOfAllVehicles + beta*(posOfAllVehicles-pastPosOfAllVehicles)/Ts;


for i=1:5
    velocities(i) = sqrt(velOfAllVehicles(i,1)^2 + velOfAllVehicles(i,2)^2);
end

pastVelOfAllVehicles = velOfAllVehicles;
pastPosOfAllVehicles = posOfAllVehicles;

end