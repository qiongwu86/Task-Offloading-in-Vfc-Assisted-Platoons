function [Q, V,policy, iter, cpu_time] = mdp_value_iteration_GA(P, R, discount, epsilon, max_iter, V0)

cpu_time = cputime;

%% check of arguments
if iscell(P)    
    S = size(P{1},1); 
else
    S = size(P,1);
end

PR = mdp_computePR(P,R);    %PR = R

%% initialization of optional arguments
if nargin < 6 
    V0 = zeros(S,1); 
end

if nargin < 4
    epsilon = 0.01; 
end

%% compute a bound for the number of iterations
if discount ~= 1
   computed_max_iter = mdp_value_iteration_bound_iter(P, R, discount, epsilon, V0);
end   
if nargin < 5
    if discount ~= 1
        max_iter = computed_max_iter;     % 不执行
    else
        max_iter = 1000;
    end
else
    if discount ~= 1 && max_iter > computed_max_iter
        max_iter = computed_max_iter;
    end
end

%% computation of threshold of variation for V for an epsilon-optimal policy
if discount ~= 1
    thresh = epsilon * (1-discount)/2*discount;
else 
    thresh = epsilon;
end

iter = 0;
V = V0;
K = 4;
is_done = false;

%% iterate start
while ~is_done
    iter = iter + 1;
    Vprev = V;
    [Q, V, policy] = V3_mdp_bellman_operator_calculateValue(P,PR,discount,V);

    variation = sum(abs(V-Vprev))/S;
    if variation < thresh || iter == max_iter
        is_done = true; 
    end
end

%% greedy change policy
for i = 1:S        % 对所有状态遍历
    if (policy(i,1) >= 7)  % 贪婪,动作7、8、9都是卸载到VFC
        j = 9;% 先检查动作9，动作9即拆成3个
        while j > 6
            if Q(i,j) ~= 0 %  
                V(i,1) = Q(i,j);
                policy(i,1) = j;
                break;
            end
            j = j-1;
        end            
    end       % 贪婪     
end
