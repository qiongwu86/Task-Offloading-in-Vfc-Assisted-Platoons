function [discount_unif] = uniform_discount_new(K,lambda_1,lambda_2,u_t,lambda_f,u_f,alpha)

% clear;
% K=6;

y=K*(lambda_1+lambda_2)+lambda_f+u_f+2*K*2*u_t;

%折扣因子均匀化
discount_unif = y/(y+alpha);%gama*