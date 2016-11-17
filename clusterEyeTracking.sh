#!/bin/bash
#set -ex  #uncomment just for debugging
echo "This script will create the eye tracking scripts for every run in a chosen session."
echo "Do you want to submit all eye tracking jobs at the end of this script?[y/n]"
read submitNow

#enter subject and session details
echo "Enter subject name (TOME_3xxx):"
read subjName
echo "Enter session date (mmddyy) :"
read sessionDate
echo "Enter session number (1, 2 or 3):"
read sessionNum

# verify if a session folder with this date exists
if [ ! -d /data/jag/TOME/$subjName/$sessionDate ]; then
	echo "This session date does not exist for $subjName. Here's a list of available sessions:"
	ls /data/jag/TOME/$subjName/
	echo "Which session do you want to use?"
	read clusterSessionDate
else
	clusterSessionDate=sessionDate
fi

# create eye tracking folder on the cluster
mkdir /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking
mkdir /data/jag/TOME/$subjName/$clusterSessionDate/eyeTracking_scripts
echo "EyeTracking folders created in $subjName/$clusterSessionDate ."

# enter credentials to remote in machine with write access to Dropbox
echo "Enter your Username on the remote machine with read permission to TOME_data (e.g. <you>  @170.xxx.xx.xx)"
read remoteUser
echo "Enter your the remote machine IP address or alias (e.g. you@ <170.xxx.xx.xx>)"
read remoteIP

# copy eye tracking files from Dropbox to the cluster
echo "Copying Stimuli folder from Dropbox to the cluster..."
if [ "$sessionNum" == "1" ]; then
	scp -r $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/EyeTracking/*_report.mat /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/
	scp -r $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/EyeTracking/*_raw.mov /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/
elif [ "$sessionNum" == "2" ]; then
	scp -r $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/EyeTracking/*_report.mat /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/
	scp -r $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/EyeTracking/*_raw.mov /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/
elif [ "$sessionNum" == "3" ]; then
	scp -r $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/EyeTracking/*_report.mat /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/
	scp -r $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/EyeTracking/*_raw.mov /data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/
fi
echo "Eye tracking files copied on the cluster."


### No user interaction is required from this point on. ###


# make eye tracking jobs for every run (optional: submit them)
echo "Making eye tracking scripts for all available runs in $subjName/$clusterSessionDate/EyeTracking/ ..."


runs=(/data/jag/TOME/$subjName/$clusterSessionDate/EyeTracking/*_raw.mov)
for runVid in "${runs[@]}"; do
	echo "   "
	echo "   "

	# get runName
	runName="${runVid: : -8}"
	echo "Run Name = $runName"
	
	# make "job script" for this run
	jobFile="/data/jag/TOME/$subjName/$clusterSessionDate/eyetracking_scripts/"$subjName"_"$runName".sh"
	touch $jobFile
	cat <<EOF >$jobFile
	#!/bin/bash
	matlab -nodisplay -nosplash -r "mainDir='/data/jag';params.subjectName=subjName;params.sessionDate='$clusterSessionDate';params.runName='$runName';pupilPipeline (params, mainDir);"
EOF
		
	# make "submit job script" for this run
	submitJobFile="/data/jag/TOME/$subjName/$clusterSessionDate/eyetracking_scripts/submit_"$subjName"_"$runName".sh"
	touch $submitJobFile
	echo "qsub -l h_vmem=50.2G,s_vmem=50G -e /data/jag/TOME/LOGS -o /data/jag/TOME/LOGS /data/jag/TOME/$subjName/$clusterSessionDate/eyetracking_scripts/"$subjName"_"$runName".sh" > $submitJobFile

	echo "Job created."
done

# submit jobs
if [ "$submitNow" == "y" ]; then
	echo "Submitting all jobs..."
	for runVid in "${runs[@]}"; do
		echo "   "

		# get runName
		runName="${runVid: : -8}"	
		sh /data/jag/TOME/$subjName/$clusterSessionDate/eyetracking_scripts/submit_$subjName_$runName.sh
	done
else
	echo "Jobs were not submitted."
fi