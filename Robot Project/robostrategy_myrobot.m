function [move,mem] = robostrategy_Trojan(env,mem)
    %Strategy for robot tournament game, following opponent
    %
    %Environment Struct
    % field:
    % info,  STRUCT{team, fuel, myPos, oppPos}
    % basic, STRUCT{walls, rRbt, rMF, lmax}
    % mines, STRUCT{nMine, mPos, mineScr, mineExist}
    % fuels, STRUCT{nFuel, fPos, fScr, fExist}
    %
    %Memory Struct
    % field:
    % path, STRUCT{start, dest, pathpt, nPt, proc, lv}
    
    % Finds the closest fuel barrel
    closest_fuel_index = closestFuel(env);
    
    % Calculates a path to the closest barrel
    move = calculatePath(env, closest_fuel_index);
    
    % Finds the closest mine
    closest_mine_index = closestMine(env);
    
    % Dodges mines and walls
    move = checkMine(env, move, closest_mine_index, closest_fuel_index);
    
    % Checks if we won base on the opponents fuel
    move = checkIfWon(env, move);
    
    % Checks if there is no more fuel left on the board
    move = checkFuel(env, move);
end

%% Functions

function closest_fuel_index = closestFuel(env)
    closest_fuel_index = 0;
    closest_fuel = sqrt(201);
    for ii = 1:env.fuels.nFuel
        dfuel = sqrt((env.fuels.fPos(ii,1)- env.info.myPos(1,1)).^2 + (env.fuels.fPos(ii,2)- env.info.myPos(1,2)).^2); % Distance between us and the closest barrel
        dfuel_op = sqrt((env.fuels.fPos(ii,1)- env.info.opPos(1,1)).^2 + (env.fuels.fPos(ii,2)- env.info.opPos(1,2)).^2);
        switch_target = false;
        if(dfuel_op <= dfuel*0.85) 
            switch_target = true;
        end
        if(dfuel < closest_fuel && env.fuels.fExist(ii) && switch_target == false)
            closest_fuel_index = ii;
            closest_fuel = dfuel;
        end
    end
end

function move = calculatePath(env,closest_fuel_index)
    if(closest_fuel_index ~= 0)
        xmove = env.fuels.fPos(closest_fuel_index,1)-env.info.myPos(1,1);
        ymove = env.fuels.fPos(closest_fuel_index,2)-env.info.myPos(1,2);
        move = [xmove ymove];
    else
        move = [0 0];
    end
end

function closest_mine_index = closestMine(env)
    closest_mine_index = 0; 
    closest_mine = sqrt(201);
    for ii = 1:env.mines.nMine
        dmine = sqrt((env.mines.mPos(ii,1)- env.info.myPos(1,1)).^2 + (env.mines.mPos(ii,2)- env.info.myPos(1,2)).^2); % Distance between us and the closest mine
        if(dmine < closest_mine && env.mines.mExist(ii))
            closest_mine_index = ii;
            closest_mine = dmine;
        end
    end
end

