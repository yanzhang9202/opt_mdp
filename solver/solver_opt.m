function [x2, exitflag] = solver_opt(x1, lambda, rho, opt_param)
% Solve the local problem in Opt_MDP framework
Q = opt_param.Q;
H = Q + rho*eye(size(Q));
f = -rho*x1 - lambda;

options = optimoptions('quadprog',...
'Algorithm','interior-point-convex','Display','off');
[x2, ~, exitflag] = ...
    quadprog(H, f, [], [], [], [], [], [], [], options);
if exitflag ~= 1
    error('Local optimization problem cannot be solved!\n')
end

end