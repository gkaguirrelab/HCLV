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

% %% TOME_30XX - session 1 - FMRI PREPROCESSING
% params.subjectName      = 'TOME_30XX';
% clusterSessionDate = 'mmddyy';
%
% params.numRuns          = 4;
% params.reconall         = 1;
% 
% fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)
%
% %% Run preprocessing scripts
% 
% %% Run QA after preprocessing
% params.projectSubfolder = 'session1_restAndStructure';
% params.subjectName = 'TOME_3XXX';
% params.sessionDate = 'mmddyy';
% clusterSessionDate = 'mmddyy';
% 
% fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)
% 
% %% TOME_30XX - session 1 - DEINTERLACE VIDEO
% params.projectSubfolder = 'session1_restAndStructure';
% params.subjectName = 'TOME_30XX';
% params.sessionDate = 'mmddyy';
% clusterSessionDate = 'mmddyy';
% copyToCluster = 1;
% 
% deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)
% 
% %% Run Tracking scripts on the cluster
% % params.ellipseThresh   = [0.xx 0.9];
% % params.circleThresh = [0.0xx 0.999];
% 
% %% Compute calibration for pupil and gaze
% params.projectSubfolder = 'session1_restAndStructure';
% params.subjectName = 'TOME_30xx';
% params.sessionDate = 'mmddyy';
% 
% sizeCalibration(dropboxDir,params);
% 
% params.trackGazeVideos = 1;
% params.ellipseThresh   = [0.98 0.9];
% params.circleThresh = [0.02 0.999];
% 
% 
% calibrationWrapper(dropboxDir, params)
% 
% %% Make Pupil Response Structs
% params.projectSubfolder = 'session1_restAndStructure';
% params.subjectName = 'TOME_30XX';
% params.sessionDate = 'mmddyy';
% 
% pupilRespStructWrapper (params,dropboxDir)
% 
% eyetrackingQA (dropboxDir, params)


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
% fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)
%
% % copy MPRAGE folder from session one
% MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
% if exist (MPRAGEdir,'dir')
%     params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
%     copyfile(MPRAGEdir, params.sessionDir)
% else
%     warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
% end
%
% %% Run preprocessing scripts
% 
% %% Run QA after preprocessing
% params.projectSubfolder = 'session2_spatialStimuli';
% params.subjectName = 'TOME_3XXX';
% params.sessionDate = 'mmddyy';
% clusterSessionDate = 'mmddyy';
% 
% fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)
% 
% %% TOME_30XX - session 2 - DEINTERLACE VIDEO
% params.projectSubfolder = 'session2_spatialStimuli';
% params.subjectName = 'TOME_30XX';
% params.sessionDate = 'mmddyy';
% clusterSessionDate = 'mmddyy';
% 
% deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)
% 
% %% Run Tracking scripts on the cluster
% % params.ellipseThresh   = [0.xx 0.9];
% % params.circleThresh = [0.0xx 0.999];
% 
% %% Compute calibration for pupil and gaze
% params.projectSubfolder = 'session2_spatialStimuli';
% params.subjectName = 'TOME_30xx';
% params.sessionDate = 'mmddyy';
% 
% sizeCalibration(dropboxDir,params);
% 
% params.trackGazeVideos = 1;
% params.ellipseThresh   = [0.98 0.9];
% params.circleThresh = [0.02 0.999];
% 
% 
% calibrationWrapper(dropboxDir, params)
% 
% %% Make Pupil Response Structs
% params.projectSubfolder = 'session2_spatialStimuli';
% params.subjectName = 'TOME_30XX';
% params.sessionDate = 'mmddyy';
% 
% pupilRespStructWrapper (params,dropboxDir)
% 
% eyetrackingQA (dropboxDir, params)
% 
% %% TOME_3001 - session 2 - pRF processing
% 
% % Set paths
% params.subjectName      = 'TOME_30xx';
% clusterSessionDate      = 'mmddyy';
% params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
% 
% % Project Benson template to subject space
% project_template(params.sessionDir,params.subjectName);
% 
% % Make pRF scripts
% makePRFshellScripts(params);
% 
% %%% Run the pRF scipts %%%
% % e.g. sh <path_to_sessionDir>/pRF_scripts/submitPRFs.sh
% 
% % Average maps after pRF scripts have finished
% params.inDir            = fullfile(params.sessionDir,'pRFs');
% params.outDir           = fullfile(params.sessionDir,'pRFs');
% for i = 1:length(hemis)
%     params.baseName     = hemis{i};
%     avgPRFmaps(params)
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Written by Andrew S Bock and Giulia Frazzetta Sep 2016

%% fBIRN QA 
% make the fBIRN QA plots
plotFBIRNqa;

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

% for preprocessing
params.logDir           = '/data/jag/TOME/LOGS';
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
params.analysisDir = 'TOME_analysis';


%% %%%%%%%%%%%%%%%%%%%%%% TOME_3001 SESSION 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3001 - session 1 - PREPROCESSING 
params.subjectName      = 'TOME_3001';
clusterSessionDate = '081916a';

params.numRuns          = 4;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3001';
params.sessionDate = '081916';
clusterSessionDate = '081916a';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)
%% TOME_3001 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3001';
params.sessionDate = '081916';
clusterSessionDate = '081916a';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3001';
params.sessionDate = '081916';
params.sessionTwoDate = '081916';
params.projectSubfolderTwo = 'session2_spatialStimuli';

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)
%% %%%%%%%%%%%%%%%%%%%%%% TOME_3001 SESSION 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3001 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3001';
clusterSessionDate = '081916b';
sessionOneDate = '081916a';

