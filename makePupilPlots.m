% script to obtain several plots

%% loop in the responseArray to find and bin all runs for each session

% get total frames
nTR = 420;
TRlength = 0.8; %[sec]
acqRate = 60; %[Hz]
framesPerTR = TRlength/(1/acqRate);
totalFrames = nTR * framesPerTR;


nSessTypes = size(responseArray,1);
nSubjects = size(responseArray,2);
nSessions = size(responseArray,3);
nRuns = size(responseArray,4);

restCT = 1;
movieCT = 1;
retinoCT = 1;
flashCT = 1;
for st=1:nSessTypes
    for sj=1:nSubjects
        for ss=1:nSessions
            for rr=1:nRuns
                if ~isempty(responseArray{st,sj,ss,rr})
                    % bin the runs based on their name
                    if regexp(responseArray{st,sj,ss,rr,1}{4},regexptranslate('wildcard','*REST*'))
                        % find zero in timebase
                        zeroFrame = find (~responseArray{st,sj,ss,rr,1}{1,5}.timeBase);
                        if isempty(zeroFrame)
                            warning(['TimeBase problem for ' responseArray{st,sj,ss,rr,1}{1,5}.metadata.subjectName responseArray{st,sj,ss,rr,1}{1,5}.metadata.runName ])
                        else
                            % trim the response
                            restSize{sj,restCT} = responseArray{st,sj,ss,rr,1}{1,5}.pupilSize(zeroFrame : zeroFrame + totalFrames);
                            restPol{sj,restCT} = responseArray{st,sj,ss,rr,1}{1,5}.gazePol(zeroFrame : zeroFrame + totalFrames);
                            restEcc{sj,restCT} = responseArray{st,sj,ss,rr,1}{1,5}.gazeEcc(zeroFrame : zeroFrame + totalFrames);
                            restCT = restCT+1;
                        end
                    elseif regexp(responseArray{st,sj,ss,rr,1}{4},regexptranslate('wildcard','*MOVIE*'))
                        % find zero in timebase
                        zeroFrame = find (~responseArray{st,sj,ss,rr,1}{1,5}.timeBase);
                        if isempty(zeroFrame)
                            warning(['TimeBase problem for ' responseArray{st,sj,ss,rr,1}{1,5}.metadata.subjectName responseArray{st,sj,ss,rr,1}{1,5}.metadata.runName ])
                        else
                            % trim the response
                            movieSize{sj,movieCT} = responseArray{st,sj,ss,rr,1}{1,5}.pupilSize(zeroFrame : zeroFrame + totalFrames);
                            moviePol{sj,restCT} = responseArray{st,sj,ss,rr,1}{1,5}.gazePol(zeroFrame : zeroFrame + totalFrames);
                            movieEcc{sj,restCT} = responseArray{st,sj,ss,rr,1}{1,5}.gazeEcc(zeroFrame : zeroFrame + totalFrames);
                            movieCT = movieCT+1;
                        end
                    elseif regexp(responseArray{st,sj,ss,rr,1}{4},regexptranslate('wildcard','*RETINO*'))
                        % find zero in timebase
                        zeroFrame = find (~responseArray{st,sj,ss,rr,1}{1,5}.timeBase);
                        if isempty(zeroFrame)
                            warning(['TimeBase problem for ' responseArray{st,sj,ss,rr,1}{1,5}.metadata.subjectName responseArray{st,sj,ss,rr,1}{1,5}.metadata.runName ])
                        else
                            % trim the response
                            retinoSize{sj,retinoCT} = responseArray{st,sj,ss,rr,1}{1,5}.pupilSize(zeroFrame : zeroFrame + totalFrames);
                            retinoPol{sj,restCT} = responseArray{st,sj,ss,rr,1}{1,5}.gazePol(zeroFrame : zeroFrame + totalFrames);
                            retinoEcc{sj,restCT} = responseArray{st,sj,ss,rr,1}{1,5}.gazeEcc(zeroFrame : zeroFrame + totalFrames);
                            retinoCT = retinoCT+1;
                        end
                    elseif regexp(responseArray{st,sj,ss,rr,1}{4},regexptranslate('wildcard','*FLASH*'))
                        % find zero in timebase
                        zeroFrame = find (~responseArray{st,sj,ss,rr,1}{1,5}.timeBase);
                        if isempty(zeroFrame)
                            warning(['TimeBase problem for ' responseArray{st,sj,ss,rr,1}{1,5}.metadata.subjectName responseArray{st,sj,ss,rr,1}{1,5}.metadata.runName ])
                        else
                            % trim the response
                            flashSize{sj,flashCT} = responseArray{st,sj,ss,rr,1}{1,5}.pupilSize(zeroFrame : zeroFrame + totalFrames);
                            flashPol{sj,restCT} = responseArray{st,sj,ss,rr,1}{1,5}.gazePol(zeroFrame : zeroFrame + totalFrames);
                            flashEcc{sj,restCT} = responseArray{st,sj,ss,rr,1}{1,5}.gazeEcc(zeroFrame : zeroFrame + totalFrames);
                            flashCT = flashCT+1;
                        end
                    end
                end
            end
        end
        % reset the counter for the new subject
        restCT = 1;
        movieCT = 1;
        retinoCT = 1;
        flashCT = 1;
    end
