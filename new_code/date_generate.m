clc;
clear;
tic;

%！！！！ 【注意，将V3_mdp_bellman_operator_calculateValue中的K值，换成对应的】
K_all = 5:9;   % 【车载云】中，车辆总数【车载云】 (4-10)  
K = 6;
M = 4;  % 车队中车辆总数

lambda_f = 9;     %车辆到达率【秒】
u_f = 8;            %车辆离开率【秒】
lambda_p_range = 15 : 25;
lambda_p = 20;        %任务到达率【秒】 变化15-25

% 任务离开率  u_p = f/d 单位为s
f0 = 350;  %==========530-600

f1 = 600;   %分配给头车
f2 = 660;  
f3 = 620; 
f4 = 650;
d =  40; 
d_all = 35:45;
%% 参数获取 
for lambda_p = lambda_p_range
    [s, P, R, discount, delay_all] = data_input_platoon(K,M,lambda_p,lambda_f,u_f,f0,f1,f2,f3,f4,d);
%     save("K"+K+"/s", "s");
%     save("K"+K+"/P.mat", "P");
%     save("K"+K+"/R.mat", "R");
%     save("K"+K+"/discount.mat", "discount");
%     save("K"+K+"/delay_all.mat", "delay_all");

%     save("d/"+d+"s", "s");
%     save("d/"+d+"P.mat", "P");
%     save("d/"+d+"R.mat", "R");
%     save("d/"+d+"discount.mat", "discount");
%     save("d/"+d+"delay_all.mat", "delay_all");
%     
%     sprintf("data save for d = " + d)

    save("lambda_p/"+lambda_p+"s", "s");
    save("lambda_p/"+lambda_p+"P.mat", "P");
    save("lambda_p/"+lambda_p+"R.mat", "R");
    save("lambda_p/"+lambda_p+"discount.mat", "discount");
    save("lambda_p/"+lambda_p+"delay_all.mat", "delay_all");
    
    sprintf("data save for lambda_p = " + lambda_p)
end