params.numRuns          = 10;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)
% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3001';
params.sessionDate = '081916';
clusterSessionDate = '081916b';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)
%% TOME_3001 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3001';
params.sessionDate = '081916';
clusterSessionDate = '081916b';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Make Pupil Response Structs
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3001';
params.sessionDate = '081916';

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)

%% TOME_3001 - session 2 - pRF processing

% Set paths
params.subjectName      = 'TOME_3001';
clusterSessionDate      = '081916b';
params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);

% Project Benson template to subject space
project_template(params.sessionDir,params.subjectName);

% Make pRF scripts
makePRFshellScripts(params);

%%% Run the pRF scipts %%%
% e.g. sh <path_to_sessionDir>/pRF_scripts/submitPRFs.sh

% Average maps after pRF scripts have finished
params.inDir            = fullfile(params.sessionDir,'pRFs');
params.outDir           = fullfile(params.sessionDir,'pRFs');
for i = 1:length(hemis)
    params.baseName     = hemis{i};
    avgPRFmaps(params)
end


%% %%%%%%%%%%%%%%%%%%%%%% TOME_3002 SESSION 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3002 - session 1 - PREPROCESSING
params.subjectName      = 'TOME_3002';
clusterSessionDate = '082616a';

params.numRuns          = 4;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3002';
params.sessionDate = '082616';
clusterSessionDate = '082616a';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3002 - session 1 - DEINTERLACE VIDEO - DONE
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3002';
params.sessionDate = '082616';
clusterSessionDate = '082616a';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3002';
params.sessionDate = '082616';
params.sessionTwoDate = '082616';
params.projectSubfolderTwo = 'session2_spatialStimuli';

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)


%% %%%%%%%%%%%%%%%%%%%%%% TOME_3002 SESSION 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3002 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3002';
clusterSessionDate = '082616b';
sessionOneDate = '082616a';

params.numRuns          = 10;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)
% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3002';
params.sessionDate = '082616';
clusterSessionDate = '082616b';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3002 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3002';
params.sessionDate = '082616';
clusterSessionDate = '082616b';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Make Pupil Response Structs
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3002';
params.sessionDate = '082616';

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)
%% TOME_3002 - session 2 - pRF processing

% Set paths
params.subjectName      = 'TOME_3002';
clusterSessionDate      = '082616b';
params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);

% Project Benson template to subject space
project_template(params.sessionDir,params.subjectName);

% Make pRF scripts
makePRFshellScripts(params);

%%% Run the pRF scipts %%%
% e.g. sh <path_to_sessionDir>/pRF_scripts/submitPRFs.sh

% Average maps after pRF scripts have finished
params.inDir            = fullfile(params.sessionDir,'pRFs');
params.outDir           = fullfile(params.sessionDir,'pRFs');
for i = 1:length(hemis)
    params.baseName     = hemis{i};
    avgPRFmaps(params)
end


%% %%%%%%%%%%%%%%%%%%%%%% TOME_3003 SESSION 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3003 - session 1 - PREPROCESSING
params.subjectName      = 'TOME_3003';
clusterSessionDate      = '090216';

params.numRuns          = 4;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3003';
params.sessionDate = '090216';
clusterSessionDate = '090216';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3003 - session 1 - DEINTERLACE VIDEO - DONE
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3003';
params.sessionDate = '090216';
clusterSessionDate = '090216';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3003';
params.sessionDate = '090216';
params.sessionTwoDate = '091616';
params.projectSubfolderTwo = 'session2_spatialStimuli';

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)

%% %%%%%%%%%%%%%%%%%%%%%% TOME_3003 SESSION 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3003 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3003';
clusterSessionDate = '091616';
sessionOneDate = '090216';


params.numRuns          = 10;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3003';
params.sessionDate = '091616';
clusterSessionDate = '091616';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3003 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3003';
params.sessionDate = '091616';
clusterSessionDate = '091616';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Make Pupil Response Structs
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3003';
params.sessionDate = '091616';

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)
%% TOME_3003 - session 2 - pRF processing

% Set paths
params.subjectName      = 'TOME_3003';
clusterSessionDate      = '091616';
params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);

% Project Benson template to subject space
project_template(params.sessionDir,params.subjectName);

% Make pRF scripts
makePRFshellScripts(params);

%%% Run the pRF scipts %%%
% e.g. sh <path_to_sessionDir>/pRF_scripts/submitPRFs.sh

% Average maps after pRF scripts have finished
params.inDir            = fullfile(params.sessionDir,'pRFs');
params.outDir           = fullfile(params.sessionDir,'pRFs');
for i = 1:length(hemis)
    params.baseName     = hemis{i};
    avgPRFmaps(params)
end


%% %%%%%%%%%%%%%%%%%%%%%% TOME_3004 SESSION 1 (partial)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3004 - session 1 (partial)- PREPROCESSING
% the last 2 functional runs of this sessions need to be discarded because
% there is no TR information for eyetracking data.

params.subjectName      = 'TOME_3004';
clusterSessionDate = '091916';

params.numRuns          = 4;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3004';
params.sessionDate = '091916';
clusterSessionDate = '091916';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3004 - session 1 (partial) - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3004';
params.sessionDate = '091916';
clusterSessionDate = '091916';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3004';
params.sessionDate = '091916';
params.sessionTwoDate = '101416';
params.projectSubfolderTwo = 'session2_spatialStimuli';


pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)

%% %%%%%%%%%%%%%%%%%%%%%% TOME_3004 SESSION 1 (partial) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3004 - session 1 (partial)- PREPROCESSING
% this is a make up session for the previous session 1. It has only 2
% functional runs.

params.subjectName      = 'TOME_3004';
clusterSessionDate = '101416b';
sessionOneDate = '091916';

params.numRuns          = 2;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3004';
params.sessionDate = '101416';
clusterSessionDate = '101416b';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3004 - session 1 (partial) - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3004';
params.sessionDate = '101416';
clusterSessionDate = '101416b';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3004';
params.sessionDate = '101416';
params.sessionTwoDate = '101416';
params.projectSubfolderTwo = 'session2_spatialStimuli';

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)

%% %%%%%%%%%%%%%%%%%%%%%% TOME_3004 SESSION 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3004 - session 2 - PREPROCESSING 

params.subjectName = 'TOME_3004';
clusterSessionDate = '101416a';
sessionOneDate = '091916';


params.numRuns          = 10;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3004';
params.sessionDate = '101416';
clusterSessionDate = '101416a';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)
%% TOME_3004 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3004';
params.sessionDate = '101416';
clusterSessionDate = '101416a';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Make Pupil Response Structs
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3004';
params.sessionDate = '101416';

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)
%% TOME_3004 - session 2 - pRF processing

% Set paths
params.subjectName      = 'TOME_3004';
clusterSessionDate      = '101416a';
params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);

% Project Benson template to subject space
project_template(params.sessionDir,params.subjectName);

% Make pRF scripts
makePRFshellScripts(params);

%%% Run the pRF scipts %%%
% e.g. sh <path_to_sessionDir>/pRF_scripts/submitPRFs.sh

% Average maps after pRF scripts have finished
params.inDir            = fullfile(params.sessionDir,'pRFs');
params.outDir           = fullfile(params.sessionDir,'pRFs');
for i = 1:length(hemis)
    params.baseName     = hemis{i};
    avgPRFmaps(params)
end



%% %%%%%%%%%%%%%%%%%%%%%% TOME_3005 SESSION 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3005 - session 1 - PREPROCESSING
params.subjectName      = 'TOME_3005';
clusterSessionDate = '092316';

params.numRuns          = 4;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3005';
params.sessionDate = '092316';
clusterSessionDate = '092316';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3005 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3005';
params.sessionDate = '092316';
clusterSessionDate = '092316';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.90 0.9];
% params.circleThresh = [0.05 0.999];
% params.gammaCorrection = 1.4;


%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3005';
params.sessionDate = '092316';
params.sessionTwoDate = '100316';
params.projectSubfolderTwo = 'session2_spatialStimuli';

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)


%% %%%%%%%%%%%%%%%%%%%%%% TOME_3005 SESSION 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3005 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3005';
clusterSessionDate = '100316';
sessionOneDate = '092316';


params.numRuns          = 10;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3005';
params.sessionDate = '100316';
clusterSessionDate = '100316';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3005 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3005';
params.sessionDate = '100316';
clusterSessionDate = '100316';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Make Pupil Response Structs
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3005';
params.sessionDate = '100316';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)
%% TOME_3005 - session 2 - pRF processing
% Set paths
params.subjectName      = 'TOME_3005';
clusterSessionDate      = '100316';
params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);

% Project Benson template to subject space
project_template(params.sessionDir,params.subjectName);

% Make pRF scripts
makePRFshellScripts(params);

%%% Run the pRF scipts %%%
% e.g. sh <path_to_sessionDir>/pRF_scripts/submitPRFs.sh

% Average maps after pRF scripts have finished
params.inDir            = fullfile(params.sessionDir,'pRFs');
params.outDir           = fullfile(params.sessionDir,'pRFs');
for i = 1:length(hemis)
    params.baseName     = hemis{i};
    avgPRFmaps(params)
end



%% TOME_3006 - no data collected




%% %%%%%%%%%%%%%%%%%%%%%% TOME_3007 SESSION 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3007 - session 1 - PREPROCESSING
params.subjectName      = 'TOME_3007';
clusterSessionDate = '101116';

params.numRuns          = 4;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3007';
params.sessionDate = '101116';
clusterSessionDate = '101116';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3007 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3007';
params.sessionDate = '101116';
clusterSessionDate = '101116';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3007';
params.sessionDate = '101116';

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)


%% %%%%%%%%%%%%%%%%%%%%%% TOME_3007 SESSION 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3007 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3007';
clusterSessionDate = '101716';
sessionOneDate = '101116';


params.numRuns          = 10;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3007';
params.sessionDate = '101716';
clusterSessionDate = '101716';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3007 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3007';
params.sessionDate = '101716';
clusterSessionDate = '101716';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Make Pupil Response Structs
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3007';
params.sessionDate = '101716';

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)
%% TOME_3007 - session 2 - pRF processing
% Set paths
params.subjectName      = 'TOME_3007';
clusterSessionDate      = '101716';
params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);

% Project Benson template to subject space
project_template(params.sessionDir,params.subjectName);

% Make pRF scripts
makePRFshellScripts(params);

%%% Run the pRF scipts %%%
% e.g. sh <path_to_sessionDir>/pRF_scripts/submitPRFs.sh