end

%% calculate and plot the median and the std for every subject
for sj=1:nSubjects
    if ~isempty(responseArray{1,sj})
        restMedian{sj} = nanmedian([restSize{sj,:}]);
        restStd{sj} = nanstd([restSize{sj,:}]);
        xtickrest{sj} = responseArray{1,sj}{2};
    end
    if ~isempty(responseArray{2,sj})
        movieMedian{sj} = nanmedian([movieSize{sj,:}]);
        movieStd{sj} = nanstd([movieSize{sj,:}]);
        retinoMedian{sj} = nanmedian([retinoSize{sj,:}]);
        retinoStd{sj} = nanstd([retinoSize{sj,:}]);
        flashMedian{sj} = nanmedian([flashSize{sj,:}]);
        flashStd{sj} = nanstd([flashSize{sj,:}]);
        xtickTwo{sj} = responseArray{1,sj}{2};
    end
end

h = fullFigure;
YMIN = 0;
YMAX = 10;
titleSize = 16;

subplot(2,2,1)
bar(cell2mat(restMedian),'FaceColor',[0.4 0.6 0.8])
hold on
errorbar(cell2mat(restMedian),cell2mat(restStd),'k.')
title (['RESTING STATE (median ' setstr(177) ' SD)'],'FontSize', titleSize)
ylabel('Pupil diameter [mm]')
ax = gca;
set(gca,'TickLabelInterpreter','none')
ax.XTickLabel = ([xtickrest]);
ax.XTickLabelRotation = 45;
ylim([YMIN YMAX])

subplot(2,2,2)
bar(cell2mat(retinoMedian),'FaceColor',[0.4 0.6 0.8])
hold on
errorbar(cell2mat(retinoMedian),cell2mat(retinoStd),'k.')
title (['RETINO (median ' setstr(177) ' SD)'],'FontSize',titleSize)
ylabel('Pupil diameter [mm]')
ylabel('Pupil diameter [mm]')
ax = gca;
set(gca,'TickLabelInterpreter','none')
ax.XTickLabel = ([xtickTwo]);
ax.XTickLabelRotation = 45;
ylim([YMIN YMAX])

subplot(2,2,3)
bar(cell2mat(movieMedian),'FaceColor',[0.4 0.6 0.8])
hold on
errorbar(cell2mat(movieMedian),cell2mat(movieStd),'k.')
title (['MOVIE (median ' setstr(177) ' SD)'],'FontSize',titleSize)
ylabel('Pupil diameter [mm]')
ylabel('Pupil diameter [mm]')
ax = gca;
set(gca,'TickLabelInterpreter','none')
ax.XTickLabel = ([xtickTwo]);
ax.XTickLabelRotation = 45;
ylim([YMIN YMAX])

