function [Q, V, policy] = V3_mdp_bellman_operator_calculateValue_equal(P, PR, discount, Vprev, K)
Q = 0;
V = 0;
policy = randi([1, 9], length(cell2mat(P(1,1))), 1);

end 
