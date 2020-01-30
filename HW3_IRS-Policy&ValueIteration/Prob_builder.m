function Prob_builder( myworld , p1 ,p2 , p3 , to_state )

p=zeros(myworld.nStates,myworld.nStates,myworld.nActions);  % Pss'a


for action =1:myworld.nActions % Build Pss'a
    for from_state=1:myworld.nStates
        if ismember(from_state,[myworld.stateTerminals' , myworld.stateObstacles])
            continue % case Terminal/Obstacle
        end
        if action ==1
            p(from_state,to_state(from_state,1),action) = p(from_state,to_state(from_state,1),action) + p1;
            p(from_state,to_state(from_state,2),action) = p(from_state,to_state(from_state,2),action) + p2;
            p(from_state,to_state(from_state,4),action) = p(from_state,to_state(from_state,4),action) + p3;
        elseif action==2
            p(from_state,to_state(from_state,1),action) = p(from_state,to_state(from_state,1),action) + p2;
            p(from_state,to_state(from_state,2),action) = p(from_state,to_state(from_state,2),action) + p1;
            p(from_state,to_state(from_state,3),action) = p(from_state,to_state(from_state,3),action) + p3;
        elseif action ==3
            p(from_state,to_state(from_state,4),action) = p(from_state,to_state(from_state,4),action) + p2;
            p(from_state,to_state(from_state,2),action) = p(from_state,to_state(from_state,2),action) + p3;
            p(from_state,to_state(from_state,3),action) = p(from_state,to_state(from_state,3),action) + p1;
        elseif action == 4
            p(from_state,to_state(from_state,4),action) = p(from_state,to_state(from_state,4),action) + p1;
            p(from_state,to_state(from_state,1),action) = p(from_state,to_state(from_state,1),action) + p2;
            p(from_state,to_state(from_state,3),action) = p(from_state,to_state(from_state,3),action) + p3;
        end
    end    
end

myworld.Pr = p(:,:,:); % Update Pss'a
end