subplot(2,2,4)
bar(cell2mat(flashMedian),'FaceColor',[0.4 0.6 0.8])
hold on
errorbar(cell2mat(flashMedian),cell2mat(flashStd),'k.')
title (['FLASH (median ' setstr(177) ' SD)'],'FontSize',titleSize)
ylabel('Pupil diameter [mm]')
ylabel('Pupil diameter [mm]')
ax = gca;
set(gca,'TickLabelInterpreter','none')
ax.XTickLabel = ([xtickTwo]);
ax.XTickLabelRotation = 45;
ylim([YMIN YMAX])

%adjustments
axesHandles = findobj(h, 'type', 'axes');
set(axesHandles, 'TickDir', 'out');
set(h, 'PaperPosition', [0 0 9 9]);
set(h, 'PaperSize', [9 9]);

saveas(h, '/Volumes/Bay_2_data/giulia/Dropbox-Aguirre-Brainard-Lab/TOME_analysis/medianPupilSize', 'pdf') %Save figure
close all

%% plot separately each REST run

% pupil size
for sj=1:nSubjects
    h = fullFigure;
    for rr = 1:4
        subplot(2,2,rr)
        trackedFrames = length(find(~isnan([restSize{sj,rr}])));
        plot([restSize{sj,rr}])
        str = [num2str(trackedFrames/totalFrames *100) '% of samples tracked'];
        text(1000,2,str)
        ylim ([0 10])
        xlim ([0 20161])
        ax = gca;
        ax.XTick = [0:framesPerTR*10:totalFrames];
        ax.XTick = [0:framesPerTR*20:totalFrames];
        ax.XTickLabel = [0:20:420];
        title (['REST run ' num2str(rr) ' - ' responseArray{1,sj}{2}], 'Interpreter' , 'none')
        xlabel ('TR')
        ylabel('Pupil diameter [mm]')
    end
    
    %adjustments
    axesHandles = findobj(h, 'type', 'axes');
    set(axesHandles, 'TickDir', 'out');
    set(h, 'PaperPosition', [0 0 16 9]);
    set(h, 'PaperSize', [16 9]);
    
    saveas(h, fullfile('/Users/giulia/Desktop/TEST/', [responseArray{1,sj}{2} '_restStateTimeserie']), 'pdf') %Save figure
    close all
end

% gaze
for sj=1:nSubjects
    h = fullFigure;
    for rr = 1:4
        % eccentricity
        subplot(2,4,rr)
        trackedFrames = length(find(~isnan([restSize{sj,rr}])));
        plot([restEcc{sj,rr}])
        str = [num2str(trackedFrames/totalFrames *100) '% of samples tracked'];
        text(1000,2,str)
        ylim ([-2 20])
        xlim ([0 20161])
        ax = gca;
        ax.XTick = [0:framesPerTR*10:totalFrames];
        ax.XTick = [0:framesPerTR*20:totalFrames];
        ax.XTickLabel = [0:20:420];
        title (['REST run ' num2str(rr) ' - ' responseArray{1,sj}{2}], 'Interpreter' , 'none')
        xlabel ('TR')
        ylabel('Eccentricity')
        % polar angle
        subplot(2,4,rr+4)
        trackedFrames = length(find(~isnan([restSize{sj,rr}])));
        plot([restPol{sj,rr}])
        str = [num2str(trackedFrames/totalFrames *100) '% of samples tracked'];
        text(1000,2,str)
        ylim ([0 360])
        xlim ([0 20161])
        ax = gca;
        ax.XTick = [0:framesPerTR*10:totalFrames];
        ax.XTick = [0:framesPerTR*20:totalFrames];
        ax.XTickLabel = [0:20:420];
        title (['REST run ' num2str(rr) ' - ' responseArray{1,sj}{2}], 'Interpreter' , 'none')
        xlabel ('TR')
        ylabel('Polar Angle')
    end
    
    %adjustments
    axesHandles = findobj(h, 'type', 'axes');
    set(axesHandles, 'TickDir', 'out');
    set(h, 'PaperPosition', [0 0 16 9]);
    set(h, 'PaperSize', [16 9]);
    
    saveas(h, fullfile('/Users/giulia/Desktop/TEST/', [responseArray{1,sj}{2} '_restGAZETimeserie']), 'pdf') %Save figure
    close all
