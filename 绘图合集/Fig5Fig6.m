clc;
clear;
clear all
% reward of system
rewardSMDP_part5 = [4.6965e+05, 9.5452e+05, 1.8183e+06, 3.1712e+06, 5.0450e+06, 7.3409e+06, 9.7793e+06, ];
GA_bian5 =         [4.1103e+04, 6.5547e+04, 9.8244e+04, 1.3796e+05, 1.8576e+05, 2.4455e+05, 3.1506e+05, ];
Equa5 =            [7.2929e+03, 1.4821e+04, 2.0925e+04, 2.7617e+04, 4.2681e+04, 4.9375e+04, 5.2209e+04, ]; 

rewardSMDP_part6 = [8.8641e+05, 1.7805e+06, 3.1650e+06, 5.0015e+06, 7.2119e+06, 9.7568e+06, 1.2463e+07, ];
GA_bian6 =         [3.7781e+04, 6.0087e+04, 8.9930e+04, 1.2619e+05, 1.6967e+05, 2.2322e+05, 2.8751e+05, ];
Equa6 =            [7.9761e+03, 1.3627e+04, 2.2319e+04, 2.6594e+04, 3.4966e+04, 4.4057e+04, 4.9256e+04, ]; 
begin = 4;
endNum = 10;
geshu=endNum - begin + 1;      %归一化
for i=1:geshu
     discounted_SMDP5(i)=log10(rewardSMDP_part5(i));
     GA_unif5(i)=log10(GA_bian5(i));
     Equa_unif5(i)=log10(Equa5(i))
end

geshu=endNum - begin + 1;      %归一化
for i=1:geshu
     discounted_SMDP6(i)=log10(rewardSMDP_part6(i));
     GA_unif6(i)=log10(GA_bian6(i));
     Equa_unif6(i)=log10(Equa6(i))
end

p=figure(1);
t=begin:1:endNum;
p1 = plot(t,  discounted_SMDP5, '-r^','linewidth',2);
hold on
p2 = plot(t,  GA_unif5, '-bd','linewidth',2);
hold on
p3 = plot(t,  Equa_unif5, '-g>','linewidth',2);


p4 = plot(t,  discounted_SMDP6, '--r^','linewidth',2);
hold on
p5 = plot(t,  GA_unif6, '--bd','linewidth',2);
hold on
p6 = plot(t,  Equa_unif6, '--g>','linewidth',2);

ax1 = gca;
ax2 = axes('Position', get(ax1, 'Position'), 'Visible', 'off');

legend([p1, p2, p3], 'our strategy, \lambda_p=20, d=40','greedy strategy, \lambda_p=20, d=40',"equal probability strategy, \lambda_p=20, d=40")

ah = axes('position',get(gca,'position'),'visible','off'); %新建一个坐标轴对象，位置和当前的坐标轴一致，并且设置为不可见，这样就不会覆原来绘制的图
legend2 = legend(ah, [p3, p4, p5],'our strategy, \lambda_p=13, d=40','greedy strategy, \lambda_p=13, d=40',"equal probability strategy, \lambda_p=13, d=40");

%legend(ax2, 'our strategy, \lambda_p=13, d=40','greedy strategy, \lambda_p=13, d=40',"equal probability strategy, \lambda_p=13, d=40")
       
xlabel('Maximum number of vehicles');
ylabel('Long-term reward');