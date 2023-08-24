function [reward_unif] = uniform_reward_platoon(K,M,lambda_p,f0,f1,f2,f3,f4,d,lambda_f,u_f,reward,alpha,sigma)

% clear;
% K=6;


%y=K*(lambda_1+lambda_2)+lambda_f+u_f+2*K*2*u_t;
%y=M*(lambda_p)+lambda_f+u_f+f1/d+f2/d+f3/d+K*3*f0/d;
y=M*(lambda_p)+lambda_f+u_f+ (f1/d) + (f2/d) + (f3/d)+ (f4/d) + K*3*(f0/d);

%½±Àø¾ùÔÈ»¯
reward_unif = reward*(alpha+sigma)/(alpha+y);