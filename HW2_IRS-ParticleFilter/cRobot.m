classdef cRobot < handle
    
    
    
    properties
        
        % pose
        x;
        y;
        theta;
        
        % noise
        forward_noise = 0;
        turn_noise    = 0;
        sense_distance_noise   = 0;
        
        
    end
    
    methods
        
        function obj = cRobot % method constructor
            
            % place robot with a random pose
            obj.x = rand*cWorld.world_size;
            obj.y = rand*cWorld.world_size;
            obj.theta = rand*2*pi;
            
            
        end
        
        
        
        % sets the new pose
        function  obj = set(obj,new_x,new_y, new_orientation)
            
            
            if (new_x < 0 | new_x >= cWorld.world_size)
                error('X coordinate out of bound');
            end
            
            if (new_y < 0 | new_y >= cWorld.world_size)
                error('Y coordinate out of bound');
            end
            
            if (new_orientation < 0 | new_orientation >= 2 * pi);
                error('Orientation must be in [0,2pi]');
            end
            
            
            obj.x = new_x;
            obj.y = new_y;
            obj.theta = new_orientation;
            
            
        end
        
        % prints the pose of the robot to the Matlab prompt
        function   print(obj)
            
            display(['[x= ',num2str(obj.x), '  y=', num2str(obj.y), '  heading=', num2str(obj.theta),']']);
            
        end
        
        % plots the pose of the robot in the world
        function plot(obj,mycolor,style)
            
            if(nargin == 1)
                mycolor = 'b'; % default
                style = 'robot';
            end
            
            if(nargin == 2)
                style = 'robot'; % default
            end
            
            hold on;
            
            
            % different plot styles for the robot
            switch style
                
                case 'robot'
                    
                    % size of robot
                    phi = linspace(0,2*pi,101);
                    r = 3;
                    
                    
                    % plot robot body
                    plot(obj.x + r*cos(phi),obj.y + r*sin(phi),'Color',mycolor,'LineWidth',2);
                    hold on;
                    % plot heading direction
                    plot([obj.x, obj.x + r*cos(obj.theta)],[obj.y, obj.y + r*sin(obj.theta)],'Color',mycolor,'LineWidth',2);
                    
                    axis equal;
                    
                    
                case 'particle'
                    
                    
                    % plots robot position but ignores heading
                    plot(obj.x,obj.y,'.','Color',mycolor,'MarkerSize',10);
                    
                    
                    
                otherwise
                    
                    disp('unknown style');
                    
            end
            
            xlim([0,cWorld.world_size]);
            ylim([0,cWorld.world_size]);
            
        end
        
        
        % sets new noise parameters
        function obj = set_noise(obj, new_forward_noise, new_turn_noise, new_sensing_distance_noise )
            obj.forward_noise = new_forward_noise;
            obj.turn_noise    = new_turn_noise;
            obj.sense_distance_noise   = new_sensing_distance_noise;
        end
        %% Movement function (b)
        function move(obj,u)
            % recive movement command and apply it to the robot with
            % respect to his command and noise
            obj.theta = obj.theta + normrnd(u(1),obj.turn_noise);
            obj.x = obj.x + normrnd(u(2),obj.forward_noise)*cos(obj.theta);
            obj.y = obj.y + normrnd(u(2),obj.forward_noise)*sin(obj.theta);
            % make sure that the robot stay inside to world
          if obj.x>100
              obj.x=obj.x-100;
          elseif obj.x<0
              obj.x=obj.x+100;
          end
          if obj.y>100
              obj.y=obj.y-100;
          elseif obj.y<0
              obj.y=obj.y+100;
          end   
          if obj.theta>2*pi
              obj.theta=mod(obj.theta,2*pi);
          elseif obj.theta<0
              obj.theta=-mod(obj.theta,2*pi)+2*pi;
          end
        end
        
        %% Observations - distances from landmarks (c)
        function distance=sense(obj,pillars)
            % recive pillars from the world object and return the robot distance
            % from each pillar with respect to his measurement noise.
            noise = mvnrnd(zeros(length(pillars),1),obj.sense_distance_noise*eye(length(pillars)))';
            distance=sqrt( (pillars(:,1)-obj.x).^2 + (pillars(:,2)-obj.y).^2 ) + noise;
        end
        
        %% Measurement Probability  - distances from landmarks (c)
        function prob=measurement_probability(obj,pillars,distance)
            % recive pillars from the world object and the measured robot distance
            % from each pillars and return the probability for each
            % particle to be with the same distance.
            d_est=sqrt( (pillars(:,1)-obj.x).^2 + (pillars(:,2)-obj.y).^2 );    
            prob=mvnpdf(d_est,distance,25*eye(length(pillars)));   
%           prob=prod(normpdf(d_est-distance,0,5))    
        end
    end
    
end




