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
        if regexp(responseArray(rr).response.metadata.runName,regexptranslate('wildcard',['*' runType{tt} '*']))
            runCT = runCT+1;
            % find zero in timebase
            zeroFrame = find (~responseArray(rr).response.timeBase);
            if isempty(zeroFrame)
                warning(['TimeBase problem for ' responseArray(rr).response.metadata.subjectName responseArray(rr).response.metadata.runName ])
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
                str = [num2str(trackedFrames/totalFrames *100) '% of samples tracked'];
                str2 = ['Median pupil size ' setstr(177) ' SD = ' num2str(medianSize) setstr(177) num2str(stdSize)];
                text(1000,2,str)
                text(1000,1,str2)
                ylim ([0 10])
                xlim ([0 20161])
                ax = gca;
                ax.XTick = [0:framesPerTR*10:totalFrames];
                ax.XTick = [0:framesPerTR*20:totalFrames];
                ax.XTickLabel = [0:20:420];
                title ([responseArray(rr).response.metadata.subjectName responseArray(rr).response.metadata.runName], 'Interpreter' , 'none')
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
        saveas(h, fullfile(eyeQAdir, [responseArray(rr).response.metadata.subjectName '_' runType{tt} '_Timeseries']), 'pdf') %Save figure
    end
    close all
end

%% make cartesian plots of the gaze
for tt = 1: length(runType)
    
    runCT = 0;
    h = fullFigure;
    for rr= 1 :length(runs)
        if regexp(responseArray(rr).response.metadata.runName,regexptranslate('wildcard',['*' runType{tt} '*']))
            runCT = runCT+1;
            % find zero in timebase
            zeroFrame = find (~responseArray(rr).response.timeBase);
            if isempty(zeroFrame)
                warning(['TimeBase problem for ' responseArray(rr).response.metadata.subjectName responseArray(rr).response.metadata.runName ])
            else
                if strcmp( runType(tt) , 'FLASH')
                    subplot(2,1,runCT)
                else
                    subplot(2,2,runCT)
                end
                rectangle('Position',[-700/2 -400/2 700 400])
                hold on
                plot (0,0, '+r')
                hold on
                scatter([responseArray(rr).response.gazeX(zeroFrame : zeroFrame + totalFrames)],[responseArray(rr).response.gazeY(zeroFrame : zeroFrame + totalFrames)], ...
                    16, 'filled', ...
                    'MarkerEdgeColor', 'none', ...
                    'MarkerFaceColor', [255 0 0]/255, ...
                    'MarkerFaceAlpha', 0.01);
                title ([responseArray(rr).response.metadata.subjectName responseArray(rr).response.metadata.runName], 'Interpreter' , 'none')
                axis equal
                axis ij
                ylim ([-300 300])
                xlim ([-500 500])
                xlabel ('Viewfield x dimention [mm]')
                ylabel('Viewfield y dimention [mm]')
                
            end
        end
    end
    %adjustments
    axesHandles = findobj(h, 'type', 'axes');
    set(axesHandles, 'TickDir', 'out');
    set(h, 'PaperPosition', [0 0 16 9]);
    set(h, 'PaperSize', [16 9]);
    
    if runCT ~= 0
    saveas(gcf, fullfile(eyeQAdir, [responseArray(rr).response.metadata.subjectName '_' runType{tt} '_gaze']), 'png') %Save figure
    end
    close all
end





