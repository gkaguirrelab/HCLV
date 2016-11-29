% Master script for processing data in the Human Connectome Low Vision
% (HCLV) project
%
% USAGE
%  This script needs to run LOCALLY, on a machine with write access to
%  /data/jag/TOME . It will make all necessary scripts  for cluster
%  preprocessing of the fMRI data and all necessary files for pupil data
%  processing on the cluster.
%
%  The first cell is always to be evaluated, as it contains parameters
%  and default values for the processing.

%  For every newly acquired session, the following cells need to be added
%  and evaluated:

%%%%%%%%%%%%%%%%%%%%%%%% SESSION 1 TEMPLATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% TOME_30XX - session 1 - PREPROCESSING
% params.subjectName      = 'TOME_30XX';
% clusterSessionDate = 'mmddyy';
%
% params.numRuns          = 4;
% params.reconall         = 1;
%
% params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
% params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
% params.logDir           = logDir;
% params.jobName          = params.subjectName;
% create_preprocessing_scripts(params);
%
% % also run dicom_sort, so that faulty runs can be identified easily
% dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
% warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')
%
% %% Run preprocessing scripts
% 
% %% Run QA after preprocessing
% params.projectSubfolder = 'session1_restAndStructure';
% params.subjectName = 'TOME_3XXX';
% params.sessionDate = 'mmddyy';
% clusterSessionDate = 'mmddyy';
% 
% qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
% qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
%     params.subjectName,params.sessionDate,'PreprocessingQA');
% if ~exist ('qaParams.outDir','dir')
%     mkdir (qaParams.outDir)
% end
% tomeQA(qaParams)
% 
% %% TOME_30XX - session 1 - DEINTERLACE VIDEO
% params.projectSubfolder = 'session1_restAndStructure';
% params.subjectName = 'TOME_30XX';
% params.sessionDate = 'mmddyy';
% clusterSessionDate = 'mmddyy';
%
% runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
%     params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
% for rr = 1 :length(runs) %loop in all video files
%     fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
%     if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
%         params.runName = runs(rr).name(1:end-8); %runs
%     else
%         params.runName = runs(rr).name(1:end-4); %calibrations
%     end
%     deinterlaceVideo (params, dropboxDir)
% end
% % copy over all deinterlaced videos
% fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
% copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
%     params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
%     fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
% fprintf('done!\n')

%%%%%%%%%%%%%%%%%%%%%%%% SESSION 2 TEMPLATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% TOME_30XX - session 2 - PREPROCESSING
%
% params.subjectName = 'TOME_30XX';
% clusterSessionDate = 'mmddyy';
% sessionOneDate = 'mmddyy';
%
%
% params.numRuns          = 10;
% params.reconall         = 0;
%
% params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
% params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
% params.logDir           = logDir;
% params.jobName          = params.subjectName;
% create_preprocessing_scripts(params);
%
% % copy MPRAGE folder from session one
% MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
% if exist ('MPRAGEdir','dir')
%     copyfile(MPRAGEdir, params.sessionDir)
% else
%     warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
% end
%
% % also run dicom_sort, so that faulty runs can be identified easily
% dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
% warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')
%
%
% %% Run preprocessing scripts
% 
% %% Run QA after preprocessing
% params.projectSubfolder = 'session2_spatialStimuli';
% params.subjectName = 'TOME_3XXX';
% params.sessionDate = 'mmddyy';
% clusterSessionDate = 'mmddyy';
% 
% qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
% qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
%     params.subjectName,params.sessionDate,'PreprocessingQA');
% if ~exist ('qaParams.outDir','dir')
%     mkdir (qaParams.outDir)
% end
% tomeQA(qaParams)
% 
% %% TOME_30XX - session 2 - DEINTERLACE VIDEO
% params.projectSubfolder = 'session2_spatialStimuli';
% params.subjectName = 'TOME_30XX';
% params.sessionDate = 'mmddyy';
% clusterSessionDate = 'mmddyy';
%
% runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
%     params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
% for rr = 1 :length(runs) %loop in all video files
%     fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
%     if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
%         params.runName = runs(rr).name(1:end-8); %runs
%     else
%         params.runName = runs(rr).name(1:end-4); %calibrations
%     end
%     deinterlaceVideo (params, dropboxDir)
% end
% % copy over all deinterlaced videos
% fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
% copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
%     params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
%     fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
% fprintf('done!\n')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Written by Andrew S Bock and Giulia Frazzetta Sep 2016

%% fBIRN QA 
% make the fBIRN QA plots
system(['your shell scripts']);
plotFBIRNqa;
%% Set initial params - EVALUATE ALWAYS BEFORE PROCEEDING

