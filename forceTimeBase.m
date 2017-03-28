%% FORCE TIMEBASE
% this script can be run to force the timebase on all subjects run, after
% any given issue resulting from the sanity check has been resolved.


%% Set Dropbox directory
%get hostname (for melchior's special dropbox folder settings)
[~,hostname] = system('hostname');
hostname = strtrim(lower(hostname));
if strcmp(hostname,'melchior.uphs.upenn.edu');
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

%% TOME_3001 - session 1 - Force Timebase
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3001';
params.sessionDate = '081916';
clusterSessionDate = '081916a';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
        params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3001 - session 2 - FORCE TIMEBASE
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3001';
params.sessionDate = '081916';
clusterSessionDate = '081916b';


runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end
%% TOME_3002 - session 1 - Force TimeBase
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3002';
params.sessionDate = '082616';
clusterSessionDate = '082616a';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end
%% TOME_3002 - session 1 - Force TimeBase
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3002';
params.sessionDate = '082616';
clusterSessionDate = '082616a';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3002 - session 2 - Force TimeBase
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3002';
params.sessionDate = '082616';
clusterSessionDate = '082616b';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3003 - session 1 - Force TimeBase
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3003';
params.sessionDate = '090216';
clusterSessionDate = '090216';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
        params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3003 - session 2 - Force TimeBase
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3003';
params.sessionDate = '091616';
clusterSessionDate = '091616';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3004 - session 1 (partial) - Force TimeBase
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3004';
params.sessionDate = '091916';
clusterSessionDate = '091916';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3004 - session 1 (partial) - Force TimeBase
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3004';
params.sessionDate = '101416';
clusterSessionDate = '101416b';


runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3004 - session 2 - Force TimeBase
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3004';
params.sessionDate = '101416';
clusterSessionDate = '101416a';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3005 - session 1 - Force TimeBase
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3005';
params.sessionDate = '092316';
clusterSessionDate = '092316';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3005 - session 2 - Force TimeBase
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3005';
params.sessionDate = '100316';
clusterSessionDate = '100316';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3007 - session 1 - Force TimeBase
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3007';
params.sessionDate = '101116';
clusterSessionDate = '101116';


runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3007 - session 2 - Force TimeBase
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3007';
params.sessionDate = '101716';
clusterSessionDate = '101716';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3008 - session 1 - Force TimeBase
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3008';
params.sessionDate = '102116';
clusterSessionDate = '102116';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end
%% TOME_3008 - session 2 - Force TimeBase
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3008';
params.sessionDate = '103116';
clusterSessionDate = '103116';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3009 - session 1 - Force TimeBase
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3009';
params.sessionDate = '100716';
clusterSessionDate = '100716';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3009 - session 2 - Force timeBase
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3009';
params.sessionDate = '102516';
clusterSessionDate = '102516';


runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
        params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3011 - session 1 - force TimeBase
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3011';
params.sessionDate = '111116';
clusterSessionDate = '111116';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3013 - session 1 - Force TimeBase
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3013';
params.sessionDate = '121216';
clusterSessionDate = '121216';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end

%% TOME_3013 - session 2 - Force TimeBase
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3013';
params.sessionDate = '011117';
clusterSessionDate = '011117';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end


%% TOME_3014 - session 2 - Force TimeBase
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3014';
params.sessionDate = '021717';
clusterSessionDate = '021717';

runs = dir(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_pupilTrack.mat'))
        params.runName = runs(rr).name(1:end-15); %runs
        params.ltRes = [360 240]; % resolution of the LiveTrack video (half original size)
        params.ptRes = [400 300]; % resolution of the pupilTrack video
        params.acqRate = 60;
        params.ltThr = 0.1;
         params.reportSanityCheck = 0;
        [timeBase] = getPupilTimebase(params,dropboxDir);
%         if ~exist(fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
%             params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']),'file')
        save (fullfile(dropboxDir, params.outputDir, params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '_timeBase.mat']), 'timeBase')
%         end
        clear timeBase
    else
        continue
    end
end