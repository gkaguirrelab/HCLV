% local eyetracking

%% Set initial params - EVALUATE ALWAYS BEFORE PROCEEDING

% Set Dropbox directory
%get hostname (for melchior's special dropbox folder settings)
[~,hostname] = system('hostname');
hostname = strtrim(lower(hostname));
if strcmp(hostname,'melchior.uphs.upenn.edu')
    dropboxDir = '/Volumes/Bay_2_data/giulia/Dropbox-Aguirre-Brainard-Lab';
else
    % Get user name
    [~, tmpName] = system('whoami');
    userName = strtrim(tmpName);
    dropboxDir = ['/Users/' userName '/Dropbox-Aguirre-Brainard-Lab'];
end

% Set Cluster dir
clusterDir = '/data/jag/TOME'; %cluster must be mounted!


% for eye tracking
params.projectFolder = 'TOME_data';
params.outputDir = 'TOME_processing';
params.eyeTrackingDir = 'EyeTracking';
params.analysisDir = 'TOME_analysis';



%% TOME_3012 make up session 1
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3012';
params.sessionDate = '021017';
clusterSessionDate = '021017';

% all local
% set outDir
outDir = fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir);

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*60hz.avi'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    %get the run name
    params.runName = runs(rr).name(1:end-9); %runs
    if regexp(runs(rr).name, regexptranslate('wildcard','*Cal*'))
        continue
    else
        % track with pupilTrack
        params.acqRate = 60;
        params.inVideo = fullfile(outDir,[params.runName '_60hz.avi']);
        params.outVideo = fullfile(outDir,[params.runName '_pupilTrack.avi']);
        params.outMat = fullfile(outDir, [params.runName '_pupilTrack.mat']);
        
        [~,~,params] = trackPupil(params);
        save(fullfile(outDir,[params.runName '_trackingParams.mat']), 'params');
        % get timeBase and save it
        params.ltRes = [320 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [320 240]; % resolution of the pupilTrack video
        params.ltThr = 0.1; % threshold for liveTrack glint position
        params.pupilTrackFile = params.outMat;
        
        [timeBase] = getPupilTimebase(params,mainDir);
        save(fullfile(outDir,[params.runName '_timeBase.mat']), 'timeBase');
        
        % Save params for this analysis
        save(fullfile(outDir, [params.runName '_params.mat']), 'params');
        
        
    end
end

%% TOME_3011 session 2
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3011';
params.sessionDate = '012017';
clusterSessionDate = '012017';

% all local
% set outDir
outDir = fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir);

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*60hz.avi'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    %get the run name
    params.runName = runs(rr).name(1:end-9); %runs
    if regexp(runs(rr).name, regexptranslate('wildcard','*Cal*'))
        continue
    else
        % track with pupilTrack
        params.acqRate = 60;
        params.inVideo = fullfile(outDir,[params.runName '_60hz.avi']);
        params.outVideo = fullfile(outDir,[params.runName '_pupilTrack.avi']);
        params.outMat = fullfile(outDir, [params.runName '_pupilTrack.mat']);
        
        [~,~,params] = trackPupil(params);
        save(fullfile(outDir,[params.runName '_trackingParams.mat']), 'params');
        % get timeBase and save it
        params.ltRes = [320 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [320 240]; % resolution of the pupilTrack video
        params.ltThr = 0.1; % threshold for liveTrack glint position
        params.pupilTrackFile = params.outMat;
        
        [timeBase] = getPupilTimebase(params,mainDir);
        save(fullfile(outDir,[params.runName '_timeBase.mat']), 'timeBase');
        
        % Save params for this analysis
        save(fullfile(outDir, [params.runName '_params.mat']), 'params');
        
        
    end
end