% Master script for processing data in the Human Connectome Low Vision
% (HCLV) project
%
%   Written by Andrew S Bock Sep 2016

%% TOME_3001 - session 1
params.sessionDir = '/data/jag/TOME/TOME_3001/081916a';
params.subjectName = 'TOME_3001';
params.outDir = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir = '/data/jet/abock/LOGS';
params.jobName = params.subjectName;
params.numRuns = 4; 
params.reconall = 0; % already ran once
params.slicetiming = 0;
params.refvol = 1;
params.regFirst = 1;
params.filtType = 'high';
params.lowHz = 0.01;
params.highHz = 0.10;
params.physio = 1;
params.motion = 1;
params.task = 0;
params.localWM = 1;
params.anat = 1;
params.amem = 20;
params.fmem = 50;
create_preprocessing_scripts(params);
%% TOME_3001 - session 2

%%% copy over the MPRAGE directory from TOME_3001 - session 1 %%%

params.sessionDir = '/data/jag/TOME/TOME_3001/081916b';
params.subjectName = 'TOME_3001';
params.outDir = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir = '/data/jet/abock/LOGS';
params.jobName = params.subjectName;
params.numRuns = 10; 
params.reconall = 0; 
params.slicetiming = 0;
params.refvol = 1;
params.regFirst = 1;
params.filtType = 'high';
params.lowHz = 0.01;
params.highHz = 0.10;
params.physio = 1;
params.motion = 1;
params.task = 0;
params.localWM = 1;
params.anat = 1;
params.amem = 20;
params.fmem = 50;
create_preprocessing_scripts(params);
%% TOME_3002 - session 1
params.sessionDir = '/data/jag/TOME/TOME_3002/082616a';
params.subjectName = 'TOME_3002';
params.outDir = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir = '/data/jet/abock/LOGS';
params.jobName = params.subjectName;
params.numRuns = 4; 
params.reconall = 0; 
params.slicetiming = 0;
params.refvol = 1;
params.regFirst = 1;
params.filtType = 'high';
params.lowHz = 0.01;
params.highHz = 0.10;
params.physio = 1;
params.motion = 1;
params.task = 0;
params.localWM = 1;
params.anat = 1;
params.amem = 20;
params.fmem = 50;
create_preprocessing_scripts(params);
%% TOME_3002 - session 2

%%% copy over the MPRAGE directory from TOME_3002 - session 1 %%%

params.sessionDir = '/data/jag/TOME/TOME_3002/082616b';
params.subjectName = 'TOME_3002';
params.outDir = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir = '/data/jet/abock/LOGS';
params.jobName = params.subjectName;
params.numRuns = 10; 
params.reconall = 0; 
params.slicetiming = 0;
params.refvol = 1;
params.regFirst = 1;
params.filtType = 'high';
params.lowHz = 0.01;
params.highHz = 0.10;
params.physio = 1;
params.motion = 1;
params.task = 0;
params.localWM = 1;
params.anat = 1;
params.amem = 20;
params.fmem = 50;
create_preprocessing_scripts(params);
%% TOME_3003 - session 1
params.sessionDir = '/data/jag/TOME/TOME_3003/090216';
params.subjectName = 'TOME_3003';
params.outDir = fullfile(params.sessionDir,'preprocessing_scripts');
params.logDir = '/data/jet/abock/LOGS';
params.jobName = params.subjectName;
params.numRuns = 4; 
params.reconall = 1;
params.slicetiming = 0;
params.refvol = 1;
params.regFirst = 1;
params.filtType = 'high';
params.lowHz = 0.01;
params.highHz = 0.10;
params.physio = 1;
params.motion = 1;
params.task = 0;
params.localWM = 1;
params.anat = 1;
params.amem = 20;
params.fmem = 50;
create_preprocessing_scripts(params);
%%




%% TOME_3002 - project template
session_dir = '/data/jag/TOME/TOME_3002/082616b';
subject_name = 'TOME_3002'; % Freesurfer subject name (may not match job_name)
project_template(session_dir,subject_name);