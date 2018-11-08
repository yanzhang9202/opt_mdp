% Initialize local solutions
global use_ref mdpsolver
use_ref = 0;
% Initialize the trajectory variable
switch mdpsolver
    case 0
        [xu, ~, ~] = solver_mdp_alpha([], mdpinstance, 0);
    case 1
        [xu] = solver_mdp_Astar([], mdpinstance, 0);
end
x1(:, 1) = reshape(xu(:, 1:2)', [], 1);
% x2(:,1) = zeros();    % Suppose optimization algorithm knows nothing
                        % about the environment or goals
tau = adal.tau;
rho = adal.rho;
use_ref = 1;
for t = 1 : adal.maxIter
    % display iter info
    if gverbose
        fprintf(['\n\n This is the ', num2str(t), ' th iter... \n\n'])
    end
    % plot the trajectory planned by MDP during iterations
    if plot_traj_iter && mod(t, 1) == 0
        if t == 1, clear F; end
        plot_trajiter;
    end    
    % solves mdp according to ref
    ref_t = x2(:,t) - lambda/rho;
    ref_t = reshape(ref_t, 2, [])';

    switch mdpsolver
        case 0
            [xu, ~, ~] = solver_mdp_alpha(...
                [ref_t, zeros(size(ref_t,1), 1)], mdpinstance, rho/2);
        case 1
            [xu] = solver_mdp_Astar(...
                [ref_t, zeros(size(ref_t,1), 1)], mdpinstance, rho/2);
    end
    x1_itr = xu(:, 1:2);

    % solves opt according to x1_t
    [x2_itr, ~] = ...
        solver_opt(x1(:,t), lambda, rho, opt_param);
    
    % update local solutions
    x1(:, t+1) = x1(:, t) + ...
        tau * (reshape(x1_itr', [], 1) - x1(:, t));
    x2(:, t+1) = x2(:, t) + tau * (x2_itr - x2(:, t));
    
    % update the multiplier
    lambda = lambda + tau*rho*(x1(:, t+1) - x2(:, t+1));
    
    % check stop condition
    err(1) = norm(x1(:, t+1) - x2(:, t+1));
    err(2) = norm(reshape(x1_itr', [], 1) - x1(:, t));
    err(3) = norm(x2_itr - x2(:, t));
    if max(err) < adal.epsilon
        fprintf(['ADAL succeeds at the ', num2str(t), ' th iter.', ...
            ' with accuracy ', num2str(max(err)), '.\n'])
        break
    else
        if gverbose && mod(t, 5) == 1
            fprintf(['ADAL iter ', num2str(t), ': the current accuracy', ...
                ' is ', num2str(err), '...\n'])
        end      
    end
end
if err > adal.epsilon
    fprintf(['ADAL fails with accuracy ', num2str(err), '.\n'])    
end

clear tau rho