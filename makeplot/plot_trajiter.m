if t == 1
    % Define color map
    map = [1,1,1;   % white - 1
           1,0,0;   % red - 2
           0,1,0;   % green - 3
           0,0,1;   % blue - 4
           1,1,0];  % yellow - 5

    %% create the field
    C = ones(5);
    C(1,1) = 5;
    C(5,5) = 3;
    C(5,1) = 2;
    C(1,4) = 4;
    figure(401)
    hold on;
    % the field
    image(0.5, 0.5, C);
    colormap(map)
    % add walls
    line([1,1],[0,2],'LineWidth',8, 'Color', 'k')
    line([2,2],[3,5],'LineWidth',8, 'Color', 'k')
    line([3,3],[0,2],'LineWidth',8, 'Color', 'k')
    % axes
    limx = [0,5];
    limy = [0,5];
    cleanplot;
    hold off;
else
    delete(ht1); delete(hl);
    if exist('ht3')
        delete(ht3)
    end
end

figure(401)
hold on;
ht1 = text(-1.5, 4.5, ['Iter = ', num2str(t)], 'FontSize', 15);
if t > 1
   ht3(1) =  text(-1.5, 3.5, ['err(1) = ', num2str(err(1), 2)], 'FontSize', 10);
   ht3(2) =  text(-1.5, 3.0, ['err(2) = ', num2str(err(2), 2)], 'FontSize', 10);
   ht3(3) =  text(-1.5, 2.5, ['err(3) = ', num2str(err(3), 2)], 'FontSize', 10);
end
F(t, 1) = getframe(gcf);
% Plot trajectory and agent
for tt = 1 : mdpinstance.maxH
    hm = plot(xu(tt,2)+0.5, xu(tt,1)+0.5, 'ko', 'MarkerFaceColor', ...
        [0,0,0], 'MarkerSize', 20);
    ht2 = text(5.2, 4.5, ['t = ', num2str(tt)], 'FontSize', 15);
    if tt > 1
        hl(tt-1) = line([xu(tt-1,2), xu(tt,2)]+0.5, [xu(tt-1,1), xu(tt,1)]+0.5, ...
            'Color', 'c');
    end
    F(t, tt+1) = getframe(gcf);
    delete(hm); delete(ht2);
    if tt == mdpinstance.maxH
        F(t, tt+2) = getframe(gcf);
    end
end
hold off;

    