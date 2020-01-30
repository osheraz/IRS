function [ V, policy] = Policy_Iteration( myworld ,r , policy , p , to_state ,critrion , gamma)
% we itterate untill the new policy doest change the SVF vector
counter=0;
Pss_=zeros(myworld.nStates,myworld.nStates);
v_b=ones(myworld.nStates,1); % Value before
v=ones(myworld.nStates,1);   % V at iteration k
V=zeros(myworld.nStates,1);  % V at iteration k + 1

while max( abs(v_b-V) ) >= critrion
   
%     myworld.plot;
%     myworld.plot_value(V)
%     myworld.plot;
%     myworld.plot_policy(policy)
    
    Pss_=zeros(12,12);
    
    for s=1:myworld.nStates
        if ismember(s,[myworld.stateTerminals' , myworld.stateObstacles])
            continue % case Terminal/Obstacle
        end
        for a=1:myworld.nActions
            Pss_(s,:) = Pss_(s,:) + policy(s,a) * p(s,:,a);
        end
    end
    
    
    % Policy Evaluation
    
    v_b=V;
    v=ones(12,1);
    V=zeros(12,1);
    
    while max( abs(v-V) ) >= critrion
        v=V;
        V=r+gamma*Pss_*v;  % Calc SVF
    end
    
    %  Policy Improvment
    
    v_a = zeros(12,4);  % Value with respect to each action for
    for s=1:myworld.nStates
        if ismember(s,[myworld.stateTerminals' , myworld.stateObstacles])
            continue % case Terminal/Obstacle
        end
        v_a(s,:) = V(to_state(s,:));
    end
    for s=1:myworld.nStates
        if ismember(s,[myworld.stateTerminals' , myworld.stateObstacles])
            continue % case Terminal/Obstacle
        end
        [MAX , ~] = max( v_a(s,:)) ;         % find max value and action
        ind_bests = find( v_a(s,:)== MAX );
        
        P = 1/numel(ind_bests);              % calc probabilty
        for a=1:myworld.nActions
            if ( sum( ismember(ind_bests,a) ) == 0 )
                policy(s,a)=0; % case not found , 1/numel goes inf.
            else
                policy(s,ind_bests)= P;
            end
        end
    end
    
    counter=counter+1;

end
disp(['Policy Iteration algorithem ']);
disp(['iteration until convergence : ', num2str(counter)]);

end

