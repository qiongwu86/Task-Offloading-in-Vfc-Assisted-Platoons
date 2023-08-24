%   求解，某一动作下，转移到各个状态的概率 * 各个状态的价值函数；为求：在一个状态下，采取一个动作，所获得值函数求解铺垫
function [V_8next,s_next] = find_index_platoon(s,i,s_next,N,pp,pp_unif,V_old,flag1)

if flag1==1  % 有回到自身的状态
    Ls=length(s_next)-1;
else
    Ls=length(s_next);
end

V_8next = zeros(Ls,1);   
                
                %   对所有的下一个状态遍历一遍，寻找下一个状态的索引
                for y = 1: Ls   
                    flag = 0;     %找到下个状态的索引后flag置1
                    for nn = 1: N
                        if s{nn,2}(1)==s_next{y,2}(1) && s{nn,2}(2)==s_next{y,2}(2) && s{nn,2}(3)==s_next{y,2}(3)&& s{nn,2}(4)==s_next{y,2}(4) && s{nn,3}(1)==s_next{y,3}(1) && s{nn,3}(2)==s_next{y,3}(2) && s{nn,3}(3)==s_next{y,3}(3)
                            if s{nn,1}==s_next{y,1}&&strcmp(s{nn,4}, s_next{y,4})%事件
                                s_next_index = nn;
                                s_next{y,7} = s_next_index;
                                flag = 1;
                                break;%跳出一次循环
                            end
                        end
                    end %% 找的索引是否唯一对应？？？
                    
                    
                    if flag == 0 && pp(y)~=0    %如果遍历后没有找到下个状态索引，就报错
                        fprintf('初始状态是第 %d 个\n',i);
                        fprintf('下个状态的第 %d 个\n',y);
                        disp('没有找到下个状态的索引！！！');
                        disp('************************');
                    end
                    
                    if flag ==1
                        V_8next(y) = pp_unif(y)*V_old(s_next_index);    % 下一个状态  *  下一个状态的旧值函数
                    else
                        V_8next(y) = 0;
                    end
                    s_next{y,8} = pp_unif(y,1);
                end