function [s] = initial_state_platoon(K)

% 好像不用传，车队车辆总数过来，只需要传车载云车辆总数
%K=10;
%s = {0,[0,0,0],' '};
%s = {0,[0,0],[0,0],' '};
s = {0, [0,0,0,0], [0,0,0], ' '};
% s{row,1} = M；s{row,2}(1) = s1;s{row,2}(2) = s2;s{row,2}(3) = s3；
% s{row,3}(1) = i1;s{row,3}(2) = i2;s{row,3}(3) = i3;
% s{row,4}=event;  s{row,5} = s{row,1} - (1*i1+2*i2+3*i3);
% D11被1个RU处理的A1优先级任务离开
event = {'A';'D1';'D2';'D3';'D4';'L1';'L2';'L3';'F+1';'F-1'};
row = 1;

for s1 = 0:1      %车队头车的状态，为1表示为忙碌车辆
 for s2 = 0:1
  for s3 = 0:1
   for s4 = 0:1
     for k = 1:K
      for i1 = 0:K
       for i2 = 0:ceil(K/2)
        for i3 = 0: ceil(K/3)
         for e = 1:length(event)
           if 1*i1+2*i2+3*i3 <=k
            s{row,1} = k;
            s{row,2}(1) = s1; % 说明车队情况
            s{row,2}(2) = s2;
            s{row,2}(3) = s3;
            s{row,2}(4) = s4;         
                       
            s{row,3}(1) = i1;% 车载云分配情况
            s{row,3}(2) = i2;
            s{row,3}(3) = i3;
            
            s{row,5} = s{row,1} - (1*i1+2*i2+3*i3); %剩余资源
            
       
            %当s1/2/3为0时，没有事件D1/D2/D3，去除这些状态(除去非法状态)   % 由车队成员分配导致的
            if strcmp(event{e},'D1')&&s{row,2}(1)==0
                continue;
            end
            if strcmp(event{e},'D2')&&s{row,2}(2)==0  %等于零，意味着，没有处理任务，所以没有车辆离开
                continue;
            end  
            if strcmp(event{e},'D3')&&s{row,2}(3)==0
                continue;
            end               
            if strcmp(event{e},'D4')&&s{row,2}(4)==0  %等于零，意味着，没有处理任务，所以没有车辆离开
                continue;
            end  
            
            %当i1/2/3为0时，没有事件L1/L2/L3，去除这些状态(除去非法状态)   % 由车载云产生的
            if strcmp(event{e},'L1')&&s{row,3}(1)==0
                continue;
            end
            if strcmp(event{e},'L2')&&s{row,3}(2)==0
                continue;
            end  
            if strcmp(event{e},'L3')&&s{row,3}(3)==0
                continue;
            end               
            
            if s{row,1}<=1&&strcmp(event{e},'F-1') % 保证系同车载云中，至少有一辆车
                 continue;
            end
                        
            %M=K时，没有事件F+1
            if s{row,1}==K && strcmp(event{e},'F+1')
                 continue;
            end          
            
            
            s{row,4} = event{e};
            row = row + 1;
            end
         end
        end
       end
      end
     end
   end %s4
  end  %s3
 end  %s2
end %s1 
