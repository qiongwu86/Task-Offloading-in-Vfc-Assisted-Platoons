function [s] = initial_state_platoon(K)

% �����ô������ӳ�������������ֻ��Ҫ�������Ƴ�������
%K=10;
%s = {0,[0,0,0],' '};
%s = {0,[0,0],[0,0],' '};
s = {0, [0,0,0,0], [0,0,0], ' '};
% s{row,1} = M��s{row,2}(1) = s1;s{row,2}(2) = s2;s{row,2}(3) = s3��
% s{row,3}(1) = i1;s{row,3}(2) = i2;s{row,3}(3) = i3;
% s{row,4}=event;  s{row,5} = s{row,1} - (1*i1+2*i2+3*i3);
% D11��1��RU�����A1���ȼ������뿪
event = {'A';'D1';'D2';'D3';'D4';'L1';'L2';'L3';'F+1';'F-1'};
row = 1;

for s1 = 0:1      %����ͷ����״̬��Ϊ1��ʾΪæµ����
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
            s{row,2}(1) = s1; % ˵���������
            s{row,2}(2) = s2;
            s{row,2}(3) = s3;
            s{row,2}(4) = s4;         
                       
            s{row,3}(1) = i1;% �����Ʒ������
            s{row,3}(2) = i2;
            s{row,3}(3) = i3;
            
            s{row,5} = s{row,1} - (1*i1+2*i2+3*i3); %ʣ����Դ
            
       
            %��s1/2/3Ϊ0ʱ��û���¼�D1/D2/D3��ȥ����Щ״̬(��ȥ�Ƿ�״̬)   % �ɳ��ӳ�Ա���䵼�µ�
            if strcmp(event{e},'D1')&&s{row,2}(1)==0
                continue;
            end
            if strcmp(event{e},'D2')&&s{row,2}(2)==0  %�����㣬��ζ�ţ�û�д�����������û�г����뿪
                continue;
            end  
            if strcmp(event{e},'D3')&&s{row,2}(3)==0
                continue;
            end               
            if strcmp(event{e},'D4')&&s{row,2}(4)==0  %�����㣬��ζ�ţ�û�д�����������û�г����뿪
                continue;
            end  
            
            %��i1/2/3Ϊ0ʱ��û���¼�L1/L2/L3��ȥ����Щ״̬(��ȥ�Ƿ�״̬)   % �ɳ����Ʋ�����
            if strcmp(event{e},'L1')&&s{row,3}(1)==0
                continue;
            end
            if strcmp(event{e},'L2')&&s{row,3}(2)==0
                continue;
            end  
            if strcmp(event{e},'L3')&&s{row,3}(3)==0
                continue;
            end               
            
            if s{row,1}<=1&&strcmp(event{e},'F-1') % ��֤ϵͬ�������У�������һ����
                 continue;
            end
                        
            %M=Kʱ��û���¼�F+1
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
