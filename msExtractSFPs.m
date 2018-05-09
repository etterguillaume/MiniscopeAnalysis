function msExtractSFPs(ms);
%msExtractSFPs Extracts spatial footprints to perform chronic re-alignment
% Converts spatial footprints from m,k,n (UCLA) to n,m,k (Ziv's lab) where
% n is the number of neurons, k pixels in x axis, and m pixels in y axis
%
% Author: Guillaume Etter
% Contact: etterguillaume@gmail.com

for cell_i = 1:size(ms.SFPs,3);
    SFP_temp = ms.SFPs(:,:,cell_i);
    SFP_temp(SFP_temp<0.5*max(max(SFP_temp))) = 0; % This is to sharpen footprints, based on Ziv lab method
    SFP(cell_i,:,:) = SFP_temp;
end

figure;imagesc(max(permute(SFP,[2 3 1]),[],3));

save([ms.dirName '/SFP.mat'],'SFP','-v7.3');

end