% Average maps after pRF scripts have finished
params.inDir            = fullfile(params.sessionDir,'pRFs');
params.outDir           = fullfile(params.sessionDir,'pRFs');
for i = 1:length(hemis)
    params.baseName     = hemis{i};
    avgPRFmaps(params)
end



%% %%%%%%%%%%%%%%%%%%%%%% TOME_3008 SESSION 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3008 - session 1 - PREPROCESSING
params.subjectName      = 'TOME_3008';
clusterSessionDate      = '102116';

params.numRuns          = 4;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3008';
params.sessionDate = '102116';
clusterSessionDate = '102116';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3008 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3008';
params.sessionDate = '102116';
clusterSessionDate = '102116';

copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)
%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.9 0.9];
% params.circleThresh = [0.085 0.999];

%% get calibration factors
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3008';
params.sessionDate = '102116';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 0;
params.ellipseThresh   = [0.985 0.9];
params.circleThresh = [0.025 0.999];

calibrationWrapper(dropboxDir, params)
%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3008';
params.sessionDate = '102116';
params.sessionTwoDate = '103116';
params.projectSubfolderTwo = 'session2_spatialStimuli';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)


%% %%%%%%%%%%%%%%%%%%%%%% TOME_3008 SESSION 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3008 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3008';
clusterSessionDate = '103116';
sessionOneDate = '102116';


params.numRuns          = 10;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3008';
params.sessionDate = '103116';
clusterSessionDate = '103116';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3008 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3008';
params.sessionDate = '103116';
clusterSessionDate = '103116';

copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.9 0.9];
% params.circleThresh = [0.06 0.999];

%% get calibration factors
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3008';
params.sessionDate = '103116';

sizeCalibration(params);

params.trackGazeVideos = 0;
params.ellipseThresh   = [0.985 0.9];
params.circleThresh = [0.025 0.999];

calibrationWrapper(dropboxDir, params)
%% Make Pupil Response Structs
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3008';
params.sessionDate = '103116';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)
%% TOME_3008 - session 2 - pRF processing
% Set paths
params.subjectName      = 'TOME_3008';
clusterSessionDate      = '103116';
params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);

% Project Benson template to subject space
project_template(params.sessionDir,params.subjectName);

% Make pRF scripts
makePRFshellScripts(params);

%%% Run the pRF scipts %%%
% e.g. sh <path_to_sessionDir>/pRF_scripts/submitPRFs.sh

% Average maps after pRF scripts have finished
params.inDir            = fullfile(params.sessionDir,'pRFs');
params.outDir           = fullfile(params.sessionDir,'pRFs');
for i = 1:length(hemis)
    params.baseName     = hemis{i};
    avgPRFmaps(params)
end



%% %%%%%%%%%%%%%%%%%%%%%% TOME_3009 SESSION 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3009 - session 1 - PREPROCESSING
params.subjectName      = 'TOME_3009';
clusterSessionDate      = '100716';

params.numRuns          = 4;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3009';
params.sessionDate = '100716';
clusterSessionDate = '100716';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3009 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3009';
params.sessionDate = '100716';
clusterSessionDate = '100716';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)
%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.948 0.9];
% params.circleThresh = [0.045 0.999];
% params.gammaCorrection =  0.7;

%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3009';
params.sessionDate = '100716';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)


%% %%%%%%%%%%%%%%%%%%%%%% TOME_3009 SESSION 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3009 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3009';
clusterSessionDate = '102516';
sessionOneDate = '100716';

params.numRuns          = 10;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3009';
params.sessionDate = '102516';
clusterSessionDate = '102516';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3009 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3009';
params.sessionDate = '102516';
clusterSessionDate = '102516';

copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)
%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.968 0.9];
% params.circleThresh = [0.025 0.999];

%% Compute calibration factors for pupil and gaze
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3009';
params.sessionDate = '102516';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 0;
params.ellipseThresh   = [0.985 0.9];
params.circleThresh = [0.025 0.999];

calibrationWrapper(dropboxDir, params)
%% Make Pupil Response Structs
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3009';
params.sessionDate = '102516';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)
%% TOME_3009 - session 2 - pRF processing
% Set paths
params.subjectName      = 'TOME_3009';
clusterSessionDate      = '102516';
params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);

% Project Benson template to subject space
project_template(params.sessionDir,params.subjectName);

% Make pRF scripts
makePRFshellScripts(params);

%%% Run the pRF scipts %%%
% e.g. sh <path_to_sessionDir>/pRF_scripts/submitPRFs.sh

% Average maps after pRF scripts have finished
params.inDir            = fullfile(params.sessionDir,'pRFs');
params.outDir           = fullfile(params.sessionDir,'pRFs');
for i = 1:length(hemis)
    params.baseName     = hemis{i};
    avgPRFmaps(params)
end




%%  %%%%%%%%%%%%%%%%%%%%%%  TOME_3010 - no data collected %%%%%%%%%%%%%%%%%



%% %%%%%%%%%%%%%%%%%%%%%% TOME_3011 SESSION 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3011 - session 1 - PREPROCESSING - DONE
params.subjectName      = 'TOME_3011';
clusterSessionDate      = '111116';

params.numRuns          = 4;
params.reconall         = 1;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3011';
params.sessionDate = '111116';
clusterSessionDate = '111116';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3011 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3011';
params.sessionDate = '111116';
clusterSessionDate = '111116';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.92 0.9];
% params.circleThresh = [0.067 0.999];

