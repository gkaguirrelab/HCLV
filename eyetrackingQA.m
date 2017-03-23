function eyetrackingQA (dropboxDir, params)

% makes QA plots for eyetracking


% look for runs in each date
runs = dir(fullfile(dropboxDir, params.analysisDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate,params.eyeTrackingDir,'*response.mat'));

% define eyeTrackingQAfilder
eyeQAdir = fullfile(dropboxDir, params.analysisDir, params.projectSubfolder, ...
    params.subjectName,params.sessionDate, 'EyeTrackingQA');
if ~exist (eyeQAdir, 'dir')
    mkdir (eyeQAdir)
end

% load all runs in an array
for rr = 1 :length(runs) %loop in runs
    responseArray(rr) = load(fullfile(dropboxDir, params.analysisDir, params.projectSubfolder, ...
        params.subjectName,params.sessionDate,params.eyeTrackingDir,runs(rr).name));
    clear response
end

% get total frames
nTR = 420;
TRlength = 0.8; %[sec]
acqRate = 60; %[Hz]
framesPerTR = TRlength/(1/acqRate);
totalFrames = nTR * framesPerTR;
f = 1065; %[mm]

runType = {...
    'REST' ...
    'MOVIE' ...
    'RETINO' ...
    'FLASH' ...
    };

%% plot pupil size
for tt = 1: length(runType)
    runCT = 0;
    h = fullFigure;
    for rr= 1 :length(runs)
        if regexp(responseArray(rr).response.metaData.runName,regexptranslate('wildcard',['*' runType{tt} '*']))
            runCT = runCT+1;
            % find zero in timebase
            zeroFrame = find (~responseArray(rr).response.timebase);
            if isempty(zeroFrame)
                warning(['TimeBase problem for ' responseArray(rr).response.metaData.subjectName responseArray(rr).response.metaData.runName ])
            else
                if strcmp( runType(tt) , 'FLASH')
                    subplot(2,1,runCT)
                else
                    subplot(2,2,runCT)
                end
                trackedFrames = length(find(~isnan([responseArray(rr).response.pupilSize(zeroFrame : zeroFrame + totalFrames)])));
                medianSize = nanmedian(responseArray(rr).response.pupilSize(zeroFrame : zeroFrame + totalFrames));
                stdSize = nanstd(responseArray(rr).response.pupilSize(zeroFrame : zeroFrame + totalFrames));
                plot([responseArray(rr).response.pupilSize(zeroFrame : zeroFrame + totalFrames)])
                str = [num2str(round(trackedFrames/totalFrames *100)) '% of samples tracked'];
                str2 = ['Median pupil size ' setstr(177) ' SD = ' num2str(round(medianSize,2)) setstr(177) num2str(round(stdSize,2))];
                text(1000,2,str)
                text(1000,1,str2)
                ylim ([0 11])
                xlim ([0 20161])
                ax = gca;
                ax.XTick = [0:framesPerTR*10:totalFrames];
                ax.XTick = [0:framesPerTR*20:totalFrames];
                ax.XTickLabel = [0:20:420];
                title ([responseArray(rr).response.metaData.subjectName responseArray(rr).response.metaData.runName], 'Interpreter' , 'none')
                xlabel ('TR')
                ylabel('Pupil diameter [mm]')
            end
        end
    end
    %adjustments
    axesHandles = findobj(h, 'type', 'axes');
    set(axesHandles, 'TickDir', 'out');
    set(h, 'PaperPosition', [0 0 16 9]);
    set(h, 'PaperSize', [16 9]);
    
    if runCT ~= 0
        saveas(h, fullfile(eyeQAdir, [responseArray(rr).response.metaData.subjectName '_' runType{tt} '_Timeseries']), 'pdf') %Save figure
    end
    close all
end

