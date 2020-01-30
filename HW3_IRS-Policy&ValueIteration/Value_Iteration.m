function [ V, Policy] = Value_Iteration(myworld, v,V , gamma , r , critrion)

V_action=zeros(12,1,4); % Action Value function
counter=0;
Policy=zeros(12,1);     % Deterministic Policy

while max( abs(v-V) ) >= critrion
    
    v=V;
    % calc the value of each state with respect to all the actions
    for a=1:myworld.nActions % get [12,1] vector for every state and action
        V_action(:,:,a)= r + gamma * myworld.Pr(:,:,a) * V;
    end
    
    for s=1:length(V)
        [ V(s), Policy(s) ]= max( V_action(s,1,:) );
    end   
    counter=counter+1;
end
disp(['Value Iteration algorithem '])
disp(['iteration until convergence : ', num2str(counter)])

end

