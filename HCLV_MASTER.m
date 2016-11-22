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

%%%%%%%%%%%%%%%%%%%%%%%% SESSION 1 EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% TOME_3001 - session 1 - PREPROCESSING
% params.subjectName      = 'TOME_3001';
% clusterSessionDate = '081916a';
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
% %% TOME_3001 - session 1 - DEINTERLACE VIDEO
% params.projectSubfolder = 'session1_restAndStructure';
% params.subjectName = 'TOME_3001';
% params.sessionDate = '081916';
% clusterSessionDate = '081916a';
% 
% runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
%     params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
% for rr = 1 :length(runs) %loop in all video files
%     if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
%         params.runName = runs(rr).name(1:end-8); %runs
%     else
%         params.runName = runs(rr).name(1:end-4); %calibrations
%     end
%     deinterlaceVideo (params, dropboxDir)
%     movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
%         params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
%         fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
% end


%%%%%%%%%%%%%%%%%%%%%%%% SESSION 2 EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% TOME_3001 - session 2 - PREPROCESSING
% 
% params.subjectName = 'TOME_3001';
% clusterSessionDate = '081916b';
% sessionOneDate = '081916a';
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
% %% TOME_3001 - session 2 - EYE TRACKING
% params.projectSubfolder = 'session2_spatialStimuli';
% params.subjectName = 'TOME_3001';
% params.sessionDate = '081916';
% clusterSessionDate = '081916b';
% 
% runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
%     params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));
% for rr = 1 :length(runs) %loop in all video files
%     if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
%         params.runName = runs(rr).name(1:end-8); %runs
%     else
%         params.runName = runs(rr).name(1:end-4); %calibrations
%     end
%     deinterlaceVideo (params, dropboxDir)
%     movefile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
%         params.subjectName,params.sessionDate,params.eyeTrackingDir,[params.runName '*']) , ...
%         fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%   Written by Andrew S Bock and Giulia Frazzetta Sep 2016


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
params.outputDir = 'TOME_analysis';
params.eyeTrackingDir = 'EyeTracking';


%% TOME_3001 - session 1 - PREPROCESSING
params.subjectName      = 'TOME_3001';
clusterSessionDate = '081916a';

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


%% TOME_3001 - session 1 - DEINTERLACE VIDEO
params.projectSubfolder = 'session1_restAndStructure';
params.subjectName = 'TOME_3001';
params.sessionDate = '081916';
clusterSessionDate = '081916a';

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

%% TOME_3001 - session 2 - EYE TRACKING
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






















%% Subject information
% Session 1
sessionDirs                = {...
    '/data/jag/TOME/TOME_3001/081916a' ...
    '/data/jag/TOME/TOME_3002/082616a' ...
    '/data/jag/TOME/TOME_3002/082616b' ...
    '/data/jag/TOME/TOME_3003/090216' ...
    '/data/jag/TOME/TOME_3003/091616' ...
    '/data/jag/TOME/TOME_3005/092316' ...
    '/data/jag/TOME/TOME_3005/100316' ...
    '/data/jag/TOME/TOME_3007/101116' ...
    '/data/jag/TOME/TOME_3007/101716' ...
    };
% sessionDirs                = {...
%     '/data/jag/TOME/TOME_3001/081916a' ...
%     '/data/jag/TOME/TOME_3001/081916b' ...
%     '/data/jag/TOME/TOME_3002/082616a' ...
%     '/data/jag/TOME/TOME_3002/082616b' ...
%     '/data/jag/TOME/TOME_3003/090216' ...
%     '/data/jag/TOME/TOME_3003/091616' ...
%     '/data/jag/TOME/TOME_3004/091916' ...
%     '/data/jag/TOME/TOME_3004/092016' ...
%     '/data/jag/TOME/TOME_3004/101416a' ...
%     '/data/jag/TOME/TOME_3004/101416b' ...
%     '/data/jag/TOME/TOME_3005/092316' ...
%     '/data/jag/TOME/TOME_3005/100316' ...
%     '/data/jag/TOME/TOME_3007/101116' ...
%     '/data/jag/TOME/TOME_3007/101716' ...
%     '/data/jag/TOME/TOME_3009/100716' ...
%     '/data/jag/TOME/TOME_3009/102516' ...
%     '/data/jag/TOME/TOME_3011/111116' ...
%     };
sessionNames               = {...
    'TOME_3001' ...
    'TOME_3002' ...
    'TOME_3002' ...
    'TOME_3003' ...
    'TOME_3003' ...
    'TOME_3005' ...
    'TOME_3005' ...
    'TOME_3007' ...
    'TOME_3007' ...
    };
% sessionNames               = {...
%     'TOME_3001' ...
%     'TOME_3001' ...
%     'TOME_3002' ...
%     'TOME_3002' ...
%     'TOME_3003' ...
%     'TOME_3003' ...
%     'TOME_3004' ...
%     'TOME_3004' ...
%     'TOME_3004' ...
%     'TOME_3004' ...
%     'TOME_3005' ...
%     'TOME_3005' ...
%     'TOME_3007' ...
%     'TOME_3007' ...
%     'TOME_3009' ...
%     'TOME_3009' ...
%     'TOME_3011' ...
%     };

