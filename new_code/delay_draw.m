clc;
clear;


delay_all = ...
[[58.3831, 57.2199, 67.672 ]
[59.8797, 58.6785, 70.8822 ]
[61.2411, 60.0394, 71.0773 ]
[62.5804, 61.4181, 73.6211 ]
[63.862, 62.8649, 75.3252 ]
[65.1744, 64.2786, 76.2733 ]
[66.4118, 65.7285, 77.8198 ]
[67.7012, 67.1908, 81.9533 ]
[69.0092, 68.6624, 83.5346 ]
[70.5072, 70.1513, 87.365 ]
[71.895, 71.6287, 87.0279 ]
];
delay_all = delay_all';


p=figure(1);
t =35 : 45;
p1 = plot(t,  delay_all(1,:), '-r^','linewidth',2);
hold on
p2 = plot(t,  delay_all(2,:), '-bd','linewidth',2);
hold on
p3 = plot(t,  delay_all(3,:), '-g>','linewidth',2);

legend([p1, p2, p3], 'our strategy','greedy strategy,',"equal strategy")

xlabel('Required CPU cycles to process each task');
ylabel('Delay of offloading a task (ms)');

