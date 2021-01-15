%% msBatchRun2018
% Version 1.0 GE
% Updated version of the msBatchRun script originally proposed by Daniel B
% Aharoni to analyse miniscope 1p calcium imaging data on large batches of
% data.
% This version is build on top of the original package to maximize compatibility.
% It includes NormCorre for image registration, CNMF-E for source extraction,
% and CellReg for chronic registration across sessions. It also includes
% custom written scripts to explore the data (eg spatial firing, transients
% properties visualization).
% Usage: for each line in msBatchFileList, enter the path (as is, not as a string with the '') pointing to
% folders to be analyzed.

% Copyright (C) 2017-2018 by Guillaume Etter
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or any
% later version.

%% Auto-detect operating system
if ispc
    separator = '\'; % For pc operating systems
else
    separator = '/'; % For unix (mac, linux) operating systems
end

%% Create list of files to process
file_list_container = fopen('msBatchFileList.m');
file_list = [];
current_line = fgetl(file_list_container);
while ischar(current_line);
    disp(current_line);
    file_list{end+1} = current_line;
    current_line = fgetl(file_list_container);
end
fclose(file_list_container);

%% Parameters
spatial_downsampling = 2; % (Recommended range: 2 - 4. Downsampling significantly increases computational speed
isnonrigid = false; % If true, performs non-rigid registration (slower). If false, rigid alignment (faster).
analyse_behavior = false;
copy_to_googledrive = true;
if copy_to_googledrive;
    copydirpath = uigetdir([],'Please select the root folder in which files will be copied');
end

for folder_i = 1:length(file_list);
    clear ms;
    %% Here starts the regular msRun2018 for each file
    % Generate timestamp to save analysis
    script_start = tic;
    analysis_time =strcat(date,'_', num2str(hour(now)),'-',num2str(minute(now)),'-',num2str(floor(second(now))));
    
    %% 1 - Create video object and save into matfile
    display('Step 1: Create video object');
    ms = msGenerateVideoObj(file_list{folder_i},'msCam');
    ms.analysis_time = analysis_time;
    ms.ds = spatial_downsampling;
    mkdir(strcat(ms.dirName,'/',analysis_time));
    save([ms.dirName separator,analysis_time separator 'ms.mat'],'ms');
    
    %% 2 - Motion correction (using NormCorre)
    display('Step 2: Motion correction');
    ms = msNormCorre(ms,isnonrigid);
    
    %% 3 - Source extraction (using CNMFE)
    display('Step 3: Source extraction');
    ms = msRunCNMFE_large(ms);
    msExtractSFPs(ms);
    
    analysis_duration = toc(script_start);
    ms.analysis_duration = analysis_duration;
    
    save([ms.dirName separator 'ms.mat'],'ms','-v7.3');
    disp(['Data analyzed in ' num2str(analysis_duration) 's']);
    
    if copy_to_googledrive;
        destination_path = char(strcat(copydirpath, separator, ms.Experiment));
        mkdir(destination_path);
        copyfile([ms.dirName separator 'ms.mat'], [destination_path separator 'ms.mat']);
        copyfile([ms.dirName separator 'SFP.mat'], [destination_path separator 'SFP.mat']);
        try % This is to attempt to copy an existing behav file if you already analyzed it in the past
            copyfile([ms.dirName separator 'behav.mat'], [destination_path separator 'behav.mat']);
        catch
            disp('Behavior not analyzed yet. No files will be copied.');
        end
        disp('Successfully copied ms and SFP files to GoogleDrive');
    end
    
    %% 4 - Cleanup temporary files
    rmdir([ms.dirName separator ms.analysis_time], 's'); % Comment this if you want to keep the intermediate results/videos
    
end

%% 5 - Analyse all the behavioral data altogether
if analyse_behavior;
    for folder_i = 1:length(file_list);
        behav = msGenerateVideoObj(file_list{folder_i},'behavCam');
        behav = msSelectPropsForTracking(behav);
        trackLength = 95;%cm
        behav = msExtractBehavoir(behav, trackLength);
        save([ms.dirName separator 'behav.mat'],'behav','-v7.3');
        
        if copy_to_googledrive;
            destination_path = char(strcat(copydirpath, separator, ms.Experiment));
            copyfile([ms.dirName separator 'behav.mat'], [destination_path separator 'behav.mat']);
            disp('Successfully copied behav file to GoogleDrive');
        end
    end
end
