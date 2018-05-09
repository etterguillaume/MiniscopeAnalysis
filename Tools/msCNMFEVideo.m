function msCNMFEVideo(ms, cell_ID, frameLimit, downSamp,is_write,is_plot)
%MCNMFEVideo Visualize and/or save video of traces
%   INPUTS:
%   ms: ms structure
%   cell_ID: cell to plot identify (will appear white instead of magenta)
%   frameLimit: vector indicating the first and last frames (eg [10 205]).
%   If left empty, will process the whole recording
%   Downsample: temporal downsampling factor. 1 = no downsampling
%   is_write (logical): if true, will prompt to save a video file
%   is_plot (logical): if true, will plot the video as it's being processed

% Copyright (C) 2017-2018 by Guillaume Etter
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or any
% later version.
% Contact: etterguillaume@gmail.com

if is_write;
    [file,path] = uiputfile('.avi');
    
writerObj = VideoWriter([path '/' file]);
writerObj.FrameRate = 30;
    open(writerObj);
end

    if isempty(frameLimit)
        frameLimit = [1 ms.numFrames];
    end

background = max(ms.SFPs,[],3);

% if cell_ID > 0;
%        perimeter=uint8(bwperim(ms.SFPs(:,:,cell_ID)));
%        perimeter(perimeter>0)= 255;
%        perimeter(:,:,2)=perimeter(:,:,1);
%        perimeter(:,:,3) = 0;
% end

if is_plot;
figure;
end    

traces=ms.RawTraces;
traces = zscore(traces,[],1);
traces(traces<=0)=0;
max_traces = max(traces,[],1);
traces=traces./max_traces*255;

for frame_i=frameLimit(1):downSamp:frameLimit(2);
    frame = zeros(size(ms.CorrProj));
    for seg=1:ms.numNeurons;
    SFP=ms.SFPs(:,:,seg);
    SFP=SFP./max(max(SFP))*traces(frame_i,seg);
    frame = frame + SFP;
    end
        
    frame = imfuse(frame,background,'falsecolor');
    frame = insertText(frame,[size(ms.CorrProj,1)/2 size(ms.CorrProj,2)-20],['Time: ' num2str(ms.time(frame_i)./1000) 's'],'TextColor','white','BoxOpacity',0);
    
%     if cell_ID>0;
%        frame = imadd(frame,perimeter);
%     end
    
    if is_write;
    writeVideo(writerObj,uint8(frame));
    end
    if is_plot;
    imshow(uint8(frame));
    
    title(['Frame ',num2str(frame_i), ' out of ', num2str(frameLimit(2)-frameLimit(1)), '(', num2str(frame_i/(frameLimit(2)-frameLimit(1))*100),'%)', 'Time: ', num2str(floor(frame_i./30)), 's' ]);
    drawnow
    end
end
if is_write;
close(writerObj);
end
end

