function [reward_unif] = uniform_reward_new(K,lambda_1,lambda_2,u_t,lambda_f,u_f,reward,alpha,sigma)

% clear;
% K=6;

%y=K*lambda_t+lambda_f+u_f+K*3*u_t;
y=K*(lambda_1+lambda_2)+lambda_f+u_f+2*K*2*u_t;

%½±Àø¾ùÔÈ»¯
reward_unif = reward*(alpha+sigma)/(alpha+y);