% Master script for processing data in the Human Connectome Low Vision
% (HCLV) project
%
%   Written by Andrew S Bock Sep 2016

%% Defaults
%
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
%% Subject information
% Session 1
session1Dirs                = {...
    '/data/jag/TOME/TOME_3001/081916a' ...
    '/data/jag/TOME/TOME_3002/082616a' ...
    '/data/jag/TOME/TOME_3003/090216' ...
    '/data/jag/TOME/TOME_3004/091916' ...
    };
session1Names               = {...
    'TOME_3001' ...
    'TOME_3002' ...
    'TOME_3003' ...
    'TOME_3004' ...
    };
% Session 2
session2Dirs = {...
    '/data/jag/TOME/TOME_3001/081916b' ...
    '/data/jag/TOME/TOME_3002/082616b' ...
    '/data/jag/TOME/TOME_3003/091616' ...
    '/data/jag/TOME/TOME_3003/092016' ...
    };
session1Names               = {...
    'TOME_3001' ...
    'TOME_3002' ...
    'TOME_3003' ...
    'TOME_3004' ...
    };
%% Create session 1 scripts
for i = 1:length(session1Dirs)
    params.sessionDir       = session1Dirs{i};
    params.subjectName      = session1Names{i};
    params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
    params.logDir           = logDir;
    params.jobName          = params.subjectName;
    params.numRuns          = 4;
    params.reconall         = 0;
    create_preprocessing_scripts(params);
end
%% Create session 2 scripts

%%% copy over the MPRAGE directory session 1 %%%

for i = 1:length(session1Dirs)
    params.sessionDir       = session1Dirs{i};
    params.subjectName      = session1Names{i};
    params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
    params.logDir           = logDir;
    params.jobName          = params.subjectName;
    params.numRuns          = 10;
    params.reconall         = 0;
    create_preprocessing_scripts(params);
end

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
