clc;
clear;


delay_all = ...
[[64.9744, 64.6464, 76.194 ]
[64.905, 64.3132, 76.8165 ]
[65.1744, 64.2786, 76.498 ]
[65.6124, 64.6331, 78.499 ]
[66.3693, 65.2915, 80.8517 ]
[66.7215, 65.6024, 82.8636 ]
[67.0044, 65.9656, 84.8811 ]
];
delay_all = delay_all';


p=figure(1);
t =4:10;
p1 = plot(t,  delay_all(1,:), '-r^','linewidth',2);
hold on
p2 = plot(t,  delay_all(2,:), '-bd','linewidth',2);
hold on
p3 = plot(t,  delay_all(3,:), '-g>','linewidth',2);

legend([p1, p2, p3], 'our strategy','greedy strategy,',"equal strategy")

xlabel('Maximum number of vehicles in VFC');
ylabel('Delay of offloading a task (ms)');

