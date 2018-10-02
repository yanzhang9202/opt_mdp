%% Optimization specification
opt_param.maxH = maxH;
switch pb_type
    case 1
        % Stop at the intial point for 3 periods
%         opt_param.Q = zeros(opt_param.maxH*2);
%         opt_param.Q(1:6, 1:6) = eye(6)*1;
%         opt_param.f = zeros(opt_param.maxH*2);
        % Track a reference trajectory
        xref = zeros(2, opt_param.maxH);
        xref(:,9:12) = repmat([0;3],1,4);
        Q = zeros(opt_param.maxH*2);
        Q(17:24, 17:24) = eye(8)*1;
        opt_param.Q = Q;
        opt_param.f = -Q*xref(:);
    otherwise
end

%% MDP specification
gen_instance;