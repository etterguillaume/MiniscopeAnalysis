function msPlotAnalysisSummary(ms,behav)
%MSPLOTANALYSISSUMMARY Plot summar of your results
%   This is a quick function to get an overview of your results

% Copyright (C) 2017-2018 by Guillaume Etter
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or any
% later version.
% Contact: etterguillaume@gmail.com

summary_fig = figure('Name',ms.Experiment);
    subplot(3,4,1)
    if isfield(ms, 'meanFrame');
    imagesc(ms.meanFrame);
    daspect([1 1 1]);
    title('Mean frame');
    ax1=gca;
    colormap(ax1, gray);
    end
    
    total_shifts = [];
    for video_i = 1:ms.numFiles
        total_shifts = vertcat(total_shifts,squeeze(cat(3,ms.shifts{video_i}(:).shifts)));
    end
    subplot(3,4,5)
    plot(ms.time/1000,total_shifts(:,1),'color','blue'); hold on;
    plot(ms.time/1000,total_shifts(:,2),'color','red');
    xlabel('Time (s)');
    ylabel('Shifts (pixels)');
    ax5=gca;
    ax5.XLim = [0 ms.time(end)/1000];
    ax5.YLim=[-5 5];
    title('Shifts');
    
    subplot(3,4,9)
    [N,Xedges,Yedges] = histcounts2(total_shifts(:,1),total_shifts(:,2),[-5:0.1:5],[-5:0.1:5]);
    imagesc(Xedges,Yedges,N);
    daspect([1 1 1]);
    ax9=gca;
    colormap(ax9, jet);
    title('Shifts');
    
    subplot(3,4,2)
    imagesc(ms.CorrProj);
    daspect([1 1 1]);
    ax2=gca;
    colormap(ax2, gray);
    title('Correlation');
    
    subplot(3,4,6)
    imagesc(ms.PeakToNoiseProj);
    daspect([1 1 1]);
    ax6=gca;
    colormap(ax6, gray);
    colormap gray
    title('Peak to noise ratio');
    
    subplot(3,4,10)
    imagesc(max(ms.SFPs,[],3));
    daspect([1 1 1]);
    ax10=gca;
    colormap(ax10, gray);
    colormap gray
    title('Spatial footprints');
    
    subplot(3,4,[3 4])
    ax3711=gca;
    if ms.numNeurons >= 50;
        for trace_i = 1:50;
            plot(ms.time/1000,ms.RawTraces(:,trace_i)*1+2*(trace_i-1),'color',[0 0.1 0.5]); hold on;
        end
        ax3711.YLim(2) = max(ms.RawTraces(:,50)*1+2*(50-1));
    else
        for trace_i = 1:ms.numNeurons;
            plot(ms.time/1000,ms.RawTraces(:,trace_i)*1+2*(trace_i-1),'color',[0 0.1 0.5]); hold on;
        end
        ax3711.YLim(2) = max(ms.RawTraces(:,ms.numNeurons)*1+2*(ms.numNeurons-1));
    end
    
    ax3711.XLim = [0 ms.time(end)/1000];
    ax3711.YLim(1) = 0;
    

subplot(3,4,[7 8 11 12])
    % Converting back to pixels
    behav.position(:,1) = behav.position(:,1)*behav.ROI(3)/behav.trackLength;
    behav.position(:,2) = behav.position(:,2)*behav.ROI(3)/behav.trackLength;

imshow(behav.background*2); hold on
plot(behav.position(:,1),behav.position(:,2),'color',[1 1 1 0.3]); hold on;
daspect([1 1 1]);
ax8=gca;
ax8.YDir = 'reverse';

end

