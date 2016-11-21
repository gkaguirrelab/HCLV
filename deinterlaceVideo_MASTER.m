%% deinterlacing master script
% For every new session acquired, a new cell is added. This script serves
% also as a log of what has already been deinterlaced.

% REMEMBER TO PAUSE DROPBOX SINCYING WHILE THIS IS RUNNING.

% Example of new cell to add

% % %% TOME_300X Session X
% % params.projectFolder = 'Session1';
% % params.subjectName = 'TOME_3001';
% % params.sessionDate = ' '
% % 
% % runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
% %     params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
% % for rr = 1 :length(runs) %loop in runs
% %     params.runName = runs(rr).name(1:end-11);
% %     deinterlaceVideo (params, dropboxDir)
% %     movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
% %     params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
% %     fullfile(clusterDir,params.subjectName,params.sessionDate,params.eyeTrackingDir)) 
% % end

% % %  After deinterlacing is done, run pupil track pipeline on the cluster

%% Set paths and initial params
% Get user name
[~, tmpName]            = system('whoami');
userName                = strtrim(tmpName);
% Set Dropbox directory
dropboxDir                   = ['/Users/' userName '/Dropbox-Aguirre-Brainard-Lab'];
% Set Cluster dir
clusterDir = '/data/jag/TOME'; %cluster must be mounted!

% project params
params.projectFolder = 'TOME_data';
params.outputDir = 'TOME_analysis';
params.eyeTrackingDir = 'EyeTracking';




%% TOME_3001 Session 1
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3001';
params.sessionDate = '081916';
clusterSessionDate = '081916a';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir)) 
end
clear('runs')
%% TOME_3001 Session 2

params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3001';
params.sessionDate = '081916';
clusterSessionDate = '081916b';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
        params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
        fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
end
%% TOME_3002 Session 1
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3002';
params.sessionDate = '082616';
clusterSessionDate = '082616a';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir)) 
end

%% TOME_3002 Session 2
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3002';
params.sessionDate = '082616';
clusterSessionDate = '082616b';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir)) 
end

%% TOME_3003 Session 1
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3003';
params.sessionDate = '090216';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,params.sessionDate,params.eyeTrackingDir)) 
end

%% TOME_3003 Session 2

params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3003';
params.sessionDate = '091616';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,params.sessionDate,params.eyeTrackingDir)) 
end


%% TOME_3004 Session 1 (partial)
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3004';
params.sessionDate = '091916';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,params.sessionDate,params.eyeTrackingDir)) 
end

%% TOME_3004 Session 1 (partial)
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3004';
params.sessionDate = '101416';
clusterSessionDate = '101416a';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir)) 
end

%% TOME_3004 Session 2

params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3004';
params.sessionDate = '101416';
clusterSessionDate = '101416b';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir)) 
end

%% TOME_3005 Session 1
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3005';
params.sessionDate = '092316';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,params.sessionDate,params.eyeTrackingDir)) 
end

%% TOME_3005 Session 2

params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3005';
params.sessionDate = '100316';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,params.sessionDate,params.eyeTrackingDir)) 
end

%% TOME_3007 Session 1
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3007';
params.sessionDate = '101116';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,params.sessionDate,params.eyeTrackingDir)) 
end

%% TOME_3007 Session 2

params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3007';
params.sessionDate = '101716';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,params.sessionDate,params.eyeTrackingDir)) 
end

%% TOME_3008 Session 1
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3008';
params.sessionDate = '102116';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,params.sessionDate,params.eyeTrackingDir)) 
end

%% TOME_3008 Session 2

params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3008';
params.sessionDate = '103116';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,params.sessionDate,params.eyeTrackingDir)) 
end

%% TOME_3009 Session 1
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3009';
params.sessionDate = '100716';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,params.sessionDate,params.eyeTrackingDir)) 
end

%% TOME_3009 Session 2

params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3009';
params.sessionDate = '102516';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,params.sessionDate,params.eyeTrackingDir)) 
end

%% TOME_3011 Session 1
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3011';
params.sessionDate = '111116';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*report.mat'));
for rr = 1 :length(runs) %loop in runs
    params.runName = runs(rr).name(1:end-11);
    deinterlaceVideo (params, dropboxDir)
    movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
    fullfile(clusterDir,params.subjectName,params.sessionDate,params.eyeTrackingDir)) 
end



