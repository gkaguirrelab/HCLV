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
            plot(trackData.glint.X, 'color', [0.4 0.6 0.6])
            hold on
            plot (trackData.glint.Y, 'color', [1 0.4 0.4])
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
            saveas(h, fullfile(eyeQAdir, [params.subjectName '_' runType{tt} '_glint_rawTimeseries']), 'pdf') %Save figure
        end

        close all
end

%% for every run type, plot the color coded pupil position

for tt = 1: length(runType)
    runCT = 0;
    h = fullFigure;    
    % set double axes colors
    left_color = [0 0.4 0.4];
    right_color = [1 0.2 0.4];
    set(h,'defaultAxesColorOrder',[left_color; right_color]);
    for ii = 1 : length(trackFiles)
        % load variables
        trackData = load(fullfile(dropboxDir, 'TOME_processing', params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,trackFiles(ii).name));
        trackParams = load(fullfile(dropboxDir, 'TOME_processing', params.projectSubfolder, ...
            params.subjectName,params.sessionDate,params.eyeTrackingDir,paramsFiles(ii).name));
        
        % bin data according to flags
        
        cut = find(trackData.pupil.flags.cutPupil);
        full = find (trackData.pupil.flags.cutPupil == 0);
        
        cutX = nan(length(trackData.pupil.X),1);
        fullX = nan(length(trackData.pupil.X),1);
              
        cutY = nan(length(trackData.pupil.X),1);
        fullY = nan(length(trackData.pupil.X),1);
        
        cutX(cut) = trackData.pupil.X(cut);
        fullX(full) = trackData.pupil.X(full);
        
        cutY(cut) = trackData.pupil.Y(cut);
        fullY(full) = trackData.pupil.Y(full);
        
        % bin plots according to type
        if regexp(trackFiles(ii).name,regexptranslate('wildcard',['*' runType{tt} '*']))
            runCT = runCT+1;
            % check if flash runs
            if strcmp( runType(tt) , 'FLASH')
                subplot(2,1,runCT)
            else
                subplot(2,2,runCT)
            end
  
            yyaxis left
            % plot pupil position
            plot(fullX, 'LineWidth', 2)%, 'color', [0.4 0.4 0.4])
            hold on
            plot(cutX, '-')%, 'color', [1 0.4 0.2])
            hold on 
            plot (fullY, '-k','LineWidth', 2)%,'color', [0.4 0.4 0.4])
            hold on
            plot(cutY, '-k')%,'color', [1 0.4 0.2])
            hold off
            str = [num2str(round(length(find(~isnan(trackData.glint.X)))/length(trackData.glint.X) *100)) '% of samples tracked'];
            text(1000,40,str)
            ylim ([0 320])
            ylabel('pixels')
            
            yyaxis right
            area(trackData.pupil.cutDistanceErrorMetric,'EdgeColor', 'none','FaceColor','r','FaceAlpha',.3,'EdgeAlpha',.1)
            hold off
            ylabel('Error Metric on cut pupil')
            ylim([0 30])
            
%             plot(trackData.pupil.cutDistanceErrorMetric, 'color', [0.2 0.4 0.6])
            
            hold off

            xlim ([0 length(trackData.glint.X)])
            title ([trackParams.params.subjectName ' ' trackParams.params.runName], 'Interpreter' , 'none')
            xlabel ('frames')
           
            legend ('X position (uncut pupil)', 'X position (cut pupil)', ...
                'Y position (uncut pupil)', 'Y position (cut pupil)',  ...
                'Cut pupil Error')
            
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
            saveas(h, fullfile(eyeQAdir, [params.subjectName '_' runType{tt} '_pupil_rawTimeseries']), 'pdf') %Save figure
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
            area(trackData.pupil.distanceErrorMetric ./100, 'EdgeColor', 'none','FaceColor','g','FaceAlpha',.1)
            hold on
            area(trackData.pupil.cutDistanceErrorMetric ./100, 'EdgeColor', 'none','FaceColor','k','FaceAlpha',.1)
            hold off
            str = [num2str(round(length(find(~isnan(trackData.glint.X)))/length(trackData.glint.X) *100)) '% of samples tracked'];
            text(1000,0.2,str)
            ylim ([0 1.1])
            xlim ([0 length(trackData.glint.X)])
            title ([trackParams.params.subjectName ' ' trackParams.params.runName], 'Interpreter' , 'none')
            xlabel ('frames')
            ylabel('Axes ratio (minor axis/major axis)')
            legend ('uncut pupil', 'cut pupil', 'high error after cut pupil',...
                'Uncut pupil Error/100', 'Cut pupil Error/100')
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



%% Plot ellipse area
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
        cut = find(trackData.pupil.flags.cutPupil);
        full = find (trackData.pupil.flags.cutPupil == 0);
        
        
        cutArea = nan(length(trackData.pupil.X),1);
        fullArea = nan(length(trackData.pupil.X),1);
        
        bigRad = trackData.pupil.explicitEllipseParams(:,3);
        smallRad = trackData.pupil.explicitEllipseParams(:,4);
        fA = pi .* smallRad .* bigRad;
        
        bigRadCut = trackData.pupil.cutExplicitEllipseParams(:,3);
        smallRadCut = trackData.pupil.cutExplicitEllipseParams(:,4);
        cA = pi .* smallRadCut .* bigRadCut;
        
        
        cutArea(cut) = cA(cut);
        fullArea(full) = fA(full);
        % set double axes colors
        left_color = [0 0.4 0.4];
        right_color = [1 0.2 0.4];
        set(h,'defaultAxesColorOrder',[left_color; right_color]);
        % bin plots according to type
        if regexp(trackFiles(ii).name,regexptranslate('wildcard',['*' runType{tt} '*']))
            runCT = runCT+1;
            % check if flash runs
            if strcmp( runType(tt) , 'FLASH')
                subplot(2,1,runCT)
            else
                subplot(2,2,runCT)
            end
            % plot 
            
            yyaxis left
            plot(fullArea,'LineWidth', 1)
            hold on
            plot(cutArea, '-k', 'LineWidth', 1)%,'Color',[1 0.4 0.2])
            hold off
            str = [num2str(round(length(find(~isnan(trackData.glint.X)))/length(trackData.glint.X) *100)) '% of samples tracked'];
            text(1000,200,str)
            ylim([0 5000])
            ylabel('Square Pixels')
            legend ('uncut pupil area', 'cut pupil area')
            
            yyaxis right
            area(trackData.pupil.cutDistanceErrorMetric,'EdgeColor', 'none','FaceColor','r','FaceAlpha',.3,'EdgeAlpha',.1)
            ylabel('Error Metric on cut pupil')
            ylim([0 30])
            
            xlim ([0 length(trackData.glint.X)])
            title ([trackParams.params.subjectName ' ' trackParams.params.runName], 'Interpreter' , 'none')
            xlabel ('frames')
            
            
                
        end
        %adjustments
        axesHandles = findobj(h, 'type', 'axes');
        set(axesHandles, 'TickDir', 'out');
        set(h, 'PaperPosition', [0 0 16 9]);
        set(h, 'PaperSize', [16 9]);
        
                % clear variables
        clear trackData trackParams fullArea cutArea full cut
        
    end
        if runCT ~= 0
            saveas(h, fullfile(eyeQAdir, [params.subjectName '_' runType{tt} '_PupilArea_rawTimeseries']), 'pdf') %Save figure
        end

        close all
end