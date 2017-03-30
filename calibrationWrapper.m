function calibrationWrapper (dropboxDir, params)
%% as default, track gaze videos

if ~isfield(params,'trackGazeVideos')
    params.trackGazeVideos = 1;
end


%% find all calTrack files


LTruns = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*LTdat.mat'));

rawVids = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*rawVidStart.mat'));



%% track
if params.trackGazeVideos
    for rr = 1 :length(LTruns) %loop in all files
        fprintf ('\nProcessing calibration %d of %d\n',rr,length(LTruns))
        %get the run name
        params.calName = LTruns(rr).name(1:end-10); %runs
        outDir = fullfile(dropboxDir,'TOME_processing',params.projectSubfolder,params.subjectName,params.sessionDate,'EyeTracking');
        params.acqRate = 60;
        params.pupilFit = 'bestPupilCut';
%         params.pupilFit = 'circle';
        params.inVideo = fullfile(outDir,[params.calName '_60hz.avi']);
        params.outVideo = fullfile(outDir,[params.calName '_calTrack.avi']);
        params.outMat = fullfile(outDir, [params.calName '_calTrack.mat']);
        params.dilateGlint  = 5;
        params.cutPupil = 0;
        params.pupilRange   = [5 60];
        params.glintRange   = [2 20];
        warning('off','all')
        trackPupil(params);
        warning('on','all')
    end
end

%% calibrate

runs = dir(fullfile(dropboxDir, 'TOME_processing', params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'GazeCal*_calTrack.mat'));
for rr = 1 :length(runs) %loop in all files
fprintf ('\nProcessing calibration %d of %d\n',rr,length(runs))
    %get the run name
    params.calName = LTruns(rr).name(1:end-10); %runs
    params.trackedData = fullfile(runs(rr).folder, runs(rr).name);
    params.LTcal = fullfile(LTruns(rr).folder, LTruns(rr).name);
    params.rawVidStart = fullfile(rawVids(rr).folder, rawVids(rr).name);
    
    calParams = calibrateGaze (dropboxDir,params);
    
    save(fullfile(dropboxDir, 'TOME_processing', params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.calName '_calParams.mat']), 'calParams'); 

end
    



