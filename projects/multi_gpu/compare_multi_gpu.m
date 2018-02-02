function compare_multi_gpu

    data_dir = '~/Workbench/torms3/Superhuman/code/experiments/round2';
    cd(data_dir);

    phase = 'test';
    keys  = {'iter','affinity'};
    fname = 'stats300000.h5';

    gpu{1} = load_stats(['gpu1/logs/' fname], phase, keys);
    gpu{2} = load_stats(['gpu2/logs/' fname], phase, keys);
    gpu{3} = load_stats(['gpu3/logs/' fname], phase, keys);
    gpu{4} = load_stats(['gpu4/logs/' fname], phase, keys);

    % Plot.
    hold on;
    for i = 1:4
        x = gpu{i}.iter;
        y = gpu{i}.affinity;
        plot(x,y);
    end
    hold off;

    % Decorations.
    xlabel('Iterations');
    ylabel('Loss');
    grid on;

end