end

%% MOVIE
for sj=1:nSubjects
    h = fullFigure;
    for rr = 1:4
        subplot(2,4,rr)
        trackedFrames = length(find(~isnan([movieSize{sj,rr}])));
        plot([movieSize{sj,rr}])
        str = [num2str(trackedFrames/totalFrames *100) '% of samples tracked'];
        text(1000,2,str)
        ylim ([0 10])
        xlim ([0 20161])
        ax = gca;
        ax.XTick = [0:framesPerTR*10:totalFrames];
        ax.XTick = [0:framesPerTR*20:totalFrames];
        ax.XTickLabel = [0:20:420];
        title (['MOVIE run ' num2str(rr) ' - ' responseArray{1,sj}{2}], 'Interpreter' , 'none')
        xlabel ('TR')
        ylabel('Pupil diameter [mm]')
    end
    
    
    %adjustments
    axesHandles = findobj(h, 'type', 'axes');
    set(axesHandles, 'TickDir', 'out');
    set(h, 'PaperPosition', [0 0 16 9]);
    set(h, 'PaperSize', [16 9]);
    
    saveas(h, fullfile('/Users/giulia/Desktop/TEST/', [responseArray{1,sj}{2} '_movieTimeserie']), 'pdf') %Save figure
    close all
end


% gaze
for sj=1:nSubjects
    h = fullFigure;
    for rr = 1:4
        % eccentricity
        subplot(2,4,rr)
        trackedFrames = length(find(~isnan([restSize{sj,rr}])));
        plot([movieEcc{sj,rr}])
        str = [num2str(trackedFrames/totalFrames *100) '% of samples tracked'];
        text(1000,2,str)
        ylim ([-5 30])
        xlim ([0 20161])
        ax = gca;
        ax.XTick = [0:framesPerTR*10:totalFrames];
        ax.XTick = [0:framesPerTR*20:totalFrames];
        ax.XTickLabel = [0:20:420];
        title (['MOVIE run ' num2str(rr) ' - ' responseArray{1,sj}{2}], 'Interpreter' , 'none')
        xlabel ('TR')
        ylabel('Eccentricity')
        % polar angle
        subplot(2,4,rr+4)
        trackedFrames = length(find(~isnan([restSize{sj,rr}])));
        plot([moviePol{sj,rr}])
        str = [num2str(trackedFrames/totalFrames *100) '% of samples tracked'];
        text(1000,2,str)
        ylim ([0 360])
        xlim ([0 20161])
        ax = gca;
        ax.XTick = [0:framesPerTR*10:totalFrames];
        ax.XTick = [0:framesPerTR*20:totalFrames];
        ax.XTickLabel = [0:20:420];
        title (['MOVIE run ' num2str(rr) ' - ' responseArray{1,sj}{2}], 'Interpreter' , 'none')
        xlabel ('TR')
        ylabel('Polar Angle')
    end
    
    %adjustments
    axesHandles = findobj(h, 'type', 'axes');
    set(axesHandles, 'TickDir', 'out');
    set(h, 'PaperPosition', [0 0 16 9]);
    set(h, 'PaperSize', [16 9]);
    
    saveas(h, fullfile('/Users/giulia/Desktop/TEST/', [responseArray{1,sj}{2} '_movieGAZETimeserie']), 'pdf') %Save figure
    close all
end

