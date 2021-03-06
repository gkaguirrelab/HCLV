#!/bin/bash
#set -ex  #uncomment just for debugging
echo "This script will create the eye tracking scripts for every run in a chosen session."
echo "The eye tracking scripts include: deinterlacing (optional), pupil tracking, getting the timebase."
echo "   "
echo "Do you want to submit all eye tracking jobs at the end of this script?[y/n]"
read submitNow

echo "Do you need to upload the LiveTrack reports from dropbox?[y/n]"
read uploadReportNow

echo "Do you need to upload the deinterlaced videos from dropbox?[y/n]"
read uploadDeinterlacedNow

if [ "$uploadDeinterlacedNow" == "n" ]; then
	echo "Do you need to upload the eye tracking raw videos from dropbox?[y/n]"
	read uploadRawNow

	echo "Do you need to do deinterlacing before tracking?[y/n]"
	read deinterlaceNow
elif [ "$uploadDeinterlacedNow" == "y" ]; then
	uploadRawNow="n"
	deinterlaceNow="n"
fi

echo "Do you want to remove the deinterlaced videos after tracking (large files!)?[y/n]"
read removeDeinterlaced
if [ "$removeDeinterlaced" == "y" ]; then
	remDeint=1
else
	remDeint=0
fi

 
#enter subject and session details
echo "Enter subject name (TOME_3xxx):"
read subjName
echo "Enter session date (mmddyy) :"
read sessionDate

# enter ellipse threshold for this subject
echo "Enter circle mask thresholding value ( default [0.05 0.999] )"
read circleThreshold

# enter ellipse threshold for this subject
echo "Enter ellipse thresholding value ( default [0.97 0.9] )"
read ellipseThreshold

# enter ellipse threshold for this subject
echo "Enter gamma correction value ( default 1 )"
read gammaCorrection

if [ "$uploadRawNow" == "y" -o "$uploadReportNow" == "y"  -o "$uploadDeinterlacedNow" == "y" ]; then
	echo "Enter session number (1, 2 or 3):"
	read sessionNum
	# enter credentials to remote in machine with read access to Dropbox
	echo "Enter your Username on the remote machine with read permission to TOME_data (e.g. <you>  @170.xxx.xx.xx)"
	read remoteUser
	echo "Enter your the remote machine IP address or alias (e.g. you@ <170.xxx.xx.xx>)"
	read remoteIP
	# special configuration for melchior's dropbox
	if [ "$remoteIP" == "melchior" ]; then
		dbRoot="Volumes/Bay_2_data"
	else
		dbRoot="Users"
	fi
fi

# verify if a session folder with this date exists
if [ ! -d /data/jag/TOME/$subjName/$sessionDate ]; then
	echo "This session date does not exist for $subjName. Here's a list of available sessions:"
	ls /data/jag/TOME/$subjName/
	echo "Which session do you want to use?"
	read clusterSessionDate
else
	clusterSessionDate=$sessionDate
fi

# create eye tracking folder on the cluster
mkdir /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking
mkdir /data/jag/TOME/$subjName/$clusterSessionDate/eyeTracking_scripts
echo "EyeTracking folders created in $subjName/$clusterSessionDate ."

