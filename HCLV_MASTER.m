% Master script for processing data in the Human Connectome Low Vision
% (HCLV) project
%
%   Written by Andrew S Bock Sep 2016

%% TOME_3001 - session 1
session_dir = '/data/jag/TOME/TOME_3001/081916a';
subject_name = 'TOME_3001'; % Freesurfer subject name (may not match job_name)
outDir = fullfile(session_dir,'preprocessing_scripts');
logDir = '/data/jet/abock/LOGS';
job_name = 'TOME_3001'; % Name for this job/session (may not match subject_name)
numRuns = 4; % number of bold runs
reconall = 1;
slicetiming = 0; % correct slice timings
refvol = 1; % motion correct to 1st TR
filtType = 'high';
lowHz = 0.01;
highHz = 0.10;
physio = 1;
motion = 1;
task = 0;
localWM = 1;
anat = 1;
amem = 20;
fmem = 50;

create_preprocessing_scripts(session_dir,subject_name,outDir,logDir,job_name...
    ,numRuns,reconall,slicetiming,refvol,filtType,lowHz,highHz,physio,motion,task,localWM,anat,amem,fmem)
%% TOME_3001 - session 2

%%% copy over the MPRAGE directory from session 1 %%%

session_dir = '/data/jag/TOME/TOME_3001/081916b';
subject_name = 'TOME_3001'; % Freesurfer subject name (may not match job_name)
outDir = fullfile(session_dir,'preprocessing_scripts');
logDir = '/data/jet/abock/LOGS';
job_name = 'TOME_3001'; % Name for this job/session (may not match subject_name)
numRuns = 10; % number of bold runs
reconall = 0;
slicetiming = 0; % correct slice timings
refvol = 1; % motion correct to 1st TR
filtType = 'high';
lowHz = 0.01;
highHz = 0.10;
physio = 1;
motion = 1;
task = 0;
localWM = 1;
anat = 1;
amem = 20;
fmem = 50;
% Create preprocessing scripts
create_preprocessing_scripts(session_dir,subject_name,outDir,logDir,job_name...
    ,numRuns,reconall,slicetiming,refvol,filtType,lowHz,highHz,physio,motion,task,localWM,anat,amem,fmem);
% project template
project_template(session_dir,subject_name);

%% TOME_3002 - session 1
session_dir = '/data/jag/TOME/TOME_3002/082616a';
subject_name = 'TOME_3002'; % Freesurfer subject name (may not match job_name)
outDir = fullfile(session_dir,'preprocessing_scripts');
logDir = '/data/jet/abock/LOGS';
job_name = 'TOME_3002'; % Name for this job/session (may not match subject_name)
numRuns = 4; % number of bold runs
reconall = 1;
slicetiming = 0; % correct slice timings
refvol = 1; % motion correct to 1st TR
filtType = 'high';
lowHz = 0.01;
highHz = 0.10;
physio = 1;
motion = 1;
task = 0;
localWM = 1;
anat = 1;
amem = 20;
fmem = 50;

create_preprocessing_scripts(session_dir,subject_name,outDir,logDir,job_name...
    ,numRuns,reconall,slicetiming,refvol,filtType,lowHz,highHz,physio,motion,task,localWM,anat,amem,fmem)