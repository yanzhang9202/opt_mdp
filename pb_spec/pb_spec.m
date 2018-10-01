%% Optimization specification
opt_param.maxH = 15;
switch pb_type
    case 1
        opt_param.Q = zeros(opt_param.maxH*2);
        opt_param.Q(1:6, 1:6) = eye(6)*1;
    otherwise
end

%% MDP specification
gen_instance;