function move = checkMine(env, move, closest_mine_index, closest_fuel_index)
    
    radius = 0.75;

    % Checks for mine proximity
    mine_proximity = false; 
    if(sqrt((env.mines.mPos(closest_mine_index,1)- env.info.myPos(1,1)).^2 + (env.mines.mPos(closest_mine_index,2)- env.info.myPos(1,2)).^2) <= radius)
        mine_proximity = true;
    end
    
    % Checks the angle between the robot-fuel vector and the robot-mine
    % vector to know when to stop circling the mine
    if(closest_fuel_index ~= 0 && closest_mine_index ~= 0)
    
        fuelVec = [env.fuels.fPos(closest_fuel_index,1) env.fuels.fPos(closest_fuel_index,2)] - env.info.myPos;
        mineVec = [env.mines.mPos(closest_mine_index,1) env.mines.mPos(closest_mine_index,2)] - env.info.myPos;
        cos_angle = dot(mineVec, fuelVec) / (norm(mineVec) * norm(fuelVec));
        angle_rad = acos(cos_angle);
        angle_deg = rad2deg(angle_rad);
    
        angle_check = false;
        if(angle_deg >= 65)
            angle_check = true;
        end
        
        % Dodging algorithm
        if(mine_proximity == true && angle_check == false)
            angle_to_mine = atan2(env.info.myPos(1,2) - env.mines.mPos(closest_mine_index,2), env.info.myPos(1,1) - env.mines.mPos(closest_mine_index,1));
            
            % Default direction = clockwise
            clockwise = true;
            
            % Checks when to circle the mine in a counter clockwise motion
            if (env.info.myPos(1,1) < env.mines.mPos(closest_mine_index,1)) % X Check 1
    
                if(env.info.myPos(1,2) > env.mines.mPos(closest_mine_index,2)) % Y check 1
                    
                    if(checkIfMineUpper(env.info.myPos(1),env.info.myPos(2),env.fuels.fPos(closest_fuel_index,1),env.fuels.fPos(closest_fuel_index,2),env.mines.mPos(closest_mine_index,1),env.mines.mPos(closest_mine_index,2)) == true)
                        if(env.info.myPos(1,1) <= env.fuels.fPos(closest_fuel_index,1))
                            clockwise = false;
                        end
                    end
    
                    if(checkIfMineUpper(env.info.myPos(1),env.info.myPos(2),env.fuels.fPos(closest_fuel_index,1),env.fuels.fPos(closest_fuel_index,2),env.mines.mPos(closest_mine_index,1),env.mines.mPos(closest_mine_index,2)) == false)
                        if(env.info.myPos(1,1) > env.fuels.fPos(closest_fuel_index,1))
                            clockwise = false;
                        end
                    end
                end
    
                if(env.info.myPos(1,2) <= env.mines.mPos(closest_mine_index,2)) % Y check 2
                    if(env.info.myPos(1,1) < env.fuels.fPos(closest_fuel_index,1))
                        if(checkIfMineUpper(env.info.myPos(1),env.info.myPos(2),env.fuels.fPos(closest_fuel_index,1),env.fuels.fPos(closest_fuel_index,2),env.mines.mPos(closest_mine_index,1),env.mines.mPos(closest_mine_index,2)) == true)
                            clockwise = false;
                        end
                    end
                end
            end
    
            if (env.info.myPos(1,1) >= env.mines.mPos(closest_mine_index,1)) % X Check 2
    
                if(env.info.myPos(1,2) > env.mines.mPos(closest_mine_index,2)) % Y check 1
                    if(env.info.myPos(1,1) > env.fuels.fPos(closest_fuel_index,1))
                        if(checkIfMineUpper(env.info.myPos(1),env.info.myPos(2),env.fuels.fPos(closest_fuel_index,1),env.fuels.fPos(closest_fuel_index,2),env.mines.mPos(closest_mine_index,1),env.mines.mPos(closest_mine_index,2)) == false)
                            clockwise = false;
                        end
                    end
                end
    
                if(env.info.myPos(1,2) <= env.mines.mPos(closest_mine_index,2)) % Y check 2
    
                    if(checkIfMineUpper(env.info.myPos(1),env.info.myPos(2),env.fuels.fPos(closest_fuel_index,1),env.fuels.fPos(closest_fuel_index,2),env.mines.mPos(closest_mine_index,1),env.mines.mPos(closest_mine_index,2)) == true)
                        if(env.info.myPos(1,1) <= env.fuels.fPos(closest_fuel_index,1))
                            clockwise = false;
                        end
                    end
    
                    if(checkIfMineUpper(env.info.myPos(1),env.info.myPos(2),env.fuels.fPos(closest_fuel_index,1),env.fuels.fPos(closest_fuel_index,2),env.mines.mPos(closest_mine_index,1),env.mines.mPos(closest_mine_index,2)) == false)
                        if(env.info.myPos(1,1) > env.fuels.fPos(closest_fuel_index,1))
                            clockwise = false;
                        end
                    end
                end
            end
            
            % Checks for walls when circling a mine and determines the
            % correct circling direction
            if(env.mines.mPos(closest_mine_index,1) < 0.75) % Left wall
                if(env.info.myPos(1,2) < env.fuels.fPos(closest_fuel_index,2))
                    clockwise = false;
                end
    
                if(env.info.myPos(1,2) > env.fuels.fPos(closest_fuel_index,2))
                    clockwise = true;
                end
            end
    
            if(env.mines.mPos(closest_mine_index,1) > 9.25) % Right wall
                if(env.info.myPos(1,2) < env.fuels.fPos(closest_fuel_index,2))
                    clockwise = true;
                end
    
                if(env.info.myPos(1,2) > env.fuels.fPos(closest_fuel_index,2))
                    clockwise = false;
                end
            end
    
            if(env.mines.mPos(closest_mine_index,2) < 0.75) % Lower wall
                if(env.info.myPos(1,1) < env.fuels.fPos(closest_fuel_index,1))
                    clockwise = true;
                end
    
                if(env.info.myPos(1,1) > env.fuels.fPos(closest_fuel_index,1))
                    clockwise = false;
                end
            end
    
            if(env.mines.mPos(closest_mine_index,2) > 9.25) % Upper wall
                if(env.info.myPos(1,1) < env.fuels.fPos(closest_fuel_index,1))
                    clockwise = false;
                end
    
                if(env.info.myPos(1,1) > env.fuels.fPos(closest_fuel_index,1))
                    clockwise = true;
                end
            end
            
            % Prints for debugging of the dodging algorithm
            %{
            robot = env.info.myPos
            mine = [env.mines.mPos(closest_mine_index,1) env.mines.mPos(closest_mine_index,2)]
            fuel = [env.fuels.fPos(closest_fuel_index,1) env.fuels.fPos(closest_fuel_index,2)]
            mineUpper = checkIfMineUpper(env.info.myPos(1),env.info.myPos(2),env.fuels.fPos(closest_fuel_index,1),env.fuels.fPos(closest_fuel_index,2),env.mines.mPos(closest_mine_index,1),env.mines.mPos(closest_mine_index,2))
            clockwise
            %}
    
            if clockwise
                tangent_angle = angle_to_mine - pi/2;
            else
                tangent_angle = angle_to_mine + pi/2;
            end
            deltaa_tangent = radius * cos(tangent_angle);
            deltab_tangent = radius * sin(tangent_angle);
            x_robot_tangent = env.info.myPos(1,1) + deltaa_tangent;
            y_robot_tangent = env.info.myPos(1,2) + deltab_tangent;
            distance_to_mine = sqrt((x_robot_tangent - env.mines.mPos(closest_mine_index,1))^2 + (y_robot_tangent - env.mines.mPos(closest_mine_index,2))^2);
            scaling_factor = radius / distance_to_mine;
            x_next = env.mines.mPos(closest_mine_index,1) + (x_robot_tangent - env.mines.mPos(closest_mine_index,1)) * scaling_factor;
            y_next = env.mines.mPos(closest_mine_index,2) + (y_robot_tangent - env.mines.mPos(closest_mine_index,2)) * scaling_factor;
            deltaa = x_next - env.info.myPos(1,1);
            deltab = y_next - env.info.myPos(1,2);
            norm_factor = sqrt(deltaa^2 + deltab^2);
            deltaa = deltaa / norm_factor;
            deltab = deltab / norm_factor;
            move = [deltaa, deltab];
        end
    end
    
    % Checks if the mine is above or below the robot-fuel vector
    function [upper] = checkIfMineUpper(x1,y1,x2,y2,xmine,ymine)
        m = (y2 - y1) / (x2 - x1);
        c = y1 - m * x1;
    
        y_on_line = m * xmine + c;
        if ymine >= y_on_line
            upper = true;
        elseif ymine < y_on_line
            upper = false;
        end
    end
end

function move = checkIfWon(env, move)
    fuel_to_win = sum(30*env.fuels.fExist);
    if(env.info.fuel > fuel_to_win+env.info.fuel_op)
        move = [0 0];
    end
end

function move = checkFuel(env, move)
    if(env.fuels.fExist == zeros(1,16))
        move = [0 0];
    end
end