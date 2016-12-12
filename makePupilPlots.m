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
                            rest{sj,restCT} = responseArray{st,sj,ss,rr,1}{1,5}.pupilSize(zeroFrame : zeroFrame + totalFrames);
                            restCT = restCT+1;
                        end
                    elseif regexp(responseArray{st,sj,ss,rr,1}{4},regexptranslate('wildcard','*MOVIE*'))
                        % find zero in timebase
                        zeroFrame = find (~responseArray{st,sj,ss,rr,1}{1,5}.timeBase);
                        if isempty(zeroFrame)
                            warning(['TimeBase problem for ' responseArray{st,sj,ss,rr,1}{1,5}.metadata.subjectName responseArray{st,sj,ss,rr,1}{1,5}.metadata.runName ])
                        else
                            % trim the response
                            movie{sj,movieCT} = responseArray{st,sj,ss,rr,1}{1,5}.pupilSize(zeroFrame : zeroFrame + totalFrames);
                            movieCT = movieCT+1;
                        end
                    elseif regexp(responseArray{st,sj,ss,rr,1}{4},regexptranslate('wildcard','*RETINO*'))
                        % find zero in timebase
                        zeroFrame = find (~responseArray{st,sj,ss,rr,1}{1,5}.timeBase);
                        if isempty(zeroFrame)
                            warning(['TimeBase problem for ' responseArray{st,sj,ss,rr,1}{1,5}.metadata.subjectName responseArray{st,sj,ss,rr,1}{1,5}.metadata.runName ])
                        else
                            % trim the response
                            retino{sj,retinoCT} = responseArray{st,sj,ss,rr,1}{1,5}.pupilSize(zeroFrame : zeroFrame + totalFrames);
                            retinoCT = retinoCT+1;
                        end
                    elseif regexp(responseArray{st,sj,ss,rr,1}{4},regexptranslate('wildcard','*FLASH*'))
                        % find zero in timebase
                        zeroFrame = find (~responseArray{st,sj,ss,rr,1}{1,5}.timeBase);
                        if isempty(zeroFrame)
                            warning(['TimeBase problem for ' responseArray{st,sj,ss,rr,1}{1,5}.metadata.subjectName responseArray{st,sj,ss,rr,1}{1,5}.metadata.runName ])
                        else
                            % trim the response
                            flash{sj,flashCT} = responseArray{st,sj,ss,rr,1}{1,5}.pupilSize(zeroFrame : zeroFrame + totalFrames);
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
        restMedian{sj} = nanmedian([rest{sj,:}]);
        restStd{sj} = nanstd([rest{sj,:}]);
        xtickrest{sj} = responseArray{1,sj}{2};
    end
    if ~isempty(responseArray{2,sj})
        movieMedian{sj} = nanmedian([movie{sj,:}]);
        movieStd{sj} = nanstd([movie{sj,:}]);
        retinoMedian{sj} = nanmedian([retino{sj,:}]);
        retinoStd{sj} = nanstd([retino{sj,:}]);
        flashMedian{sj} = nanmedian([flash{sj,:}]);
        flashStd{sj} = nanstd([flash{sj,:}]);
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

saveas(h, '/Users/giulia/Dropbox-Aguirre-Brainard-Lab/TOME_analysis/medianPupilSize', 'pdf') %Save figure
close all

%% plot separately each REST run
for sj=1:nSubjects
    h = fullFigure;
    for rr = 1:4
        subplot(2,2,rr)
        trackedFrames = length(find(~isnan([rest{sj,rr}])));
        plot([rest{sj,rr}])
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
%% MOVIE
for sj=1:nSubjects
    h = fullFigure;
    for rr = 1:4
        subplot(2,2,rr)
        trackedFrames = length(find(~isnan([movie{sj,rr}])));
        plot([movie{sj,rr}])
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

%% retino
for sj=1:nSubjects
    h = fullFigure;
    for rr = 1:4
        subplot(2,2,rr)
        trackedFrames = length(find(~isnan([retino{sj,rr}])));
        plot([retino{sj,rr}])
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

%% flash
for sj=1:nSubjects
    h = fullFigure;
    for rr = 1:2
        subplot(2,1,rr)
        trackedFrames = length(find(~isnan([flash{sj,rr}])));
        plot([flash{sj,rr}])
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