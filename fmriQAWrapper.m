function fmriQAWrapper(params, dropboxDir, clusterDir, clusterSessionDate)
% this function is a wrapper for use in HCLV_MASTER. This help reducing the
% dimension of the master scripts and ease the changes of code across
% subjects.

qaParams.sessionDir = fullfile(clusterDir,params.subjectName,clusterSessionDate);
qaParams.outDir = fullfile(dropboxDir,'TOME_analysis',params.projectSubfolder, ...
    params.subjectName,params.sessionDate,'PreprocessingQA');
if ~exist (qaParams.outDir,'dir')
    mkdir (qaParams.outDir)
end
tomeQA(qaParams)
fmriQA(qaParams)
end

