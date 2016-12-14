function fmriPreprocessingWrapper(params, clusterDir, clusterSessionDate)
% this function is a wrapper for use in HCLV_MASTER. This help reducing the
% dimension of the master scripts and ease the changes of code across
% subjects.

params.sessionDir       = fullfile(clusterDir,params.subjectName,clusterSessionDate);
params.outDir           = fullfile(params.sessionDir,'preprocessing_scripts');
params.jobName          = params.subjectName;
create_preprocessing_scripts(params);

% also run dicom_sort, so that faulty runs can be identified easily
dicom_sort(fullfile(params.sessionDir, 'DICOMS'))
warning('Check on README file if some DICOM series needs to be discarded before preprocessing.')
end