%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3011';
params.sessionDate = '111116';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)
%% %%%%%%%%%%%%%%%%%%%%%% TOME_3011 Session 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_3011 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3011';
clusterSessionDate = '012017';
sessionOneDate = '111116';


params.numRuns          = 10;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3011';
params.sessionDate = '012017';
clusterSessionDate = '012017';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_30XX - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3011';
params.sessionDate = '012017';
clusterSessionDate = '012017';
copyToCluster = 1; 

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.95 0.9];
% params.circleThresh = [0.05 0.999];

%% Compute calibration for pupil and gaze
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3011';
params.sessionDate = '012017';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 1;
params.ellipseThresh   = [0.96 0.9];
params.circleThresh = [0.05 0.999];

calibrationWrapper(dropboxDir, params)

%% Make Pupil Response Structs
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3011';
params.sessionDate = '012017';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)

%% TOME_3011 - session 2 - pRF processing

% Set paths
params.subjectName      = 'TOME_3011';
clusterSessionDate      = '012017';
params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);

% Project Benson template to subject space
project_template(params.sessionDir,params.subjectName);

% Make pRF scripts
makePRFshellScripts(params);

%%% Run the pRF scipts %%%
% e.g. sh <path_to_sessionDir>/pRF_scripts/submitPRFs.sh

% Average maps after pRF scripts have finished
params.inDir            = fullfile(params.sessionDir,'pRFs');
params.outDir           = fullfile(params.sessionDir,'pRFs');
for i = 1:length(hemis)
    params.baseName     = hemis{i};
    avgPRFmaps(params)
end



%% %%%%%%%%%%%%%%%%%%%%%% TOME_3013 SESSION 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3013 - session 1 - PREPROCESSING
params.subjectName      = 'TOME_3013';
clusterSessionDate = '121216';

params.numRuns          = 4;
params.reconall         = 1;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3013';
params.sessionDate = '121216';
clusterSessionDate = '121216';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3013 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3013';
params.sessionDate = '121216';
clusterSessionDate = '121216';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.95 0.9];
% params.circleThresh = [0.04 0.999];

%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3013';
params.sessionDate = '121216';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)
%% %%%%%%%%%%%%%%%%%%%%%% TOME_3013 SESSION 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOME_3013 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3013';
clusterSessionDate = '011117';
sessionOneDate = '121216';

params.numRuns          = 9; %FLASH 2 was not run
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3013';
params.sessionDate = '011117';
clusterSessionDate = '011117';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3013 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3013';
params.sessionDate = '011117';
clusterSessionDate = '011117';

copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)
%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.965 0.9];
% params.circleThresh = [0.04 0.999];

%% Compute calibration factors for pupil and gaze
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3013';
params.sessionDate = '011117';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 1;
params.ellipseThresh   = [0.98 0.9];
params.circleThresh = [0.015 0.999];

calibrationWrapper(dropboxDir, params)

%% Make Pupil Response Structs
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3013';
params.sessionDate = '011117';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)
%% TOME_3013 - session 2 - pRF processing
% Set paths
params.subjectName      = 'TOME_3013';
clusterSessionDate      = '011117';
params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);

% Project Benson template to subject space
project_template(params.sessionDir,params.subjectName);

% Make pRF scripts
makePRFshellScripts(params);

%%% Run the pRF scipts %%%
% e.g. sh <path_to_sessionDir>/pRF_scripts/submitPRFs.sh

% Average maps after pRF scripts have finished
params.inDir            = fullfile(params.sessionDir,'pRFs');
params.outDir           = fullfile(params.sessionDir,'pRFs');
for i = 1:length(hemis)
    params.baseName     = hemis{i};
    avgPRFmaps(params)
end


%%  TEST SESSION

params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_Eyetrackingtest';
params.sessionDate = '013117';
clusterSessionDate = '013117';

copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Make Pupil Response Structs
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_Eyetrackingtest';
params.sessionDate = '013117';

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)

%% %%%%%%%%%%%%%%%%%%%%%% TOME_3012 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_3012 - session 1 - FMRI PREPROCESSING
params.subjectName      = 'TOME_3012';
clusterSessionDate = '020117';

params.numRuns          = 4;
params.reconall         = 1;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3012';
params.sessionDate = '020117';
clusterSessionDate = '020117';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3012 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3012';
params.sessionDate = '020117';
clusterSessionDate = '020117';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.95 0.9];
% params.circleThresh = [0.045 0.999];

%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3012';
params.sessionDate = '020117';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)


%% %%%%%%%%%%%%%%%%%%%%%% TOME_3012 SESSION 2  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_3012 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3012';
clusterSessionDate = '020317';
sessionOneDate = '020117';


params.numRuns          = 10;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3012';
params.sessionDate = '020317';
clusterSessionDate = '020317';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3012 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3012';
params.sessionDate = '020317';
clusterSessionDate = '020317';

copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.97 0.9];
% params.circleThresh = [0.04 0.999];

%% Compute calibration for pupil and gaze
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3012';
params.sessionDate = '020317';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 0;
params.ellipseThresh   = [0.97 0.9];
params.circleThresh = [0.025 0.999];

calibrationWrapper(dropboxDir, params)
%% Make Pupil Response Structs
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3012';
params.sessionDate = '020317';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)

%% TOME_3012 - session 2 - pRF processing

% Set paths
params.subjectName      = 'TOME_3012';
clusterSessionDate      = '020317';
params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);

% Project Benson template to subject space
project_template(params.sessionDir,params.subjectName);

% Make pRF scripts
makePRFshellScripts(params);