%% retino
for sj=1:nSubjects
    h = fullFigure;
    for rr = 1:4
        subplot(2,2,rr)
        trackedFrames = length(find(~isnan([retinoSize{sj,rr}])));
        plot([retinoSize{sj,rr}])
        str = [num2str(trackedFrames/totalFrames *100) '% of samples tracked'];
        text(1000,2,str)
        ylim ([0 10])
        xlim ([0 20161])
        ax = gca;
        ax.XTick = [0:framesPerTR*10:totalFrames];
        ax.XTick = [0:framesPerTR*20:totalFrames];
        ax.XTickLabel = [0:20:420];
        title (['RETINO run ' num2str(rr) ' - ' responseArray{1,sj}{2}], 'Interpreter' , 'none')
        xlabel ('TR')
        ylabel('Pupil diameter [mm]')
    end
    
    %adjustments
    axesHandles = findobj(h, 'type', 'axes');
    set(axesHandles, 'TickDir', 'out');
    set(h, 'PaperPosition', [0 0 16 9]);
    set(h, 'PaperSize', [16 9]);
    
    saveas(h, fullfile('/Users/giulia/Desktop/TEST/', [responseArray{1,sj}{2} '_retinoTimeserie']), 'pdf') %Save figure
    close all
end


% gaze
for sj=1:nSubjects
    h = fullFigure;
    for rr = 1:4
        % eccentricity
        subplot(2,4,rr)
        trackedFrames = length(find(~isnan([restSize{sj,rr}])));
        plot([retinoEcc{sj,rr}])
        str = [num2str(trackedFrames/totalFrames *100) '% of samples tracked'];
        text(1000,2,str)
        ylim ([-20 20])
        xlim ([0 20161])
        ax = gca;
        ax.XTick = [0:framesPerTR*10:totalFrames];
        ax.XTick = [0:framesPerTR*20:totalFrames];
        ax.XTickLabel = [0:20:420];
        title (['RETINO run ' num2str(rr) ' - ' responseArray{1,sj}{2}], 'Interpreter' , 'none')
        xlabel ('TR')
        ylabel('Eccentricity')
        % polar angle
        subplot(2,4,rr+4)
        trackedFrames = length(find(~isnan([restSize{sj,rr}])));
        plot([retinoPol{sj,rr}])
        str = [num2str(trackedFrames/totalFrames *100) '% of samples tracked'];
        text(1000,2,str)
%         ylim ([0 10])
        xlim ([0 20161])
        ax = gca;
        ax.XTick = [0:framesPerTR*10:totalFrames];
        ax.XTick = [0:framesPerTR*20:totalFrames];
        ax.XTickLabel = [0:20:420];
        title (['RETINO run ' num2str(rr) ' - ' responseArray{1,sj}{2}], 'Interpreter' , 'none')
        xlabel ('TR')
        ylabel('Polar Angle')
    end
    
    %adjustments
    axesHandles = findobj(h, 'type', 'axes');
    set(axesHandles, 'TickDir', 'out');
    set(h, 'PaperPosition', [0 0 16 9]);
    set(h, 'PaperSize', [16 9]);
    
    saveas(h, fullfile('/Users/giulia/Desktop/TEST/', [responseArray{1,sj}{2} '_retinoGAZETimeserie']), 'pdf') %Save figure
    close all
end



%% flash
for sj=1:nSubjects
    h = fullFigure;
    for rr = 1:2
        subplot(2,1,rr)
        trackedFrames = length(find(~isnan([flashSize{sj,rr}])));
        plot([flashSize{sj,rr}])
        str = [num2str(trackedFrames/totalFrames *100) '% of samples tracked'];
        text(1000,2,str)
        ylim ([0 10])
        xlim ([0 20161])
        ax = gca;
        ax.XTick = [0:framesPerTR*10:totalFrames];
        ax.XTick = [0:framesPerTR*20:totalFrames];
        ax.XTickLabel = [0:20:420];
        title (['FLASH run ' num2str(rr) ' - ' responseArray{1,sj}{2}], 'Interpreter' , 'none')
        xlabel ('TR')
        ylabel('Pupil diameter [mm]')
    end
    
    %adjustments
    axesHandles = findobj(h, 'type', 'axes');
    set(axesHandles, 'TickDir', 'out');
    set(h, 'PaperPosition', [0 0 16 9]);
    set(h, 'PaperSize', [16 9]);
    
    saveas(h, fullfile('/Users/giulia/Desktop/TEST/', [responseArray{1,sj}{2} '_flashTimeserie']), 'pdf') %Save figure
    close all
end