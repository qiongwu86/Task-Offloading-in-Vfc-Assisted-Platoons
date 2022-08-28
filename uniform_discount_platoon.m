function [discount_unif] = uniform_discount_platoon(K,M,lambda_p,f0,f1,f2,f3,f4,d,lambda_f,u_f,alpha)

% clear;
% K=6;
%y=M*(lambda_p)+lambda_f+u_f+f1/d+f2/d+f3/d+K*3*f0/d;
y=M*(lambda_p)+lambda_f+u_f+ (f1/d) + (f2/d) + (f3/d)+ (f4/d) + K*3*(f0/d);  % 注意是M

%折扣因子均匀化
discount_unif = y/(y+alpha);%gama*