% Get user name
[~, tmpName]            = system('whoami');
userName                = strtrim(tmpName);
% Set Dropbox directory
dropboxDir                   = ['/Users/' userName '/Dropbox-Aguirre-Brainard-Lab'];
% Set Cluster dir
clusterDir = '/data/jag/TOME'; %cluster must be mounted!

% for preprocessing
logDir                  = '/data/jag/TOME/LOGS';
params.despike          = 1;
params.slicetiming      = 0;
params.topup            = 1;
params.refvol           = 1;
params.regFirst         = 1;
params.filtType         = 'high';
params.lowHz            = 0.01;
params.highHz           = 0.10;
params.physio           = 1;
params.motion           = 1;
params.task             = 0;
params.localWM          = 1;
params.anat             = 1;
params.amem             = 20;
params.fmem             = 50;

% for pRF scripts
hemis                   = {'lh' 'rh'};
pRFfunc                 = 'wdrf.tf.surf';
params.sigList          = 0.5:0.1:10;

% for eye tracking
params.projectFolder = 'TOME_data';
params.outputDir = 'TOME_processing';
params.eyeTrackingDir = 'EyeTracking';


%% TOME_3001 - session 1 - PREPROCESSING 
params.subjectName      = 'TOME_3001';
clusterSessionDate = '081916a';

params.numRuns          = 4;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3001';
params.sessionDate = '081916';
clusterSessionDate = '081916a';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)
%% TOME_3001 - session 1 - DEINTERLACE VIDEO - DONE
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3001';
params.sessionDate = '081916';
clusterSessionDate = '081916a';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
   deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

%% TOME_3001 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3001';
clusterSessionDate = '081916b';
sessionOneDate = '081916a';

params.numRuns          = 10;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist ('MPRAGEdir','dir')
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3001';
params.sessionDate = '081916';
clusterSessionDate = '081916b';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)
%% TOME_3001 - session 2 - DEINTERLACE VIDEO - DONE
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3001';
params.sessionDate = '081916';
clusterSessionDate = '081916b';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

%% TOME_3002 - session 1 - PREPROCESSING
params.subjectName      = 'TOME_3002';
clusterSessionDate = '082616a';

params.numRuns          = 4;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3002';
params.sessionDate = '082616';
clusterSessionDate = '082616a';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_3002 - session 1 - DEINTERLACE VIDEO - DONE
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3002';
params.sessionDate = '082616';
clusterSessionDate = '082616a';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

%% TOME_3002 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3002';
clusterSessionDate = '082616b';
sessionOneDate = '082616a';

params.numRuns          = 10;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist ('MPRAGEdir','dir')
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3002';
params.sessionDate = '082616';
clusterSessionDate = '082616b';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_3002 - session 2 - DEINTERLACE VIDEO - DONE
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3002';
params.sessionDate = '082616';
clusterSessionDate = '082616b';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

%% TOME_3003 - session 1 - PREPROCESSING
params.subjectName      = 'TOME_3003';
clusterSessionDate = '090216';

params.numRuns          = 4;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3003';
params.sessionDate = '090216';
clusterSessionDate = '090216';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_3003 - session 1 - DEINTERLACE VIDEO - DONE
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3003';
params.sessionDate = '090216';
clusterSessionDate = '090216';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

%% TOME_3003 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3003';
clusterSessionDate = '091616';
sessionOneDate = '090216';


params.numRuns          = 10;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist ('MPRAGEdir','dir')
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3003';
params.sessionDate = '091616';
clusterSessionDate = '091616';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_3003 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3003';
params.sessionDate = '091616';
clusterSessionDate = '091616';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')


%% TOME_3004 - session 1 (partial)- PREPROCESSING
% the last 2 functional runs of this sessions need to be discarded because
% there is no TR information for eyetracking data.

params.subjectName      = 'TOME_3004';
clusterSessionDate = '091916';

params.numRuns          = 4;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3004';
params.sessionDate = '091916';
clusterSessionDate = '091916';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_3004 - session 1 (partial) - DEINTERLACE VIDEO - DONE
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3004';
params.sessionDate = '091916';
clusterSessionDate = '091916';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

%% TOME_3004 - session 1 (partial)- PREPROCESSING
% this is a make up session for the previous session 1. It has only 2
% functional runs.

params.subjectName      = 'TOME_3004';
clusterSessionDate = '101416b';
sessionOneDate = '091916';

