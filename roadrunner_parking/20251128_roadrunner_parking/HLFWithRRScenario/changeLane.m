function changedLane = changeLane(u)


ds = 0.35;
safeDist = 20;

poseOfEgo = [u(1:3); u(16)];
poseOfExtra{2} = [u(4:6); u(17)];
poseOfExtra{3} = [u(7:9); u(18)];
poseOfExtra{4} = [u(10:12); u(19)];
poseOfExtra{5} = [u(13:15); u(20)];

for i=2:5
    lane{i} = 0;
    idx{i} = 0;
    distFromEgo{i} = 0;
end


global x_ref1 y_ref1 x_ref2 y_ref2 presentLane count Ts

if count < 1/Ts
    count = count + 1;
else

    for i=2:5
        [dist1,idx1] = min((x_ref1-poseOfExtra{i}(1)).^2 + (y_ref1-poseOfExtra{i}(2)).^2);
        [dist2,idx2] = min((x_ref2-poseOfExtra{i}(1)).^2 + (y_ref2-poseOfExtra{i}(2)).^2);

        if dist1<=dist2
            lane{i} = 1;
            idx{i} = idx1;
        else
            lane{i} = 2;
            idx{i} = idx2;
        end
        distFromEgo{i} = sqrt( (poseOfEgo(1)-poseOfExtra{i}(1))^2 + (poseOfEgo(2)-poseOfExtra{i}(2))^2 );

        rel_dist = [poseOfExtra{i}(1:2)-poseOfEgo(1:2)];

        if lane{i}== presentLane && sum(rel_dist.*[cos(poseOfEgo(3));sin(poseOfEgo(3))])<=0;
            status = 1;
        elseif lane{i}== presentLane && sum(rel_dist.*[cos(poseOfEgo(3));sin(poseOfEgo(3))])>0;
            status = 2;
        else
            status = 0;
        end
        


        if lane{i} == presentLane && distFromEgo{i}<safeDist && ...
                ((status == 1 && poseOfEgo(4)<poseOfExtra{i}(4)) || ...
                (status == 2 && poseOfEgo(4) >= poseOfExtra{i}(4)))
            % if lane{i} == presentLane && distFromEgo{i}<safeDist
            presentLane = 3-presentLane;
            count = 0;
            break;
        end
    end


end


changedLane = presentLane;


% function [output] = changeLane(pos)
% global count
%
% output = 0;
%
% safeDistance = 20;
%
% posOfEgoVehicle = pos(1:3);
%
% % posOfExtraVehicle2 = pos(4:6);
% % posOfExtraVehicle3 = pos(7:9);
% % posOfExtraVehicle4 = pos(10:12);
% % posOfExtraVehicle5 = pos(13:15);
%
% for i=2:5
%     posOfExtraVehicle{i} = pos((3*i-2):(3*i));
% end
%
% global presentLane x_ref1 y_ref1 x_ref2 y_ref2 Ts
%
%
%
%
% if count < 2/Ts
%     count = count + 1;
% else
%     for i=2:5
%         %% detect lane of extra vehicles
%         dist1 = min( (x_ref1-posOfExtraVehicle{i}(1)).^2 + (y_ref1-posOfExtraVehicle{i}(2)).^2 );
%         dist2 = min( (x_ref2-posOfExtraVehicle{i}(1)).^2 + (y_ref2-posOfExtraVehicle{i}(2)).^2 );
%
%         if dist1 <= dist2
%             presentLaneExtra{i} = 1;
%         elseif dist1 > dist2
%             presentLaneExtra{i} = 2;
%         end
%
%         %%
%         distFromEgo = sqrt( (posOfEgoVehicle(1)-posOfExtraVehicle{i}(1))^2 + (posOfEgoVehicle(2)-posOfExtraVehicle{i}(2))^2 );
%
%         if presentLaneExtra{i} == presentLane && distFromEgo < safeDistance
%             presentLane = 3-presentLane;
%             count = 0;
%             break;
%         end
%     end
% end
%
% end