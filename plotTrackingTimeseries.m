function plotTrackingTimeseries (dropboxDir, params)
% makes color coded plot for the tracking results of trackPupil.m before
% any processing or alignment. This is useful to assess the quality of the tracking.
%

%% index all necessary files
% look for runs in each date
trackFiles = dir(fullfile(dropboxDir, 'TOME_processing', params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*pupilTrack.mat'));
paramsFiles = dir(fullfile(dropboxDir, 'TOME_processing', params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*trackingParams.mat'));


% define eyeTrackingQAfolder
eyeQAdir = fullfile(dropboxDir, params.analysisDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate, 'EyeTrackingQA');
if ~exist (eyeQAdir, 'dir')
    mkdir (eyeQAdir)
end

% % load all runs in an array
% for rr = 1 :length(trackFiles) %loop in runs
%     trackArray(rr) = load(fullfile(dropboxDir, 'TOME_processing', params.projectSubfolder, ...
%         params.subjectName,params.sessionDate,params.eyeTrackingDir,trackFiles(rr).name));
% end

% define run types
runType = {...
    'REST' ...
    'MOVIE' ...
    'RETINO' ...
    'FLASH' ...
    };

%% for every run type, plot the glint position

for tt = 1: length(runType)
    runCT = 0;
    h = fullFigure;
    for ii = 1 : length(trackFiles)
        % load variables
        trackData = load(fullfile(dropboxDir, 'TOME_processing', params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,trackFiles(ii).name));
        trackParams = load(fullfile(dropboxDir, 'TOME_processing', params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,paramsFiles(ii).name));
        % bin plots according to type
        if regexp(trackFiles(ii).name,regexptranslate('wildcard',['*' runType{tt} '*']))
            runCT = runCT+1;
            % check if flash runs
            if strcmp( runType(tt) , 'FLASH')
                subplot(2,1,runCT)
            else
                subplot(2,2,runCT)
            end
            % plot glint X
            plot(trackData.glint.X, 'b')
            hold on
            plot (trackData.glint.Y, ':b')
            hold off
            str = [num2str(round(length(find(~isnan(trackData.glint.X)))/length(trackData.glint.X) *100)) '% of samples tracked'];
            text(1000,40,str)
            ylim ([0 320])
            xlim ([0 length(trackData.glint.X)])
            title ([trackParams.params.subjectName ' ' trackParams.params.runName], 'Interpreter' , 'none')
            xlabel ('frames')
            ylabel('pixels')
            legend ('X position', 'Y position')
            
        end
        %adjustments
        axesHandles = findobj(h, 'type', 'axes');
        set(axesHandles, 'TickDir', 'out');
        set(h, 'PaperPosition', [0 0 16 9]);
        set(h, 'PaperSize', [16 9]);
        
                % clear variables
        clear trackData trackParams
        
    end
        if runCT ~= 0
            saveas(h, fullfile(eyeQAdir, [params.subjectName '_' runType{tt} '_GLINT_rawTimeseries']), 'pdf') %Save figure
        end

        close all
end

%% for every run type, plot the color coded pupil position

for tt = 1: length(runType)
    runCT = 0;
    h = fullFigure;
    for ii = 1 : length(trackFiles)
        % load variables
        trackData = load(fullfile(dropboxDir, 'TOME_processing', params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,trackFiles(ii).name));
        trackParams = load(fullfile(dropboxDir, 'TOME_processing', params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,paramsFiles(ii).name));
        
        % bin data according to flags
        red = find(trackData.pupil.flags.highCutError);
        yellow = find(trackData.pupil.flags.cutPupil);
        green = find (trackData.pupil.flags.cutPupil == 0);
        
        redTrackX = nan(length(trackData.pupil.X),1);
        yellowTrackX = nan(length(trackData.pupil.X),1);
        greenTrackX = nan(length(trackData.pupil.X),1);
        
        redTrackY = nan(length(trackData.pupil.X),1);
        yellowTrackY = nan(length(trackData.pupil.X),1);
        greenTrackY = nan(length(trackData.pupil.X),1);
        
        redTrackX(red) = trackData.pupil.X(red);
        yellowTrackX(yellow) = trackData.pupil.X(yellow);
        greenTrackX(green) = trackData.pupil.X(green);
        
        redTrackY(red) = trackData.pupil.Y(red);
        yellowTrackY(yellow) = trackData.pupil.Y(yellow);
        greenTrackY(green) = trackData.pupil.Y(green);
        % bin plots according to type
        if regexp(trackFiles(ii).name,regexptranslate('wildcard',['*' runType{tt} '*']))
            runCT = runCT+1;
            % check if flash runs
            if strcmp( runType(tt) , 'FLASH')
                subplot(2,1,runCT)
            else
                subplot(2,2,runCT)
            end
            % plot glint X
            plot(greenTrackX, 'g')
            hold on
            plot(yellowTrackX, 'y')
            hold on
            plot(redTrackX, 'r')
            hold on
            plot (greenTrackY, ':g')
            hold on
            plot(yellowTrackY, ':y')
            hold on
            plot(redTrackY, ':r')
            hold on
            plot(trackData.pupil.distanceErrorMetric, 'b', 'LineWidth', 2)
            hold on
            plot(trackData.pupil.cutDistanceErrorMetric, 'k', 'LineWidth', 2)
            
            hold off
            str = [num2str(round(length(find(~isnan(trackData.glint.X)))/length(trackData.glint.X) *100)) '% of samples tracked'];
            text(1000,40,str)
            ylim ([0 320])
            xlim ([0 length(trackData.glint.X)])
            title ([trackParams.params.subjectName ' ' trackParams.params.runName], 'Interpreter' , 'none')
            xlabel ('frames')
            ylabel('pixels')
            legend ('X position (uncut pupil)', 'X position (cut pupil)', 'X position (high error after cut pupil)', ...
                'Y position (uncut pupil)', 'Y position (cut pupil)', 'Y position (high error after cut pupil)', ...
                'Uncut pupil Error', 'Cut pupil Error')
            
        end
        %adjustments
        axesHandles = findobj(h, 'type', 'axes');
        set(axesHandles, 'TickDir', 'out');
        set(h, 'PaperPosition', [0 0 16 9]);
        set(h, 'PaperSize', [16 9]);
       
                % clear variables
        clear trackData trackParams redTrackX yellowTrackX greenTrackX  redTrackY yellowTrackY greenTrackY
        
    end
        if runCT ~= 0
            saveas(h, fullfile(eyeQAdir, [params.subjectName '_' runType{tt} '_PUPIL_rawTimeseries']), 'pdf') %Save figure
        end

        close all
end

%% for every run type, plot the color coded ellipse ratio

for tt = 1: length(runType)
    runCT = 0;
    h = fullFigure;
    for ii = 1 : length(trackFiles)
        % load variables
        trackData = load(fullfile(dropboxDir, 'TOME_processing', params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,trackFiles(ii).name));
        trackParams = load(fullfile(dropboxDir, 'TOME_processing', params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,paramsFiles(ii).name));
        
        % bin data according to flags
        red = find(trackData.pupil.flags.highCutError);
        yellow = find(trackData.pupil.flags.cutPupil);
        green = find (trackData.pupil.flags.cutPupil == 0);
        
        redTrackRatio = nan(length(trackData.pupil.X),1);
        yellowTrackRatio = nan(length(trackData.pupil.X),1);
        greenTrackRatio = nan(length(trackData.pupil.X),1);
        
        bigRad = trackData.pupil.explicitEllipseParams(:,3);
        smallRad = trackData.pupil.explicitEllipseParams(:,4);
        radRatio = smallRad./ bigRad;
        
        bigRadCut = trackData.pupil.cutExplicitEllipseParams(:,3);
        smallRadCut = trackData.pupil.cutExplicitEllipseParams(:,4);
        radRatioCut = smallRadCut./ bigRadCut;
        
        redTrackRatio(red) = radRatioCut(red);
        yellowTrackRatio(yellow) = radRatioCut(yellow);
        greenTrackRatio(green) = radRatio(green);
        
        redTrackY(red) = trackData.pupil.Y(red);
        yellowTrackY(yellow) = trackData.pupil.Y(yellow);
        greenTrackY(green) = trackData.pupil.Y(green);
        % bin plots according to type
        if regexp(trackFiles(ii).name,regexptranslate('wildcard',['*' runType{tt} '*']))
            runCT = runCT+1;
            % check if flash runs
            if strcmp( runType(tt) , 'FLASH')
                subplot(2,1,runCT)
            else
                subplot(2,2,runCT)
            end
            % plot glint X
            plot(greenTrackRatio,  'g')
            hold on
            plot(yellowTrackRatio, 'y')
            hold on
            plot(redTrackRatio, 'r')
            hold on
            plot(trackData.pupil.distanceErrorMetric, 'b', 'LineWidth', 2)
            hold on
            plot(trackData.pupil.cutDistanceErrorMetric, 'k', 'LineWidth', 2)
            hold off
            str = [num2str(round(length(find(~isnan(trackData.glint.X)))/length(trackData.glint.X) *100)) '% of samples tracked'];
            text(1000,0.2,str)
            ylim ([0 1.1])
            xlim ([0 length(trackData.glint.X)])
            title ([trackParams.params.subjectName ' ' trackParams.params.runName], 'Interpreter' , 'none')
            xlabel ('frames')
            ylabel('Axes ratio (minor axis/major axis)')
            legend ('uncut pupil', 'cut pupil', 'high error after cut pupil',...
                'Uncut pupil Error', 'Cut pupil Error')
        end
        %adjustments
        axesHandles = findobj(h, 'type', 'axes');
        set(axesHandles, 'TickDir', 'out');
        set(h, 'PaperPosition', [0 0 16 9]);
        set(h, 'PaperSize', [16 9]);
        
                % clear variables
        clear trackData trackParams redTrackRatio yellowTrackRatio greenTrackRatio
        
    end
        if runCT ~= 0
            saveas(h, fullfile(eyeQAdir, [params.subjectName '_' runType{tt} '_ELLIPSERATIO_rawTimeseries']), 'pdf') %Save figure
        end

        close all
end




%% 
for tt = 1: length(runType)
    runCT = 0;
    h = fullFigure;
    for ii = 1 : length(trackFiles)
        % load variables
        trackData = load(fullfile(dropboxDir, 'TOME_processing', params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,trackFiles(ii).name));
        trackParams = load(fullfile(dropboxDir, 'TOME_processing', params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,paramsFiles(ii).name));
        
        % bin data according to flags
        red = find(trackData.pupil.flags.highCutError);
        yellow = find(trackData.pupil.flags.cutPupil);
        green = find (trackData.pupil.flags.cutPupil == 0);
        
        redTrackRatio = nan(length(trackData.pupil.X),1);
        yellowTrackRatio = nan(length(trackData.pupil.X),1);
        greenTrackRatio = nan(length(trackData.pupil.X),1);
        
        bigRad = trackData.pupil.explicitEllipseParams(:,3);
        smallRad = trackData.pupil.explicitEllipseParams(:,4);
        radRatio = smallRad./ bigRad;
        
        bigRadCut = trackData.pupil.cutExplicitEllipseParams(:,3);
        smallRadCut = trackData.pupil.cutExplicitEllipseParams(:,4);
        radRatioCut = smallRadCut./ bigRadCut;
        
        redTrackRatio(red) = radRatioCut(red);
        yellowTrackRatio(yellow) = radRatioCut(yellow);
        greenTrackRatio(green) = radRatio(green);
        
        redTrackY(red) = trackData.pupil.Y(red);
        yellowTrackY(yellow) = trackData.pupil.Y(yellow);
        greenTrackY(green) = trackData.pupil.Y(green);
        % bin plots according to type
        if regexp(trackFiles(ii).name,regexptranslate('wildcard',['*' runType{tt} '*']))
            runCT = runCT+1;
            % check if flash runs
            if strcmp( runType(tt) , 'FLASH')
                subplot(2,1,runCT)
            else
                subplot(2,2,runCT)
            end
            % plot glint X
            plot(greenTrackRatio,  'g')
            hold on
            plot(yellowTrackRatio, 'y')
            hold on
            plot(redTrackRatio, 'r')
            hold on
            plot(trackData.pupil.distanceErrorMetric, 'b', 'LineWidth', 2)
            hold on
            plot(trackData.pupil.cutDistanceErrorMetric, 'k', 'LineWidth', 2)
            hold off
            str = [num2str(round(length(find(~isnan(trackData.glint.X)))/length(trackData.glint.X) *100)) '% of samples tracked'];
            text(1000,0.2,str)
            ylim ([0 1.1])
            xlim ([0 length(trackData.glint.X)])
            title ([trackParams.params.subjectName ' ' trackParams.params.runName], 'Interpreter' , 'none')
            xlabel ('frames')
            ylabel('Axes ratio (minor axis/major axis)')
            legend ('uncut pupil', 'cut pupil', 'high error after cut pupil',...
                'Uncut pupil Error', 'Cut pupil Error')
        end
        %adjustments
        axesHandles = findobj(h, 'type', 'axes');
        set(axesHandles, 'TickDir', 'out');
        set(h, 'PaperPosition', [0 0 16 9]);
        set(h, 'PaperSize', [16 9]);
        
                % clear variables
        clear trackData trackParams redTrackRatio yellowTrackRatio greenTrackRatio
        
    end
        if runCT ~= 0
            saveas(h, fullfile(eyeQAdir, [params.subjectName '_' runType{tt} '_PupilArea_rawTimeseries']), 'pdf') %Save figure
        end

        close all
end