%% make cartesian plots of the gaze
for tt = 1: length(runType)
    
    runCT = 0;
    h = fullFigure;
    for rr= 1 :length(runs)
        if regexp(responseArray(rr).response.metaData.runName,regexptranslate('wildcard',['*' runType{tt} '*']))
            runCT = runCT+1;
            % find zero in timebase
            zeroFrame = find (~responseArray(rr).response.timebase);
            if isempty(zeroFrame)
                warning(['TimeBase problem for ' responseArray(rr).response.metaData.subjectName responseArray(rr).response.metaData.runName ])
            else
                if strcmp( runType(tt) , 'FLASH')
                    subplot(2,1,runCT)
                else
                    subplot(2,2,runCT)
                end
                rectangle('Position',[-700/2 -400/2 700 400])
                hold on
                plot (0,0, '+k')
                hold on
                scatter([responseArray(rr).response.gazeX(zeroFrame : zeroFrame + totalFrames)],[responseArray(rr).response.gazeY(zeroFrame : zeroFrame + totalFrames)], ...
                    16, 'filled', ...
                    'MarkerEdgeColor', 'none', ...
                    'MarkerFaceColor', [255 0 0]/255, ...
                    'MarkerFaceAlpha', 0.01);
                if strcmp( runType(tt) , 'RETINO')
                    hold on
                    medianGazeX = nanmedian(responseArray(rr).response.gazeX(zeroFrame : zeroFrame + totalFrames));
                    medianGazeY = nanmedian(responseArray(rr).response.gazeY(zeroFrame : zeroFrame + totalFrames));
                    plot(medianGazeX,medianGazeY, '.k')
                    val = [' ( ' num2str(round(medianGazeX,2)) ' , ' num2str(round(medianGazeY,2)) ' )'];
                    text(medianGazeX,medianGazeY, val)
                end
                title ([responseArray(rr).response.metaData.subjectName responseArray(rr).response.metaData.runName], 'Interpreter' , 'none')
                axis equal
                axis ij
                ylim ([-300 300])
                xlim ([-500 500])
                xlabel ('Viewfield X dimension [mm]')
                ylabel('Viewfield Y dimension [mm]')
                
            end
        end
    end
    %adjustments
    axesHandles = findobj(h, 'type', 'axes');
    set(axesHandles, 'TickDir', 'out');
    set(h, 'PaperPosition', [0 0 16 9]);
    set(h, 'PaperSize', [16 9]);
    
    if runCT ~= 0
        saveas(gcf, fullfile(eyeQAdir, [responseArray(rr).response.metaData.subjectName '_' runType{tt} '_gaze']), 'png') %Save figure
    end
    close all
end

%% make timeseries of the gaze cartesian coordinates
for tt = 1: length(runType)
    runCT = 0;
    h = fullFigure;
    for rr= 1 :length(runs)
        if regexp(responseArray(rr).response.metaData.runName,regexptranslate('wildcard',['*' runType{tt} '*']))
            runCT = runCT+1;
            % find zero in timebase
            zeroFrame = find (~responseArray(rr).response.timebase);
            if isempty(zeroFrame)
                warning(['TimeBase problem for ' responseArray(rr).response.metaData.subjectName responseArray(rr).response.metaData.runName ])
            else
                if strcmp( runType(tt) , 'FLASH')
                    subplot(2,1,runCT)
                else
                    subplot(2,2,runCT)
                end
                trackedFrames = length(find(~isnan([responseArray(rr).response.pupilSize(zeroFrame : zeroFrame + totalFrames)])));
                plot([responseArray(rr).response.gazeX(zeroFrame : zeroFrame + totalFrames)])
                hold on
                plot([responseArray(rr).response.gazeY(zeroFrame : zeroFrame + totalFrames)])
                str = [num2str(round(trackedFrames/totalFrames *100,2)) '% of samples tracked'];
                text(1000,-450,str)
                ylim ([-500 500])
                xlim ([0 20161])
                ax = gca;
                ax.XTick = [0:framesPerTR*10:totalFrames];
                ax.XTick = [0:framesPerTR*20:totalFrames];
                ax.XTickLabel = [0:20:420];
                title ([responseArray(rr).response.metaData.subjectName responseArray(rr).response.metaData.runName], 'Interpreter' , 'none')
                legend('X position of the Gaze', 'Y position of the gaze')
                xlabel ('TR')
                ylabel('Distance from center of the screen [mm]')
            end
        end
    end
    %adjustments
    axesHandles = findobj(h, 'type', 'axes');
    set(axesHandles, 'TickDir', 'out');
    set(h, 'PaperPosition', [0 0 16 9]);
    set(h, 'PaperSize', [16 9]);
    
    if runCT ~= 0
        saveas(h, fullfile(eyeQAdir, [responseArray(rr).response.metaData.subjectName '_' runType{tt} '_GazeTimeseries']), 'pdf') %Save figure
    end
    close all
