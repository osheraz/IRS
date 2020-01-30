close all;
clc;
clear all;

%%  Part B  

dt=0.1;   % time interval
a=1.5;
S_a = 0.5;
data=dlmread('data.txt');
t=data(:,1);
Z=data(:,2);  % measurment data
figure(1)
subplot(2,1,1)
plot(t,Z,'-o',t,smooth(Z),'r-')
xlabel('Time [sec]'); ylabel('Position [m]');grid minor
legend('Measured','Smooth');
subplot(2,1,2)
v_diff=(Z(2:end)-Z(1:end-1))./dt;  
plot(t(2:end,1),v_diff,'-o',t(2:end,1),smooth(v_diff),'r-');grid minor
xlabel('Time [sec]'); ylabel('Velocity [m/s]');
legend('Measured','Smooth');


%% Part C- Calculate excat location and Velocity

X=0*[1:length(data)];
Xdot=0*[1:length(data)-1];
X_NoNoise=0*[1:length(data)];
Xdot_NoNoise=0*[1:length(data)-1];

for i=1:length(data)
    X(i+1)= X(i) + Xdot(i)*dt + 0.5*(mvnrnd(a,S_a))*dt^2 ;
    Xdot(i+1) = Xdot(i) + mvnrnd(a,S_a)*dt ;
    X_NoNoise(i+1)= X_NoNoise(i) + Xdot_NoNoise(i)*dt + 0.5*(mvnrnd(a,0))*dt^2 ;
    Xdot_NoNoise(i+1) = Xdot_NoNoise(i) + mvnrnd(a,0)*dt ;
end

figure(2)
subplot(2,1,1)
plot(t,Z,'-o',t,smooth(Z),'r-');hold on
plot((1:length(X))./10,X(:),'g',(1:length(X_NoNoise))./10,X_NoNoise(:),'m');
xlabel('Time [sec]'); ylabel('Position [m]');grid minor;
legend('Measured','Smooth','Exact with noise','Exact without noise');
xlim([0 10])
subplot(2,1,2)
plot(t(2:end,1),v_diff,'-o',t(2:end,1),smooth(v_diff),'r-');hold on;
plot((1:length(Xdot))./10,Xdot(:),'g');hold on
plot((1:length(Xdot_NoNoise))./10,Xdot_NoNoise(:),'m');hold on
xlabel('Time [sec]'); ylabel('Velocity [m/s]');
legend('Measured','Smooth','Exact with noise','Exact without noise');
xlim([0 10]);grid minor

%% D - Implementation of KF for the model , part A

S_a = 0.5;
A=[ 1 , dt ; 0 ,1];
B=[0.5*dt^2; dt];
U=a;
R=(S_a.^2).*[0.25*dt^4 ,0.5*dt^3 ; 0.5*dt^3 , dt^2];
C=[1,0];

M=zeros(2,length(data));
S=zeros(2,2,length(data));
S_gag=S;
M_gag=M;
K=zeros(2,length(data));

%% D part B
Q=1;

for i=1:length(data)-1
    M_gag(:,i+1)=A*M(:,i)+B*a;
    S_gag(:,:,i+1)=A*S(:,:,i)*A'+R;
    K(:,i+1)=S_gag(:,:,i+1)*C'*(inv(C*S_gag(:,:,i+1)*C'+Q));
    M(:,i+1)= M_gag(:,i+1)+K(:,i+1)*(Z(i+1)-C*M_gag(:,i+1));
    S(:,:,i+1)=(eye(2)-K(:,i+1)*C)*S_gag(:,:,i+1);
end

figure(3)
subplot(2,1,1)
plot(t,Z,'-o');hold on  
plot(t,smooth(Z),'r-');hold on
plot((1:length(X))./10,X(:),'g',(1:length(X_NoNoise))./10,X_NoNoise(:),'m');hold on
plot((1:length(M(1,:)))./10,M(1,:),'b');
xlabel('Time [sec]'); ylabel('Position [m]');grid minor;
legend('Measured','Smooth','Exact with noise','Exact without noise','Kalman \sigma=1');
xlim([0 10])

subplot(2,1,2)
plot(t(2:end,1),v_diff,'-o',t(2:end,1),smooth(v_diff),'r-');hold on;
plot(t(2:end,1),smooth(v_diff),'r-');hold on
plot((1:length(Xdot))./10,Xdot(:),'g');hold on
plot((1:length(Xdot_NoNoise))./10,Xdot_NoNoise(:),'m');hold on
plot((1:length(M(2,:)))./10,M(2,:),'b')
xlabel('Time [sec]'); ylabel('Velocity [m/s]');
legend('Measured','Smooth','Exact with noise','Exact without noise','Kalman \sigma=1');
xlim([0 10]);grid minor

Q=100;

for i=1:length(data)-1
    M_gag(:,i+1)=A*M(:,i)+B*a;
    S_gag(:,:,i+1)=A*S(:,:,i)*A'+R;
    K(:,i+1)=S_gag(:,:,i+1)*C'*(inv(C*S_gag(:,:,i+1)*C'+Q));
    M(:,i+1)= M_gag(:,i+1)+K(:,i+1)*(Z(i+1)-C*M_gag(:,i+1));
    S(:,:,i+1)=(eye(2)-K(:,i+1)*C)*S_gag(:,:,i+1);
end

figure(4)

subplot(2,1,1)
plot(t,Z,'-o');hold on  
plot(t,smooth(Z),'r-');hold on
plot((1:length(X))./10,X(:),'g',(1:length(X_NoNoise))./10,X_NoNoise(:),'m');hold on
plot((1:length(M(1,:)))./10,M(1,:),'b');
xlabel('Time [sec]'); ylabel('Position [m]');grid minor;
legend('Measured','Smooth','Exact with noise','Exact without noise','Kalman \sigma=100');
xlim([0 10])

subplot(2,1,2)
plot(t(2:end,1),v_diff,'-o',t(2:end,1),smooth(v_diff),'r-');hold on;
plot(t(2:end,1),smooth(v_diff),'r-');hold on
plot((1:length(Xdot))./10,Xdot(:),'g');hold on
plot((1:length(Xdot_NoNoise))./10,Xdot_NoNoise(:),'m');hold on
plot((1:length(M(2,:)))./10,M(2,:),'b')
xlabel('Time [sec]'); ylabel('Velocity [m/s]');
legend('Measured','Smooth','Exact with noise','Exact without noise','Kalman \sigma=100');
xlim([0 10]);grid minor



%% Calculte PDF for t = 0 , 5 , 10

x=[-5:0.01:25;5:0.01:35;65:0.01:95];
y=[2,51,101];
for t=1:3
    figure(t+5)
    before=normpdf(x(t,:),M_gag(1,y(t)),sqrt(S_gag(1,1,y(t))));
    after=normpdf(x(t,:),M(1,y(t)),sqrt(S(1,1,y(t))));
    measure=normpdf(x(t,:),Z(y(t)),10);
    plot(x(t,:),before,'g',x(t,:),after,'r',x(t,:),measure,'b');hold on
    plot(X(y(t)+1)*[1 1],[0 max(before)],'k');hold on
    plot(X_NoNoise(y(t)+1)*[1 1],[0 max(before)],'k--')
    if max(before)>10  %% for t=0 graph
        ylim([0 1])
    end
    grid on; grid minor
    legend('Prediction','Kalman','Measurement','Exact with noise','Exact Without Noise');
    title(sprintf('PDF at time %d sec',(y(t)-1)/10));
    xlabel('Position'); ylabel('Probability');
end
