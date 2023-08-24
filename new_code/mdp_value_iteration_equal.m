function [Q, V,policy, iter, cpu_time] = mdp_value_iteration_equal(P, R, discount, epsilon, max_iter, V0)

%% no iterate 
[Q, V, policy] = V3_mdp_bellman_operator_calculateValue_equal(P,0,discount,0);
iter = 0;
cpu_time = cputime;


