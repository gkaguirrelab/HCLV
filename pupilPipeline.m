function pupilPipeline (params, mainDir)
% This function is a wrapper to run the full pupilTrack pipeline for a
% single video. 
% The deinterlace step is optional, as the cluster is not able to process
% .mov videos. All deinterlaced video should be saved as .avi

% Note: contains internal params for each step where required.

%  Usage:
% %% Set cluster directory
% mainDir= '/data/jag';
% %% Set initial params
% % run params
% params.subjectName = 'TOME_3000';
% params.sessionDate = '103116';
% params.runName = 'tfMRI_FLASH_AP_run01';
% params.deinterlace = 1;
%
% tracking params
% params.ellipseThresh = [0.95 0.9]
% 
% 
% % project params (fixed)
% params.outputDir = 'TOME';
% params.projectFolder = 'TOME';
% params.eyeTrackingDir = 'EyeTracking';
% 
% pupilPipeline (params, mainDir)

%% set outDir
outDir = fullfile(mainDir,params.outputDir, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir);

%% deinterlace
if params.deinterlace == 1
deinterlaceVideo (params, mainDir);
end
%% track with pupilTrack
params.acqRate = 60;
params.inVideo = fullfile(outDir,[params.runName '_60hz.avi']);
params.outVideo = fullfile(outDir,[params.runName '_pupilTrack.avi']);
params.outMat = fullfile(outDir, [params.runName '_pupilTrack.mat']);

[~,~,params] = trackPupil(params);
save(fullfile(outDir,[params.runName '_trackingParams.mat']), 'params');

%% Remove the 60Hz video (it is no longer needed)
delete(params.inVideo);

%% get timeBase and save it
params.ltRes = [320 240]; % resolution of the LiveTrack video (half original size)
params.ptRes = [320 240]; % resolution of the pupilTrack video
params.ltThr = 0.1; % threshold for liveTrack glint position
params.pupilTrackFile = params.outMat;

[timeBase] = getPupilTimebase(params,mainDir);
save(fullfile(outDir,[params.runName '_timeBase.mat']), 'timeBase');

%% Save params for this analysis
save(fullfile(outDir, [params.runName '_params.mat']), 'params');




