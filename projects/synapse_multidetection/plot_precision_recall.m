function plot_precision_recall( mode )

    if strcmp(mode, 'F1')
        % F1 score
        prec = [91.4, 99.0, 92.2, 91.7];
        rec = [88.9, 95.41, 88.0, 91.7];
    elseif strcmp(mode, 'F1.5')
        % F1.5 score (higher recall)
        prec = [88.6, 94.7, 88.4, 90.0];
        rec = [93.5, 99.1, 91.7, 91.7];
    else
        assert(false);
    end
    
    % Models
    models = {'Synet', 'PSD1', 'multi-PSD1', 'multi-PSD3'};

    figure;
    set(gca, 'fontsize', 16);

    axis equal;
    focus = 80;
    axis([focus 100 focus 100]);
    
    % Colormap.
    clr = colormap('lines');
    clr = clr(1:numel(models),:);
    
    % Operating point
    markersize = 10;
    hold on;
    for i = 1:numel(models)
        color = clr(i,:);
        
        p = prec(i);
        r = rec(i);
        
        h = plot(p,r,'o');
        h.MarkerFaceColor = color;
        h.Color = [0 0 0];
        h.MarkerSize = markersize;
    end
    legend(models,'location','west','AutoUpdate','off');
    hold off;
   
    % F-score isocontour
    isof = @(f,x) (f*x)./(2*x - f);
    
    hold on;
    for i = 1:numel(models)
        color = clr(i,:);
        
        p = prec(i);
        r = rec(i);
        f = (2*p*r)/(p + r);
        
        x = linspace(isof(f,100),100);
        y = isof(f,x);
        h = plot(x,y,':','Color',color);
        h.LineWidth = 1.0;
    end
    hold off;
    
    % Operating point override
    hold on;
    for i = 1:numel(models)
        color = clr(i,:);
        
        p = prec(i);
        r = rec(i);
        
        h = plot(p,r,'o');
        h.MarkerFaceColor = color;
        h.Color = [0 0 0];
        h.MarkerSize = markersize;
        
        offset = 0.5;
        txt = sprintf('%s (%.1fP, %.1fR)',models{i},p,r);
        if strcmp(mode, 'F1.5') && i == 3
            text(p,r-0.6,txt);
        else
            text(p+offset,r+0.05,txt);
        end
    end
    hold off;
    
    box on;
    grid on;
    xlabel('Precision');
    ylabel('Recall');
    title(['Greedy optimization for ' mode ' score']);
    xticks(focus:5:100);
    yticks(focus:5:100);
    
end