%%% Run the pRF scipts %%%
% e.g. sh <path_to_sessionDir>/pRF_scripts/submitPRFs.sh

% Average maps after pRF scripts have finished
params.inDir            = fullfile(params.sessionDir,'pRFs');
params.outDir           = fullfile(params.sessionDir,'pRFs');
for i = 1:length(hemis)
    params.baseName     = hemis{i};
    avgPRFmaps(params)
end


%% %%%%%%%%%%%%%%%%%%%%%% TOME_3012 - make up session 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_3012 - session 1 - FMRI PREPROCESSING
params.subjectName      = 'TOME_3012';
clusterSessionDate = '021017';

params.numRuns          = 3;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

sessionOneDate = '020117';
% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, fullfile(params.sessionDir,'MPRAGE'))
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3012';
params.sessionDate = '021017';
clusterSessionDate = '021017';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3012 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3012';
params.sessionDate = '021017';
clusterSessionDate = '021017';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.96 0.9];
% params.circleThresh = [0.035 0.999];

%% Compute calibration for pupil and gaze
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3012';
params.sessionDate = '021017';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 1;
params.ellipseThresh   = [0.98 0.9];
params.circleThresh = [0.02 0.999];


calibrationWrapper(dropboxDir, params)

%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3012';
params.sessionDate = '021017';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)

%% %%%%%%%%%%%%%%%%%%%%%% TOME_3014 session1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_3014 - session 1 - FMRI PREPROCESSING
params.subjectName      = 'TOME_3014';
clusterSessionDate = '021517';

params.numRuns          = 4;
params.reconall         = 1;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3014';
params.sessionDate = '021517';
clusterSessionDate = '021517';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3014 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3014';
params.sessionDate = '021517';
clusterSessionDate = '021517';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.936 0.9];
% params.circleThresh = [0.08 0.999];
% params.gammaCorrection = 1.4;

%% Compute calibration for pupil and gaze
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3014';
params.sessionDate = '021517';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 0;
params.ellipseThresh   = [0.94 0.9];
params.circleThresh = [0.02 0.999];


calibrationWrapper(dropboxDir, params)
%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3014';
params.sessionDate = '021517';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)


%% %%%%%%%%%%%%%%%%%%%%%% TOME_3014 SESSION 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_30XX - session 2 - PREPROCESSING

params.subjectName = 'TOME_3014';
clusterSessionDate = '021717';
sessionOneDate = '021517';


params.numRuns          = 10;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, params.sessionDir)
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3014';
params.sessionDate = '021717';
clusterSessionDate = '021717';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3014 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3014';
params.sessionDate = '021717';
clusterSessionDate = '021717';

copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.96 0.9];
% params.circleThresh = [0.03 0.999];

%% Compute calibration for pupil and gaze
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3014';
params.sessionDate = '021717';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 1;
params.ellipseThresh   = [0.98 0.9];
params.circleThresh = [0.02 0.999];


calibrationWrapper(dropboxDir, params)
%% Make Pupil Response Structs
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3014';
params.sessionDate = '021717';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)

%% TOME_3014 - session 2 - pRF processing

% Set paths
params.subjectName      = 'TOME_3014';
clusterSessionDate      = '021717';
params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);

% Project Benson template to subject space
project_template(params.sessionDir,params.subjectName);

% Make pRF scripts
makePRFshellScripts(params);

%%% Run the pRF scipts %%%
% e.g. sh <path_to_sessionDir>/pRF_scripts/submitPRFs.sh

% Average maps after pRF scripts have finished
params.inDir            = fullfile(params.sessionDir,'pRFs');
params.outDir           = fullfile(params.sessionDir,'pRFs');
for i = 1:length(hemis)
    params.baseName     = hemis{i};
    avgPRFmaps(params)
end

%% %%%%%%%%%%%%%%%%%%%%%% TOME_3015 session1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_3015 - session 1 - FMRI PREPROCESSING
params.subjectName      = 'TOME_3015';
clusterSessionDate = '030117';

params.numRuns          = 4;
params.reconall         = 1;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3015';
params.sessionDate = '030117';
clusterSessionDate = '030117';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3015 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3015';
params.sessionDate = '030117';
clusterSessionDate = '030117';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster
% STILL VERY BAD TRACKING DUE TO GREY SHADOW
% params.ellipseThresh   = [0.93 0.9];
% params.circleThresh = [0.03 0.999];
% params.gammaCorrection = 1.4;
%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3015';
params.sessionDate = '030117';

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)



%% %%%%%%%%%%%%%%%%%%%%%% TOME_3015 SESSION 2  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_3015 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3015';
clusterSessionDate = '032417';
sessionOneDate = '030117';


params.numRuns          = 8; % skipped last 2 runs
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, fullfile(params.sessionDir,'MPRAGE'))
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3015';
params.sessionDate = '032417';
clusterSessionDate = '032417';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3015 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3015';
params.sessionDate = '032417';
clusterSessionDate = '032417';

copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.97 0.9];
% params.circleThresh = [0.04 0.999];

%% Compute calibration for pupil and gaze
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3015';
params.sessionDate = '032417';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 1;
params.ellipseThresh   = [0.94 0.999];
params.circleThresh = [0.02 0.9999];

calibrationWrapper(dropboxDir, params)

%% Make Pupil Response Structs
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3015';
params.sessionDate = '032417';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)

%% TOME_3016 - session 2 - pRF processing