params.numRuns          = 2;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist ('MPRAGEdir','dir')
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3004';
params.sessionDate = '101416';
clusterSessionDate = '101416b';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_3004 - session 1 (partial) - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3004';
params.sessionDate = '101416';
clusterSessionDate = '101416b';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

%% TOME_3004 - session 2 - PREPROCESSING 

params.subjectName = 'TOME_3004';
clusterSessionDate = '101416a';
sessionOneDate = '091916';


params.numRuns          = 10;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist ('MPRAGEdir','dir')
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3004';
params.sessionDate = '101416';
clusterSessionDate = '101416a';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_3004 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3004';
params.sessionDate = '101416';
clusterSessionDate = '101416a';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

%% TOME_3005 - session 1 - PREPROCESSING
params.subjectName      = 'TOME_3005';
clusterSessionDate = '092316';

params.numRuns          = 4;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3005';
params.sessionDate = '092316';
clusterSessionDate = '092316';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_3005 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3005';
params.sessionDate = '092316';
clusterSessionDate = '092316';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

%% TOME_3005 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3005';
clusterSessionDate = '100316';
sessionOneDate = '092316';


params.numRuns          = 10;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist ('MPRAGEdir','dir')
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3005';
params.sessionDate = '100316';
clusterSessionDate = '100316';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_3005 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3005';
params.sessionDate = '100316';
clusterSessionDate = '100316';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

%% TOME_3006 - no data collected

%% TOME_3007 - session 1 - PREPROCESSING
params.subjectName      = 'TOME_3007';
clusterSessionDate = '101116';

params.numRuns          = 4;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3007';
params.sessionDate = '101116';
clusterSessionDate = '101116';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_3007 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3007';
params.sessionDate = '101116';
clusterSessionDate = '101116';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

%% TOME_3007 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3007';
clusterSessionDate = '101716';
sessionOneDate = '101116';


params.numRuns          = 10;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist ('MPRAGEdir','dir')
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3007';
params.sessionDate = '101716';
clusterSessionDate = '101716';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_3007 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3007';
params.sessionDate = '101716';
clusterSessionDate = '101716';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

%% TOME_3008 - session 1 - PREPROCESSING - DONE
params.subjectName      = 'TOME_3008';
clusterSessionDate = '102116';

params.numRuns          = 4;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3008';
params.sessionDate = '102116';
clusterSessionDate = '102116';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_3008 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3008';
params.sessionDate = '102116';
clusterSessionDate = '102116';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

%% TOME_3008 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3008';
clusterSessionDate = '103116';
sessionOneDate = '102116';


params.numRuns          = 10;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist ('MPRAGEdir','dir')
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3008';
params.sessionDate = '103116';
clusterSessionDate = '103116';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_3008 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3008';
params.sessionDate = '103116';
clusterSessionDate = '103116';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

%% TOME_3009 - session 1 - PREPROCESSING
params.subjectName      = 'TOME_3009';
clusterSessionDate = '100716';

params.numRuns          = 4;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3009';
params.sessionDate = '100716';
clusterSessionDate = '100716';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_3009 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3009';
params.sessionDate = '100716';
clusterSessionDate = '100716';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

%% TOME_3009 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3009';
clusterSessionDate = '102516';
sessionOneDate = '100716';


params.numRuns          = 10;
params.reconall         = 0;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist ('MPRAGEdir','dir')
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3009';
params.sessionDate = '102516';
clusterSessionDate = '102516';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_3009 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3009';
params.sessionDate = '102516';
clusterSessionDate = '102516';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

%% TOME_3010 - no data collected

%% TOME_3011 - session 1 - PREPROCESSING - DONE
params.subjectName      = 'TOME_3011';
clusterSessionDate = '111116';

params.numRuns          = 4;
params.reconall         = 1;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3011';
params.sessionDate = '111116';
clusterSessionDate = '111116';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_3011 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3011';
params.sessionDate = '111116';
clusterSessionDate = '111116';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')



%% TOME_3013 - session 1 - PREPROCESSING
params.subjectName      = 'TOME_3013';
clusterSessionDate = '112816';

params.numRuns          = 4;
params.reconall         = 1;

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = logDir;
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3013';
params.sessionDate = '112816';
clusterSessionDate = '112816';

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist ('qaParams.outDir','dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)

%% TOME_30XX - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3013';
params.sessionDate = '112816';
clusterSessionDate = '112816';

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
    else
        params.runName = runs(rr).name(1:end-4); %calibrations
    end
    deinterlaceVideo (params, dropboxDir)
end
% copy over all deinterlaced videos
fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
    fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
fprintf('done!\n')