end

%% make polar plots of the gaze

for tt = 1: length(runType)
    
    runCT = 0;
    h = fullFigure;
    for rr= 1 :length(runs)
        if regexp(responseArray(rr).response.metaData.runName,regexptranslate('wildcard',['*' runType{tt} '*']))
            runCT = runCT+1;
            % find zero in timebase
            zeroFrame = find (~responseArray(rr).response.timebase);
            if isempty(zeroFrame)
                warning(['TimeBase problem for ' responseArray(rr).response.metaData.subjectName responseArray(rr).response.metaData.runName ])
            else
                if strcmp( runType(tt) , 'FLASH')
                    subplot(2,1,runCT)
                else
                    subplot(2,2,runCT)
                end
                % check if polarscatter is on the path (from matlab 2016b)
                PS = which('polarscatter');
                if isempty(PS)
                    t = 0 : .01 : 2 * pi;
                    P = polar(t, 25 * ones(size(t)));
                    set(P, 'Visible', 'off')
                    hold on
                    polar(deg2rad([responseArray(rr).response.gazePol(zeroFrame : zeroFrame + totalFrames)]),[responseArray(rr).response.gazeEcc(zeroFrame : zeroFrame + totalFrames)], ...
                        '.');
                    title ([responseArray(rr).response.metaData.subjectName responseArray(rr).response.metaData.runName], 'Interpreter' , 'none')
                    view([180 90])
                    view ([90, - 90])
                else
                    t = 0 : .01 : 2 * pi;
                    P = polarplot(t, 25 * ones(size(t)));
                    set(P, 'Visible', 'off')
                    hold on
                    polarscatter(deg2rad([responseArray(rr).response.gazePol(zeroFrame : zeroFrame + totalFrames)]),[responseArray(rr).response.gazeEcc(zeroFrame : zeroFrame + totalFrames)],6, 'filled', ...
                        'MarkerEdgeColor', 'none', ...
                        'MarkerFaceColor', [255 0 0]/255, ...
                        'MarkerFaceAlpha', 0.01);
                    if strcmp( runType(tt) , 'RETINO')
                        hold on
                        medianGazeEcc = nanmedian(responseArray(rr).response.gazeEcc(zeroFrame : zeroFrame + totalFrames));
                        medianGazePol = nanmedian(responseArray(rr).response.gazePol(zeroFrame : zeroFrame + totalFrames));
                        polarplot(deg2rad(medianGazePol),medianGazeEcc, '.k')
                        val = [' ( ' num2str(round(medianGazeEcc,2)) ' , ' num2str(round(medianGazePol,2)) ' )'];
                        text(deg2rad(medianGazePol),medianGazeEcc, val)
                    end
                    
                    title ([responseArray(rr).response.metaData.subjectName responseArray(rr).response.metaData.runName], 'Interpreter' , 'none')
                    ax = gca;
                    d = ax.ThetaDir;
                    ax.ThetaDir = 'clockwise';
                    ax.ThetaZeroLocation= 'top';
                    ax.RLim = [0 30];
                end  
            end
        end
    end
    %adjustments
    axesHandles = findobj(h, 'type', 'axes');
    set(axesHandles, 'TickDir', 'out');
    set(h, 'PaperPosition', [0 0 16 9]);
    set(h, 'PaperSize', [16 9]);
    
    if runCT ~= 0
        saveas(gcf, fullfile(eyeQAdir, [responseArray(rr).response.metaData.subjectName '_' runType{tt} '_gazePol']), 'png') %Save figure
    end
    close all
end




