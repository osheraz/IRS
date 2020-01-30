clc
clear all
% lihi kalakuda & osher azulay
%% Part A
myworld = cWorld();
myworld.plot;

myrobot = cRobot();
figure(1)
myrobot.set(40,40,0);
myrobot.print;
myrobot.plot;

myrobot.set(60,50,pi/2);
myrobot.print;
myrobot.plot;
myrobot.set(30,70,3*pi/4);
myrobot.print;
myrobot.plot;

%% Part B

forward_noise=5;
turn_noise=0.1;
sensing_distance_noise=5;
%% Part C

myrobot.set_noise(forward_noise,turn_noise,sensing_distance_noise);
d=myrobot.sense(myworld.landmarks);
%% Part D

myrobot.measurement_probability(myworld.landmarks,d);
%% Part E , F

u = [0 , 60; pi/3 , 30; pi/4 , 30; pi/4, 20; pi/4,40]';
myrobot.set(10,15,0);
theta=myrobot.theta;
x=myrobot.x;
y=myrobot.y;
myrobot.plot;
T=5;
loc = zeros(length(u)+1,3);
loc(1,:) = [10,15,0];

for i=1:T
    theta(i+1) = theta(i)+u(1,i);
    x(i+1) = x(i) + u(2,i)*cos(theta(i+1));
    y(i+1) = y(i) + u(2,i)*sin(theta(i+1));
end

for i=1:T
    oldx = myrobot.x;
    oldy = myrobot.y;
    myrobot.move(u(:,i));
    z(:,i)=myrobot.sense(myworld.landmarks);
    loc(i+1,1) = myrobot.x;
    loc(i+1,2) = myrobot.y;
    loc(i+1,3) = myrobot.theta;
    figure(2)
    myrobot.plot;
    hold on
    p1 =  plot([oldx myrobot.x],[oldy myrobot.y],'b-',[x(i) x(i+1)],[y(i) y(i+1)],'r--');
end

%% Part G

np = 100;
W=ones(np,1);

avg = zeros(length(u)+1,3); % average poses
avg(1,:) = [10,15,0]; % set first location

for i=1:np % create N cRobot array wih the same noise as the robot
    X(i)=cRobot();
    X(i).set(10,15,0);
    X(i).set_noise(forward_noise,turn_noise,sensing_distance_noise);
end

for j=1:T
    for i=1:np % prediction
        X(i).move(u(:,j));
        X(i).plot('k', 'particle');
        W(i)= X(i).measurement_probability(myworld.landmarks,z(:,j));
    end

    X = Low_variance_resampling(X,W,np); % resampling

    for f=1:np
        X(f).plot([0.5 0.5 0.5], 'particle');
        avg(j+1,:) = avg(j+1,:) + [X(f).x X(f).y X(f).theta] / np; % calc average location at each time step
    end
   W=ones(np,1);
end
p2 = plot(avg(1:end,1),avg(1:end,2),'g','LineStyle',':','LineWidth',2);
hold on;

avg_robot = cRobot(); % to plot the path and the robot that was estimated
for i=1:T+1
    avg_robot.set(avg(i,1),avg(i,2),avg(i,3));
    myrobot.set(loc(i,1),loc(i,2),loc(i,3));
    myrobot.plot('b', 'robot');
    avg_robot.plot('g', 'robot');
    hold on
    if i~=T+1
    p1 =  plot([loc(i,1),loc(i+1,1)],[loc(i,2) loc(i+1,2)],'b-',[x(i) x(i+1)],[y(i) y(i+1)],'r--');
    end
end
legend([p1(1) p1(2) p2(1)],'true path (with noise)','robot path (without noise)','avg path')
grid minor