# copy files from dropbox (optional)
if [ "$uploadRawNow" == "y" ]; then
	# copy eye tracking files from Dropbox to the cluster
	echo "Copying eye tracking raw videos from Dropbox to the cluster (will ask password)..."
	if [ "$sessionNum" == "1" ]; then
		scp -r $remoteUser@$remoteIP:/$dbRoot/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/EyeTracking/*_raw.mov /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/
	elif [ "$sessionNum" == "2" ]; then
		scp -r $remoteUser@$remoteIP:/$dbRoot/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/EyeTracking/*_raw.mov /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/
	elif [ "$sessionNum" == "3" ]; then
		scp -r $remoteUser@$remoteIP:/$dbRoot/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/EyeTracking/*_raw.mov /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/
	fi
	echo "Eye tracking files copied on the cluster."
fi

if [ "$uploadReportNow" == "y" ]; then
	# copy eye tracking files from Dropbox to the cluster
	echo "Copying LiveTrack reports from Dropbox to the cluster (will ask password)..."
	if [ "$sessionNum" == "1" ]; then
		scp -r $remoteUser@$remoteIP:/$dbRoot/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/EyeTracking/*_report.mat /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/
	elif [ "$sessionNum" == "2" ]; then
		scp -r $remoteUser@$remoteIP:/$dbRoot/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/EyeTracking/*_report.mat /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/
	elif [ "$sessionNum" == "3" ]; then
		scp -r $remoteUser@$remoteIP:/$dbRoot/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/EyeTracking/*_report.mat /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/
	fi
	echo "Eye tracking files copied on the cluster."
fi

if [ "$uploadDeinterlacedNow" == "y" ]; then
	# copy eye tracking files from Dropbox to the cluster
	echo "Copying eye tracking deinterlaced videos from Dropbox to the cluster (will ask password)..."
	if [ "$sessionNum" == "1" ]; then
		scp -r $remoteUser@$remoteIP:/$dbRoot/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_processing/session1_restAndStructure/$subjName/$sessionDate/EyeTracking/*_60hz.avi /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/
	elif [ "$sessionNum" == "2" ]; then
		scp -r $remoteUser@$remoteIP:/$dbRoot/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_processing/session2_spatialStimuli/$subjName/$sessionDate/EyeTracking/*_60hz.avi /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/
	elif [ "$sessionNum" == "3" ]; then
		scp -r $remoteUser@$remoteIP:/$dbRoot/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_processing/session3_OneLight/$subjName/$sessionDate/EyeTracking/*_60hz.avi /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/
	fi
	echo "Eye tracking files copied on the cluster."
fi


### No user interaction is required from this point on. ###


# make eye tracking jobs for every run
echo "Making eye tracking scripts for all available runs in $subjName/$clusterSessionDate/EyeTracking/ ..."
echo "   "

shopt -s nullglob
runs=(/data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/*_report.mat)
for runName in "${runs[@]%_report.mat}"; do
	runName=${runName##*/}
	echo "   "
	echo "   "

	echo "Run Name = $runName"
	
	
	# make "job script" for this run
	jobFile="/data/jag/TOME/$subjName/$clusterSessionDate/eyeTracking_scripts/"$subjName"_"$runName".sh"
	touch $jobFile
	
	if [ "$deinterlaceNow" == "y" ]; then
		deintYN=1
	else
		deintYN=0
	fi
		cat <<EOF >$jobFile
		#!/bin/bash
		matlab -nodisplay -nosplash -r "mainDir='/data/jag';params.subjectName='$subjName';params.deinterlace=$deintYN;params.sessionDate='$clusterSessionDate';params.runName='$runName';params.outputDir='TOME';params.projectFolder='TOME';params.eyeTrackingDir='EyeTracking';params.removeDeint=$remDeint;params.ellipseThresh=$ellipseThreshold;params.circleThresh=$circleThreshold;params.gammaCorrection=$gammaCorrection;pupilPipeline (params, mainDir);"
EOF
		
	# make "submit job script" for this run
	submitJobFile="/data/jag/TOME/$subjName/$clusterSessionDate/eyeTracking_scripts/submit_"$subjName"_"$runName".sh"
	touch $submitJobFile
	echo "qsub -l h_vmem=8.2G,s_vmem=8G -e /data/jag/TOME/LOGS -o /data/jag/TOME/LOGS /data/jag/TOME/$subjName/$clusterSessionDate/eyeTracking_scripts/"$subjName"_"$runName".sh" > $submitJobFile

	echo "Job created."
done

# submit jobs (optional)
if [ "$submitNow" == "y" ]; then
	echo "Submitting all jobs..."
	for runName in "${runs[@]%_report.mat}"; do
		runName=${runName##*/}
		echo "   "
		echo "Run Name = $runName"
		sh /data/jag/TOME/$subjName/$clusterSessionDate/eyeTracking_scripts/submit_"$subjName"_"$runName".sh
	done
else
	echo "Jobs were not submitted."
fi