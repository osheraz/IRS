function to_state = Available_states( myworld )
states = reshape(1:myworld.nStates, myworld.nRows, myworld.nCols); 

for state=1:myworld.nStates % Get availible s' for each s
    [i,j] = find(state == states);
    try
        NORTH = states(i-1,j);
    catch
        NORTH = state;
    end
    
    try
        EAST = states(i,j+1);
    catch
        EAST = state;
    end
    try
        SOUTH = states(i+1,j);
    catch
        SOUTH = state;
    end
    
    try
        WEST = states(i,j-1);
    catch
        WEST = state;
    end
    all = [NORTH, EAST, SOUTH, WEST];
    for obstacle = myworld.stateObstacles;
        all(all == obstacle) = state;
    end
    to_state(state,:) = all; % availble states from each state
end


end

