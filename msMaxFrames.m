function [ out] = msMaxFrames( ms, frames, filtering)
%MSMAXFRAMES Summary of this function goes here
%   Detailed explanation goes here

%Parameters
filtering_factor = 2;

meanFrame = ms.meanFrame{ms.selectedAlignment};

max_mean_frame = median(median(meanFrame));

[rows, columns] = size(meanFrame);

max_projection = zeros(rows,columns);

for frame_i = 1:length(frames);
    current_frame = msReadFrame(ms,frames(frame_i),1, 1, 0);

        if filtering
        current_frame = medfilt2(current_frame,[filtering_factor filtering_factor]);
        end
        
        bkg_sub_current_frame = current_frame - meanFrame;
        
        for i = 1:rows;

            for j = 1:columns;
                pixel_diff = abs(bkg_sub_current_frame(i,j)/max_projection(i,j));
                if pixel_diff > 1;
                    if bkg_sub_current_frame(i,j) > max_mean_frame;
                    max_projection(i,j) = bkg_sub_current_frame(i,j);
                    end
                end
            end
        
        end
end

% Post-processing
max_projection = max_projection+abs(min(min(max_projection))); % Offset correction
max_projection = max_projection/max(max(max_projection))*255; % Scaling

figure
imagesc(max_projection);
colormap gray

out.maxFrame = max_projection;



%imwrite(mat2gray(max_projection),'max_projection.tif')

end

