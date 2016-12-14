function deinterlaceWrapper (params,dropboxDir,clusterSessionDate,copyToCluster)
% this function is a wrapper for use in HCLV_MASTER. This helps reducing the
% dimension of the master scripts and ease the changes of code across
% subjects.

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
if copyToCluster
    fprintf ('\nCopying deinterlaced videos to the cluster (will take a while)...')
    copyfile (fullfile(dropboxDir,params.outputDir,params.projectSubfolder, ...
        params.subjectName,params.sessionDate,params.eyeTrackingDir,'*') , ...
        fullfile(clusterDir,params.subjectName,clusterSessionDate,params.eyeTrackingDir))
    fprintf('done!\n')
end