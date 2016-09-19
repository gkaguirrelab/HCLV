#!/bin/bash
#set -ex  #uncomment just for debugging

echo "Copying Files from the scanner computer from dropbox and on the cluster. Are you using a computer with write access to Dropbox-Aguirre-Brainard-Lab/TOME_data/ and with the cluster mounted with OXfuse (local path: /data/jag/....)? [y/n]"

read start

if [ "$start" == "n" ]; then
	echo "This script will not work with your current configuration. Please copy all files manually."
	exit 1
elif [ "$start" == "y" ]; then
	#enter subject and session details
	echo "Enter subject name (TOME_3xxx):"
	read subjName
	echo "Enter session date (mmddyy) :"
	read sessionDate
	echo "Enter session number (1, 2 or 3):"
	read sessionNum
	
	###### Copying files on the cluster
	# make folders on the cluster
	echo "Creating folders on the cluster..."
	echo "Enter your cluster username:"
	read clusterUser
	mkdir -p /data/jag/TOME/$subjName
	if [ ! -d /data/jag/TOME/$subjName/$sessionDate ]; then
		mkdir /data/jag/TOME/$subjName/$sessionDate
	else
		echo "This session date already exists. How do you want to rename the existing session folder (e.g. 022912a)?"
		read renameExisting
		mv /data/jag/TOME/$subjName/$sessionDate /data/jag/TOME/$subjName/$renameExisting
		echo "How do you want to name the new session folder (e.g. 022912b)?"
		read sessionDate
		mkdir /data/jag/TOME/$subjName/$sessionDate
	fi
	#copy DICOM files on the cluster
	echo "Paste the full path to the dicom folder on the scanner computer and press [ENTER]. (Hint: navigate into the dicom folder on rico, execute pwd and paste the output here)."
	read dicomSource
	echo "Copying DICOM files on the cluster..."
	mkdir /data/jag/TOME/$subjName/$sessionDate/DICOMS
	scp aguirrelab@rico:$dicomSource/* $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/DICOMS/
	echo "DICOMs copied on the cluster."
	# copy Pulse ox files on the cluster
	echo "Paste the common part (first part) of the PulseOx file names and press [ENTER]. (Hint: navigate into /mnt/disk_c/MedCom/log/Physio on rico, execute ls -ltr and locate the PulseOx files)."
	read pulseOxFiles
	echo "Copying PulseOx files on the cluster..."
	mkdir /data/jag/TOME/$subjName/$sessionDate/PulseOx
	scp aguirrelab@rico:/mnt/disk_c/MedCom/log/Physio/$pulseOxFiles*PULS.log $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/PulseOx/
	echo "PulseOx files copied on the cluster."
	# copy Protocols Files on the cluster
	echo "Paste the common part (first part) of the Protocol file names and press [ENTER]. (Hint: navigate into /mnt/disk_c/MedCom/User/Bock on rico, execute ls -ltr and locate the Protocol files)."
	read protocolFiles
	echo "Copying protocol files on the cluster..."
	mkdir /data/jag/TOME/$subjName/$sessionDate/Protocols
	scp -r aguirrelab@rico:/mnt/disk_c/MedCom/User/Bock/$protocolFiles* $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/Protocols/
	scp aguirrelab@rico:/mnt/disk_c/MedCom/MriSiteData/GradientCoil/coeff.grad $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/Protocols/
	echo "Protocol files copied on the cluster."
	# copy stimulus files on the cluster (from dropbox)
	echo "Copying stimulus files on the cluster from dropbox..."
	mkdir /data/jag/TOME/$subjName/$sessionDate/Stimuli
	if [ "$sessionNum" == "1" ]; then
		scp /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/Stimuli/* $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/Stimuli/
	elif [ "$sessionNum" == "2" ]; then
		scp /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/Stimuli/* $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/Stimuli/
	elif [ "$sessionNum" == "3" ]; then
		scp /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/Stimuli/* $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/Stimuli/
	fi
	echo "Protocol files copied on the cluster."
	
	###### Copying files on Dropbox
	#copy scanner files on Dropbox
	echo "Copying scanner files on Dropbox..."
	if [ "$sessionNum" == "1" ]; then
		mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles
		mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/PulseOx
		scp $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/PulseOx/* /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/PulseOx/
		mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/Protocols
		scp -r $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/Protocols/* /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/Protocols/
		mv /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/Protocols/coeff.grad /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/
	elif [ "$sessionNum" == "2" ]; then
		mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles
		mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/PulseOx
		scp $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/PulseOx/* /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/PulseOx/
		mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/Protocols
		scp -r $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/Protocols/* /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/Protocols/
		mv /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/Protocols/coeff.grad /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/
	elif [ "$sessionNum" == "3" ]; then
		mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles
		mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/PulseOx
		scp $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/PulseOx/* /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/PulseOx/
		mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/Protocols
		scp -r $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/Protocols/* /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/Protocols/
		mv /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/Protocols/coeff.grad /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/	
	fi
	echo "Scanner files copied on Dropbox."
fi