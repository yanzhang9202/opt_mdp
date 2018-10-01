%% Problem specification
pb.maxH = 15;
switch pb_type
    case 1
        pb.Q = zeros(pb.maxH*2);
        pb.Q(1:3, 1:3) = eye(3);
    otherwise
end