numRuns = [...
    4 ...
    4 ...
    10 ...
    4 ...
    10 ...
    4 ...
    10 ...
    4 ...
    10 ...
    ];
% numRuns = [...
%     4 ...
%     10 ...
%     4 ...
%     10 ...
%     4 ...
%     10 ...
%     4 ...
%     10 ...
%     10 ...
%     2 ...
%     4 ...
%     10 ...
%     4 ...
%     10 ...
%     4 ...
%     10 ...
%     4 ...
%     ];
reconall = [...
    0 ...
    0 ...
    0 ...
    0 ...
    0 ...
    0 ...
    0 ...
    0 ...
    0 ...
    ];

% reconall = [...
%     0 ...
%     0 ...
%     0 ...
%     0 ...
%     0 ...
%     0 ...
%     0 ...
%     0 ...
%     0 ...
%     0 ...
%     0 ...
%     0 ...
%     0 ...
%     0 ...
%     1 ...
%     0 ...
%     1 ...
%     ];
%% Create preprocessing scripts
for i = 1:length(sessionDirs)
    params.sessionDir       = sessionDirs{i};
    params.subjectName      = sessionNames{i};
    params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
    params.logDir           = logDir;
    params.jobName          = params.subjectName;
    params.numRuns          = numRuns(i);
    params.reconall         = reconall(i);
    create_preprocessing_scripts(params);
end
%% MPRAGE directory %%%
% Before submitting the session 2 preprocessing scripts, be sure to copy
% copy over the MPRAGE directory from session 1
%% Submit scripts
% navigate to the <sessionDir>/preprocessing_scripts directory for each
% session and submit the appropriate shell script (e.g. sh
% submit_TOME_3001_all.sh)

%% Eye tracking
subject                 = 'TOME_3009';
session                 = '102516';
dataDir                 = fullfile(dbDir,'tome_data/session2_spatialStimuli');
thisDir                 = fullfile(dataDir,subject,session,'EyeTracking');
params.scaleCalVideo    = fullfile(thisDir,'ScaleCalibration_5Mm_102516_170031.avi');
params.scaleCalOutVideo = fullfile('~','ScaleCalibration_5Mm_102516_170031.avi');
params.scaleCalOutMat   = fullfile('~','ScaleCalibration_5Mm_102516_170031.mat');
params.calTargetFile    = fullfile(thisDir,'GazeCal01_LTdat.mat');
params.gazeCalVideo     = fullfile(thisDir,'GazeCal01.mov');
params.gazeCalOutVideo  = fullfile('~','GazeCal01.avi');
params.gazeCalOutMat    = fullfile('~','GazeCal01.mat');
params.gazeCalVideo     = fullfile(thisDir,'GazeCal01.mov');
params.fMRIVideo        = fullfile(thisDir,'tfMRI_MOVIE_AP_run01_raw.mov');
params.fMRIOutVideo     = fullfile('~','tfMRI_MOVIE_AP_run01_raw.avi');
params.fMRIOutMat       = fullfile('~','tfMRI_MOVIE_AP_run01_raw.mat');
[pupilSize,gaze]        = calcPupilFMRI(params);

%% Project retinotopic templates
for i = 1:length(sessionDirs)
    project_template(sessionDirs{i},sessionNames{i});
end

%% make pRF scripts
params.logDir                   = logDir;
for i = 2:2:10%length(sessionDirs)
    params.scriptDir            = fullfile(sessionDirs{i},'pRFscripts');
    d = listdir(fullfile(sessionDirs{i},'*tfMRI_RETINO*'),'dirs');
    s = listdir(fullfile(sessionDirs{i},'Stimuli','tfMRI_RETINO*'),'files');
    for j = 1:length(d)
        for k = 1:length(hemis)
            params.jobName      = sprintf([hemis{k} '.pRF.%02d.sh'],j);
            tmpInd              = strfind(s,sprintf('%02d',j));
            stimInd             = find(~cellfun(@isempty,tmpInd));
            params.stimFile     = fullfile(sessionDirs{i},'Stimuli',s{stimInd});
            params.inVol        = fullfile(sessionDirs{i},d{j},[pRFfunc '.' hemis{k} '.nii.gz']);
            params.outDir       = fullfile(sessionDirs{i},d{j});
            params.baseName     = hemis{k};
            makePRFscripts(params);
        end
    end
    params.submitName           = 'submit.pRF.sh';
    makePRFsubmit(params);
end
%% submit pRF scripts
%
%   submit the scripts above
%% Average pRF maps across runs
for i = 2:2:length(sessionDirs)
    for j = 1:length(hemis);
        params.sessionDir       = sessionDirs{i};
        params.baseName         = hemis{j};
        avgPRFmaps(params);
    end
end