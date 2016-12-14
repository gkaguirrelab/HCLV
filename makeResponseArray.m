function [responseArray] = makeResponseArray(params,dropboxDir)


% Set Dropbox directory
%get hostname (for melchior's special dropbox folder settings)
[~,hostname] = system('hostname');
hostname = strtrim(lower(hostname));
if strcmp(hostname,'melchior.uphs.upenn.edu');
    dropboxDir = '/Volumes/Bay_2_data/giulia/Dropbox-Aguirre-Brainard-Lab';
else
    % Get user name
    [~, tmpName] = system('whoami');
    userName = strtrim(tmpName);
    dropboxDir = ['/Users/' userName '/Dropbox-Aguirre-Brainard-Lab'];
end

% project params
params.outputDir = 'CumulativeAnalyses';
params.projectFolder = 'TOME_analysis';
params.projectSubfolder = 'session*';
params.subjNaming = 'TOME_3*';
params.eyeTrackingDir = 'EyeTracking';

sessions = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder));
for cc = 1 : length(sessions) % loop in sessions

 % look for subjects in each session
    subjects = dir(fullfile(dropboxDir, params.projectFolder, sessions(cc).name, params.subjNaming));
    if isempty(subjects)
        continue
    else
        for ss = 1 : length(subjects) % loop in subjects
            % look for dates in each subject and check if folder is valid
            datesTMP = dir(fullfile(dropboxDir, params.projectFolder, sessions(cc).name, subjects(ss).name));
            cnt = 1;
            for jj = 1:length(datesTMP) % check if valid
                if datesTMP(jj).isdir && ~strcmp(datesTMP(jj).name,'.') && ~strcmp(datesTMP(jj).name,'..')
                    dates(cnt) = datesTMP(jj);
                    cnt = cnt +1;
                end
            end
            for dd = 1:length(dates) % loop in dates
                 % look for runs in each date
                runs = dir(fullfile(dropboxDir, params.projectFolder, sessions(cc).name, subjects(ss).name,dates(dd).name,params.eyeTrackingDir,'*response.mat'));
                for rr = 1 :length(runs) %loop in runs
                    % add fields in reportToProcess
                    load(fullfile(dropboxDir, params.projectFolder,sessions(cc).name, subjects(ss).name, dates(dd).name, params.eyeTrackingDir,runs(rr).name))
                    responseArray{cc,ss,dd,rr,1} = {sessions(cc).name, subjects(ss).name, dates(dd).name, runs(rr).name,response};
                    clear response
                end
            end
        end
    end
    clear subjects
    clear dates
    clear datesTMP
    clear runs
end

% save respons array
save (fullfile(dropboxDir, params.projectFolder,'responseArray.mat'),'responseArray')
                    