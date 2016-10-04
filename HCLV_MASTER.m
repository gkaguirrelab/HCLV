% Master script for processing data in the Human Connectome Low Vision
% (HCLV) project
%
%   Written by Andrew S Bock Sep 2016


%% Defaults
% These will not change across runs
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

%% TOME_3001 - session 1
params.sessionDir       = '/data/jag/TOME/TOME_3001/081916a';
params.subjectName      = 'TOME_3001';
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir           = '/data/jag/TOME/LOGS';
params.jobName          = params.subjectName;
params.numRuns          = 4;
params.reconall         = 0; % already ran once
create_preprocessing_scripts(params);
%% TOME_3001 - session 2

%%% copy over the MPRAGE directory from TOME_3001 - session 1 %%%

params.sessionDir = '/data/jag/TOME/TOME_3001/081916b';
params.subjectName = 'TOME_3001';
params.outDir = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir = '/data/jag/TOME/LOGS';
params.jobName = params.subjectName;
params.numRuns = 10;
params.reconall = 0;
create_preprocessing_scripts(params);
%% TOME_3002 - session 1
params.sessionDir = '/data/jag/TOME/TOME_3002/082616a';
params.subjectName = 'TOME_3002';
params.outDir = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir = '/data/jag/TOME/LOGS';
params.jobName = params.subjectName;
params.numRuns = 4;
params.reconall = 0;
create_preprocessing_scripts(params);
%% TOME_3002 - session 2

%%% copy over the MPRAGE directory from TOME_3002 - session 1 %%%

params.sessionDir = '/data/jag/TOME/TOME_3002/082616b';
params.subjectName = 'TOME_3002';
params.outDir = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir = '/data/jag/TOME/LOGS';
params.jobName = params.subjectName;
params.numRuns = 10;
params.reconall = 0;
create_preprocessing_scripts(params);
%% TOME_3003 - session 1
params.sessionDir = '/data/jag/TOME/TOME_3003/090216';
params.subjectName = 'TOME_3003';
params.outDir = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir = '/data/jag/TOME/LOGS';
params.jobName = params.subjectName;
params.numRuns = 4;
params.reconall = 0;
create_preprocessing_scripts(params);
%% TOME_3003 - session 2

%%% copy over the MPRAGE directory from TOME_3003 - session 1 %%%

params.sessionDir = '/data/jag/TOME/TOME_3003/091616';
params.subjectName = 'TOME_3003';
params.outDir = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir = '/data/jag/TOME/LOGS';
params.jobName = params.subjectName;
params.numRuns = 10;
params.reconall = 0;
create_preprocessing_scripts(params);
%% TOME_3004 - session 1
params.sessionDir = '/data/jag/TOME/TOME_3004/091916';
params.subjectName = 'TOME_3004';
params.outDir = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir = '/data/jag/TOME/LOGS';
params.jobName = params.subjectName;
params.numRuns = 4;
params.reconall = 0;
create_preprocessing_scripts(params);
%% TOME_3005 - session 1
params.sessionDir = '/data/jag/TOME/TOME_3005/092316';
params.subjectName = 'TOME_3005';
params.outDir = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir = '/data/jag/TOME/LOGS';
params.jobName = params.subjectName;
params.numRuns = 4;
params.reconall = 0;
create_preprocessing_scripts(params);
%% TOME_3005 - session 2

%%% copy over the MPRAGE directory from TOME_3005 - session 1 %%%
%%% remove reruns %%%

params.sessionDir = '/data/jag/TOME/TOME_3005/100316';
params.subjectName = 'TOME_3005';
params.outDir = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir = '/data/jag/TOME/LOGS';
params.jobName = params.subjectName;
params.numRuns = 10;
params.reconall = 0;
create_preprocessing_scripts(params);


















%% TOME_3002 - project template
session_dir = '/data/jag/TOME/TOME_3002/082616b';
subject_name = 'TOME_3002'; % Freesurfer subject name (may not match job_name)
project_template(session_dir,subject_name);