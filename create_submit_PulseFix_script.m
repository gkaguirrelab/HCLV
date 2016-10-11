function create_submit_PulseFix_script(params)

% Writes shell script to submit scripts to fix a bug with Siemens pulse data
%
%   Usage:
%   create_submit_PulseFix_script(params)
%
%   Written by Andrew S Bock Oct 2016

%% set defaults
fname = fullfile(params.outDir,['submit_' params.jobName '_fixPulse.sh']);
fid = fopen(fname,'w');
%% Add all scripts
fprintf(fid,['qsub -l h_vmem=' num2str(params.fmem) ...
    '.2G,s_vmem=' num2str(params.fmem) 'G -e ' params.logDir ' -o ' params.logDir ' ' ...
    fullfile(params.outDir,[params.jobName '_fixPulse.sh'])]);
fclose(fid);