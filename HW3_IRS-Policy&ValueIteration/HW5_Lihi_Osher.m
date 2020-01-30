clear all
close all
clc

myworld = cWorld();

%% A
%%%%%%%%%%%%%%           A          %%%%%%%%%%%%%%%%%
p1 = 0.8 ; p2 = 0.1 ; p3 = 0.1 ;
to_state = Available_states( myworld ) ;
Prob_builder(myworld,p1,p2,p3 , to_state)


%% B , C , D
%%%%%%%%%%%%%%           B , C , D         %%%%%%%%%%%%%%%%%
% change gama\Reward for B,C,D

gamma = 1;        % discount factor
critrion=10^-4;   % stop critrion
Reward=-0.04;     % Reward for normal state
r=Reward*ones(12,1);
r(5)=0;           % Remove state
r(10)=1;          % Terminal state
r(11)=-1;         % Terminal state

v=ones(myworld.nStates,1);
V=zeros(myworld.nStates,1);      % State Value function
Policy =zeros(myworld.nStates,1);     % Deterministic Policy

[ V, Policy] = Value_Iteration(myworld, v,V , gamma , r , critrion);

% myworld.plot;
% myworld.plot_value(V)
% myworld.plot;
% myworld.plot_policy(Policy)

%% E
%%%%%%%%%%%%%%           E        %%%%%%%%%%%%%%%%%
gamma = 0.9;        % discount factor
critrion=10^-4;   % stop critrion
Reward=-0.04;     % Reward for normal state
r=Reward*ones(12,1);
r(5)=0;           % Remove state
r(10)=1;          % Terminal state
r(11)=-1;         % Terminal state

p = myworld.Pr;

% Init Policy - policy(Action,State)
 policy=0.25*ones(12,4);
 
%  policy = zeros(12,4);
%  for s=1:12
%       policy(s,randi(4))=1;
%  end


[ V, policy] = Policy_Iteration( myworld ,r , policy , p , to_state ,critrion , gamma);

% myworld.plot;
% myworld.plot_value(V)
% myworld.plot;
% myworld.plot_policy(policy)
