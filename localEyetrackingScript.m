% local eyetracking script

% used for eyetracking when the standard parameters fail

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



%% TOME_3013 session 2
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3013';
params.sessionDate = '011117';


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
        % pupil track params 
        params.rangeAdjust  = 0.05;         % radius change (+/-) allowed from the previous frame
        params.threshVals   = [0.02 0.999]; % grayscale threshold values for pupil and glint, respectively
        params.imageSize    = [486 720]/2; % used to resize input video
        params.pupilRange   = [20 60];      % initial pupil size range
        params.glintRange   = [10 30];      % constant glint size range
        params.glintOut     = 0.1;          % proportion outside of pupil glint is allowed to be. Higher = more outside
        params.sensitivity  = 0.99;         % [0 1] - sensitivity for 'imfindcircles'. Higher = more circles found
        params.dilateGlint  = 6;            % used to dialate glint. Higher = more dilation.
        params.pupilOnly    = 0;            % if 1, no glint is required
        
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

