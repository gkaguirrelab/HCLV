function pupilRespStructWrapper (params,dropboxDir)
% this function is a wrapper for use in HCLV_MASTER. This helps reducing the
% dimension of the master scripts and ease the changes of code across
% subjects.

runs = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*.mov'));

for rr = 1 :length(runs) %loop in all video files
    fprintf ('\nProcessing video %d of %d\n',rr,length(runs))
    if regexp(runs(rr).name, regexptranslate('wildcard','*_raw.mov'))
        params.runName = runs(rr).name(1:end-8); %runs
        
        % make response struct
        params.trackType = 'Hybrid';
        [response] = makeResponseStruct(params,dropboxDir);
        
        if ~isempty (response)
            % save response struct
            outputDir = fullfile(dropboxDir, 'TOME_analysis', params.projectSubfolder, ...
                params.subjectName,params.sessionDate,params.eyeTrackingDir);
            if ~exist (outputDir,'dir')
                mkdir (outputDir)
            end
            save(fullfile(outputDir,[params.runName '_response.mat']),'response')
        else
            continue
        end
        clear response;
    else
        continue %calibrations
    end
end