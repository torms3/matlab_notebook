function data = compare_multi_gpu( w )

    phase = 'test';
    keys  = {'iter','affinity'};
    fname = 'stats300000.h5';

    % Statistics.
    gpu{1} = load_stats(['data/gpu1_' fname], phase, keys);
    gpu{2} = load_stats(['data/gpu2_' fname], phase, keys);
    gpu{3} = load_stats(['data/gpu3_' fname], phase, keys);
    gpu{4} = load_stats(['data/gpu4_' fname], phase, keys);

    % Elapsed.
    elapsed = [0.5179, 0.5314, 0.5443, 0.5621];
    cost = elapsed./elapsed(1);

    % Plot.
    hold on;
    for i = 1:4
        x = gpu{i}.iter;
        y = movmean(gpu{i}.affinity,w);
        h = plot(x,y);
        h.LineWidth = 1;
        gpu{i}.x = x;
        gpu{i}.y = y;
    end
    hold off;

    % Decorations.
    set(gca,'FontSize',16);
    title('Multi-GPU training');
    legend({'gpu1','gpu2','gpu3','gpu4'});
    xlabel('Iterations');
    ylabel('Loss');
    grid on;
    % grid minor;
    ylim([0.183 0.22]);

    % Minimum.
    for i = 1:4
        [val,idx] = min(gpu{i}.y);
        iter = gpu{i}.iter(idx);
        fprintf('gpu %d: min loss = %.3f @ %d\n',i,val,iter);
    end

    % Analysis.
    losses = 0.220:-0.001:0.186;
    data = zeros(4,numel(losses));
    for j = 1:numel(losses)
        for i = 1:4
            k = find(gpu{i}.y < losses(j));
            data(i,j) = gpu{i}.x(k(1));
        end
    end

    % Cost.
    disp('[relative cost]');
    disp(cost);

    % Speed-up (iteration).
    disp('[relative speed-up (iteration)]');
    data_iter = repmat(data(1,:),4,1)./data;
    speedup_iter = geomean(data_iter,2);
    disp(speedup_iter');

    % Speed-up (wall clock).
    disp('[relative speed-up (wall clock)]');
    data_wall = data.*repmat(cost(:),1,size(data,2));
    data_wall = repmat(data_wall(1,:),4,1)./data_wall;
    speedup_wall = geomean(data_wall,2);
    disp(speedup_wall');

end
