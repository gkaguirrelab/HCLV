%% Raw video processing script

%% Set dropboxDir
% Get user name
[~, tmpName]            = system('whoami');
userName                = strtrim(tmpName);
% Set Dropbox directory
dropboxDir                   = ['/Users/' userName '/Dropbox-Aguirre-Brainard-Lab'];

%% Set initial params
% project params
params.outputDir = 'TOME_analysis';
params.projectFolder = 'TOME_data';
params.projectSubfolder = 'session*';
params.subjNaming = 'TOME_3*';
params.eyeTrackingDir = 'EyeTracking';
params.stimuliDir = 'Stimuli';
params.screenSpecsFile = 'TOME_materials/hardwareSpecifications/SC3TScreenSizeMeasurements.mat';
params.unitsFile = 'TOME_materials/hardwareSpecifications/unitsFile.mat';




%% Generate TOMEidx mat file and save it
[reportToProcessCellArray, reportParamsStructArray] = identifyReportsToProcess(dropboxDir,params);
save(fullfile(dropboxDir, params.outputDir, 'TOMEidx'), ...
    'reportToProcessCellArray','reportParamsStructArray');

clear params

%% Giant loop

nSessTypes = size(reportToProcessCellArray,1);
nSubjects = size(reportToProcessCellArray,2);
nSessions = size(reportToProcessCellArray,3);
nRuns = size(reportToProcessCellArray,4);
metaDataCellArray = cell(nSessTypes,nSubjects,nSessions,nRuns);
responseStructCellArray = cell(nSessTypes,nSubjects,nSessions,nRuns);
% Loop through data
for st=3
    for sj=7
        for ss=1:nSessions
            for rr=1:nRuns
                if ~isempty(reportToProcessCellArray{st,sj,ss,rr})
                    params = reportParamsStructArray{st,sj,ss,rr};
                    
                    % set outDir
                    outDir = fullfile(dropboxDir,params.outputDir, params.projectSubfolder, ...
                        params.subjectName,params.sessionDate,params.eyeTrackingDir);
                    
                    % deinterlace
                    deinterlaceVideo (params, dropboxDir);
                    
                    % track with pupilTrack
                    params.acqRate = 60;
                    params.inVideo = fullfile(outDir,[params.runName '_60hz.avi']);
                    params.outVideo = fullfile(outDir,[params.runName '_pupilTrack.avi']);
                    params.outMat = fullfile(outDir, [params.runName '_pupilTrack.mat']);
                    [pupil,glint] = trackPupil(params);
                    
                    % get timeBase and save it
                    params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
                    params.ptRes = [400 300]; % resolution of the pupilTrack video
                    params.ltThr = 0.1; % threshold for liveTrack glint position
                    params.pupilTrackFile = params.outMat;
                    [timeBase] = getPupilTimebase(params,dropboxDir);
                    save(fullfile(outDir,[params.runName '_timeBase.mat']), 'timeBase');
                    
                    % also save params for this analysis
                    save(fullfile(outdir, [params.runName '_params.mat']), 'params');
                    clear params
                end
            end
        end
    end
end