% Set paths
params.subjectName      = 'TOME_3015';
clusterSessionDate      = '032417';
params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);

% Project Benson template to subject space
project_template(params.sessionDir,params.subjectName);

% Make pRF scripts
makePRFshellScripts(params);

%%% Run the pRF scipts %%%
% e.g. sh <path_to_sessionDir>/pRF_scripts/submitPRFs.sh

% Average maps after pRF scripts have finished
params.inDir            = fullfile(params.sessionDir,'pRFs');
params.outDir           = fullfile(params.sessionDir,'pRFs');
for i = 1:length(hemis)
    params.baseName     = hemis{i};
    avgPRFmaps(params)
end

%% %%%%%%%%%%%%%%%%%%%%%% TOME_3016 SESSION 1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_3016 - session 1 - FMRI PREPROCESSING
params.subjectName      = 'TOME_3016';
clusterSessionDate = '031017';

params.numRuns          = 4;
params.reconall         = 1;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3016';
params.sessionDate = '031017';
clusterSessionDate = '031017';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3016 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3016';
params.sessionDate = '031017';
clusterSessionDate = '031017';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.9 0.999];
% params.circleThresh = [0.08 0.99999];
% params.gammaCorrection = 1.3;
%% Compute calibration for pupil and gaze
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3016';
params.sessionDate = '031017';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 0;
params.ellipseThresh   = [0.9 0.9];
params.circleThresh = [0.015 0.999];


calibrationWrapper(dropboxDir, params)
%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3016';
params.sessionDate = '031017';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)


%% %%%%%%%%%%%%%%%%%%%%%% TOME_3016 SESSION 2  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_3016 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3016';
clusterSessionDate = '032017';
sessionOneDate = '031017';


params.numRuns          = 10;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, fullfile(params.sessionDir,'MPRAGE'))
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3016';
params.sessionDate = '032017';
clusterSessionDate = '032017';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3016 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3016';
params.sessionDate = '032017';
clusterSessionDate = '032017';

copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.97 0.9];
% params.circleThresh = [0.04 0.999];

%% Compute calibration for pupil and gaze
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3016';
params.sessionDate = '032017';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 0;
params.ellipseThresh   = [0.92 0.999];
params.circleThresh = [0.02 0.9999];

calibrationWrapper(dropboxDir, params)

%% Make Pupil Response Structs
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3016';
params.sessionDate = '032017';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)

%% TOME_3016 - session 2 - pRF processing

% Set paths
params.subjectName      = 'TOME_3016';
clusterSessionDate      = '032017';
params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);

% Project Benson template to subject space
project_template(params.sessionDir,params.subjectName);

% Make pRF scripts
makePRFshellScripts(params);

%%% Run the pRF scipts %%%
% e.g. sh <path_to_sessionDir>/pRF_scripts/submitPRFs.sh

% Average maps after pRF scripts have finished
params.inDir            = fullfile(params.sessionDir,'pRFs');
params.outDir           = fullfile(params.sessionDir,'pRFs');
for i = 1:length(hemis)
    params.baseName     = hemis{i};
    avgPRFmaps(params)
end

%% %%%%%%%%%%%%%%%%%%%%%% TOME_3017 SESSION 1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_3017 - session 1 - FMRI PREPROCESSING
params.subjectName      = 'TOME_3017';
clusterSessionDate = '032917';

params.numRuns          = 4;
params.reconall         = 1;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3017';
params.sessionDate = '032917';
clusterSessionDate = '032917';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3017 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3017';
params.sessionDate = '032917';
clusterSessionDate = '032917';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Compute calibration for pupil and gaze
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3017';
params.sessionDate = '032917';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 1;
params.ellipseThresh   = [0.985 0.9];
params.circleThresh = [0.03 0.999];
params.gammaCorrection = 1;

calibrationWrapper(dropboxDir, params)
%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3017';
params.sessionDate = '032917';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)

%% %%%%%%%%%%%%%%%%%%%%%% TOME_3017 SESSION 2  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_3017 - session 2 - PREPROCESSING

params.subjectName = 'TOME_3017';
clusterSessionDate = '033117';
sessionOneDate = '032917';


params.numRuns          = 10;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

% copy MPRAGE folder from session one
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, fullfile(params.sessionDir,'MPRAGE'))
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3017';
params.sessionDate = '033117';
clusterSessionDate = '033117';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3017 - session 2 - DEINTERLACE VIDEO
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3016';
params.sessionDate = '033117';
clusterSessionDate = '033117';

copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster
% params.ellipseThresh   = [0.97 0.9];
% params.circleThresh = [0.04 0.999];

%% Compute calibration for pupil and gaze
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3017';
params.sessionDate = '033117';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 0;
params.ellipseThresh   = [0.92 0.999];
params.circleThresh = [0.02 0.9999];

calibrationWrapper(dropboxDir, params)

%% Make Pupil Response Structs
params.projectSubfolder = 'session2_spatialStimuli';
params.subjectName = 'TOME_3017';
params.sessionDate = '033117';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)

%% TOME_3017 - session 2 - pRF processing

% Set paths
params.subjectName      = 'TOME_3017';
clusterSessionDate      = '033117';
params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);

% Project Benson template to subject space
project_template(params.sessionDir,params.subjectName);

% Make pRF scripts
makePRFshellScripts(params);

%%% Run the pRF scipts %%%
% e.g. sh <path_to_sessionDir>/pRF_scripts/submitPRFs.sh

% Average maps after pRF scripts have finished
params.inDir            = fullfile(params.sessionDir,'pRFs');
params.outDir           = fullfile(params.sessionDir,'pRFs');
for i = 1:length(hemis)
    params.baseName     = hemis{i};
    avgPRFmaps(params)
end

%% %%%%%%%%%%%%%%%%%%%%%% TOME_3018 SESSION 1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_3018 - session 1 - FMRI PREPROCESSING
params.subjectName      = 'TOME_3018';
clusterSessionDate = '040717';

params.numRuns          = 4;
params.reconall         = 1;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

% we could not acquire a T1 this session. Copying it from subsequent
% session
sessionOneDate = '041817';
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, fullfile(params.sessionDir,'MPRAGE'))
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end


%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3018';
params.sessionDate = '040717';
clusterSessionDate = '040717';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3018 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3018';
params.sessionDate = '040717';
clusterSessionDate = '040717';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Compute calibration for pupil and gaze
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3018';
params.sessionDate = '040717';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 1;
params.ellipseThresh   = [0.985 0.9];
params.circleThresh = [0.03 0.999];
params.gammaCorrection = 1;

calibrationWrapper(dropboxDir, params)
%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3018';
params.sessionDate = '040717';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)

%% %%%%%%%%%%%%%%%%%%%%%% TOME_3018 SESSION 1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_3018 - session 1 - FMRI PREPROCESSING
params.subjectName      = 'TOME_3018';
clusterSessionDate = '040717';

params.numRuns          = 4;
params.reconall         = 1;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3018';
params.sessionDate = '040717';
clusterSessionDate = '040717';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3018 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3018';
params.sessionDate = '040717';
clusterSessionDate = '040717';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Compute calibration for pupil and gaze
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3018';
params.sessionDate = '040717';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 1;
params.ellipseThresh   = [0.985 0.9];
params.circleThresh = [0.03 0.999];
params.gammaCorrection = 1;

calibrationWrapper(dropboxDir, params)
%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3018';
params.sessionDate = '040717';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)


%% %%%%%%%%%%%%%%%%%%%%%% TOME_3018 SESSION 1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_3018 - session 1 - FMRI PREPROCESSING
params.subjectName      = 'TOME_3018';
clusterSessionDate = '040717';

params.numRuns          = 4;
params.reconall         = 1;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

% we could not acquire a T1 this session. Copying it from subsequent
% session
sessionOneDate = '041817';
MPRAGEdir = fullfile(clusterDir,params.subjectName,sessionOneDate,'MPRAGE');
if exist (MPRAGEdir,'dir')
    params.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
    copyfile(MPRAGEdir, fullfile(params.sessionDir,'MPRAGE'))
else
    warning('No MPRAGE folder found in session 1. Run preprocessing for session one and then copy the MPRAGE folder')
end


%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3018';
params.sessionDate = '040717';
clusterSessionDate = '040717';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3018 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3018';
params.sessionDate = '040717';
clusterSessionDate = '040717';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Compute calibration for pupil and gaze
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3018';
params.sessionDate = '040717';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 1;
params.ellipseThresh   = [0.985 0.9];
params.circleThresh = [0.03 0.999];
params.gammaCorrection = 1;

calibrationWrapper(dropboxDir, params)
%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3018';
params.sessionDate = '040717';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)

%% %%%%%%%%%%%%%%%%%%%%%% TOME_3018 SESSION 1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_3018 - session 1 - FMRI PREPROCESSING
params.subjectName      = 'TOME_3018';
clusterSessionDate = '041817';

params.numRuns          = 3;
params.reconall         = 0;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3018';
params.sessionDate = '041817';
clusterSessionDate = '041817';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3018 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3018';
params.sessionDate = '041817';
clusterSessionDate = '041817';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Compute calibration for pupil and gaze
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3018';
params.sessionDate = '041817';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 1;
params.ellipseThresh   = [0.985 0.9];
params.circleThresh = [0.03 0.999];
params.gammaCorrection = 1;

calibrationWrapper(dropboxDir, params)
%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3018';
params.sessionDate = '041817';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)



%% %%%%%%%%%%%%%%%%%%%%%% TOME_3019 SESSION 1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TOME_3019 - session 1 - FMRI PREPROCESSING
params.subjectName      = 'TOME_3018';
clusterSessionDate = '042617';

params.numRuns          = 4;
params.reconall         = 1;

fmriPreprocessingWrapper(params, clusterDir,clusterSessionDate)

%% Run preprocessing scripts

%% Run QA after preprocessing
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3019';
params.sessionDate = '042617';
clusterSessionDate = '042617';

fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)

%% TOME_3019 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3019';
params.sessionDate = '042617';
clusterSessionDate = '042617';
copyToCluster = 1;

deinterlaceWrapper (params,dropboxDir,clusterDir,clusterSessionDate,copyToCluster)

%% Run Tracking scripts on the cluster

%% Compute calibration for pupil and gaze
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3019';
params.sessionDate = '042617';

sizeCalibration(dropboxDir,params);

params.trackGazeVideos = 1;
params.ellipseThresh   = [0.985 0.9];
params.circleThresh = [0.03 0.999];
params.gammaCorrection = 1;

calibrationWrapper(dropboxDir, params)
%% Make Pupil Response Structs
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3019';
params.sessionDate = '042617';

plotTrackingTimeseries (dropboxDir, params)

pupilRespStructWrapper (params,dropboxDir)

eyetrackingQA (dropboxDir, params)


