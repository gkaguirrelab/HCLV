#!/bin/bash
#set -ex  #uncomment just for debugging

echo -e "Copying Files from the scanner computer from dropbox and on the cluster. \nHow are you running this script? \n1. On a local machine, with write access to Dropbox-Aguirre-Brainard-Lab/TOME_data/ and with the cluster mounted (local path /data/jag/TOME) \n2. On the cluster, and I can remote in a machine with write access to Dropbox-Aguirre-Brainard-Lab/TOME_data\n3. On the cluster, and I don't have access to Dropbox.\n4. None of the above."
read start

case $start in
"4") echo "This script will not work in your current setting. Please copy all files manually."
	 exit 1
	 ;;

###### LOCALLY, CLUSTER AND DROPBOX ACCESS	
"1")
	#enter subject and session details
	echo "Enter subject name (TOME_3xxx):"
	read subjName
	echo "Enter session date (mmddyy) :"
	read sessionDate
	echo "Enter session number (1, 2 or 3):"
	read sessionNum
	# Copying files on the cluster
	# ssh into cluster
	echo "Connecting to the cluster. Enter your cluster username:"
	read clusterUser
	# make folders on the cluster
	echo "Creating folders on the cluster..."
	mkdir /data/jag/TOME/$subjName
	if [ ! -d /data/jag/TOME/$subjName/$sessionDate ]; then
		ssh $clusterUser@chead "mkdir /data/jag/TOME/$subjName/$sessionDate"
	else
		echo "This session date already exists. How do you want to rename the existing session folder (e.g. 022912a)?"
		read renameExisting
		mv /data/jag/TOME/$subjName/$sessionDate /data/jag/TOME/$subjName/$renameExisting
		echo "How do you want to name the new session folder (e.g. 022912b)?"
		read sessionDate
		mkdir /data/jag/TOME/$subjName/$sessionDate
	fi
	# copy Pulse ox files on the cluster
	echo "Paste the common part (first part) of the PulseOx file names and press [ENTER]. (Hint: in another terminal window, navigate into /mnt/disk_c/MedCom/log/Physio on rico, execute ls -ltr and locate the PulseOx files)."
	read pulseOxFiles
	echo "Copying PulseOx files on the cluster..."
	mkdir /data/jag/TOME/$subjName/$sessionDate/PulseOx
	scp aguirrelab@rico:/mnt/disk_c/MedCom/log/Physio/$pulseOxFiles*PULS.log $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/PulseOx/
	echo "PulseOx files copied on the cluster."
	# copy Protocols Files on the cluster
	echo "Paste the common part (first part) of the Protocol file names and press [ENTER]. (Hint: in another terminal window, navigate into /mnt/disk_c/MedCom/User/Aguirre on rico, execute ls -ltr and locate the Protocol files)."
	read protocolFiles
	echo "Copying protocol files on the cluster..."
	mkdir /data/jag/TOME/$subjName/$sessionDate/Protocols
	scp -r aguirrelab@rico:/mnt/disk_c/MedCom/User/Aguirre/$protocolFiles* $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/Protocols/
	scp aguirrelab@rico:/mnt/disk_c/MedCom/MriSiteData/GradientCoil/coeff.grad $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/Protocols/
	echo "Protocol files copied on the cluster."
	#copy DICOM files on the cluster
	echo "Paste the full path to the dicom folder on the scanner computer and press [ENTER]. (Hint: navigate into the dicom folder on rico, execute pwd and paste the output here)."
	read dicomSource
	echo "Copying DICOM files on the cluster..."
	mkdir /data/jag/TOME/$subjName/$sessionDate/DICOMS
	scp aguirrelab@rico:$dicomSource/* $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/DICOMS/
	echo "DICOMs copied on the cluster."
	echo "All files copied from the scanner to the cluster."
	echo "Do you want to write the README.md file now?[y/n]"
	read readme
	if [ "$readme" == "y" ]; then
		echo "The README file will be created and opened. Write and save its content, and close gedit GUI to continue with this script."
		read -rsp $'Press enter to continue...\n'
		touch /data/jag/TOME/$subjName/$sessionDate/README.md
		open -e /data/jag/TOME/$subjName/$sessionDate/README.md
	else
		echo "Remember to write the README file as soon as possible!"
	fi
	# copy stimulus files on the cluster (from dropbox)
	echo "Copying stimulus files on the cluster from dropbox..."
	mkdir /data/jag/TOME/$subjName/$sessionDate/Stimuli
	if [ "$sessionNum" == "1" ]; then
		scp /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/Stimuli/* /data/jag/TOME/$subjName/$sessionDate/Stimuli/
	elif [ "$sessionNum" == "2" ]; then
		scp /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/Stimuli/* /data/jag/TOME/$subjName/$sessionDate/Stimuli/
	elif [ "$sessionNum" == "3" ]; then
		scp /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/Stimuli/* /data/jag/TOME/$subjName/$sessionDate/Stimuli/
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
	if [ "$readme" == "y" ]; then
		if [ "$sessionNum" == "1" ]; then
			scp $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/README.md /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/
		elif [ "$sessionNum" == "2" ]; then
			scp $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/README.md /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/
		elif [ "$sessionNum" == "3" ]; then
			scp $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/README.md /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/
		fi
	fi
;;
###### ON CLUSTER, DROPBOX ACCESS
"2")	
#enter subject and session details
	echo "Enter subject name (TOME_3xxx):"
	read subjName
	echo "Enter session date (mmddyy) :"
	read sessionDate
	echo "Enter session number (1, 2 or 3):"
	read sessionNum
# make folders on the cluster
	echo "Creating folders on the cluster..."
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
	
	# copy Pulse ox files on the cluster
	echo "Paste the common part (first part) of the PulseOx file names and press [ENTER]. (Hint: in another terminal window, navigate into /mnt/disk_c/MedCom/log/Physio on rico, execute ls -ltr and locate the PulseOx files)."
	read pulseOxFiles
	echo "Copying PulseOx files on the cluster..."
	mkdir /data/jag/TOME/$subjName/$sessionDate/PulseOx
	scp aguirrelab@rico:/mnt/disk_c/MedCom/log/Physio/$pulseOxFiles*PULS.log /data/jag/TOME/$subjName/$sessionDate/PulseOx/
	echo "PulseOx files copied on the cluster."
	# copy Protocols Files on the cluster
	echo "Paste the common part (first part) of the Protocol file names and press [ENTER]. (Hint: in another terminal window, navigate into /mnt/disk_c/MedCom/User/Aguirre on rico, execute ls -ltr and locate the Protocol files)."
	read protocolFiles
	echo "Copying protocol files on the cluster..."
	mkdir /data/jag/TOME/$subjName/$sessionDate/Protocols
	scp -r aguirrelab@rico:/mnt/disk_c/MedCom/User/Aguirre/$protocolFiles* /data/jag/TOME/$subjName/$sessionDate/Protocols/
	scp aguirrelab@rico:/mnt/disk_c/MedCom/MriSiteData/GradientCoil/coeff.grad /data/jag/TOME/$subjName/$sessionDate/Protocols/
	echo "Protocol files copied on the cluster."
	#copy DICOM files on the cluster
	echo "Paste the full path to the dicom folder on the scanner computer and press [ENTER]. (Hint: navigate into the dicom folder on rico, execute pwd and paste the output here)."
	read dicomSource
	echo "Copying DICOM files on the cluster..."
	mkdir /data/jag/TOME/$subjName/$sessionDate/DICOMS
	scp aguirrelab@rico:$dicomSource/* /data/jag/TOME/$subjName/$sessionDate/DICOMS/
	echo "DICOMs copied on the cluster."
	echo "All files copied from the scanner to the cluster."
	echo "Do you want to write the README.md file now?[y/n]"
	read readme
	if [ "$readme" == "y" ]; then
		echo "The README file will be created and opened. Write and save its content, and close gedit GUI to continue with this script."
		read -rsp $'Press enter to continue...\n'
		touch /data/jag/TOME/$subjName/$sessionDate/README.md
		gedit /data/jag/TOME/$subjName/$sessionDate/README.md
	else
		echo "Remember to write the README file as soon as possible!"
	fi
	
	# copy stimulus files on the cluster (from dropbox)
	echo "Enter your remote adress to copy files on dropbox (e.g. you@170.xxx.xx.xx)"
	read remoteIP
	ssh $remoteIP -t -t <<- 'ACCESS'
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
		if [ "$readme" == "y" ]; then
			if [ "$sessionNum" == "1" ]; then
				scp $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/README.md /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/
			elif [ "$sessionNum" == "2" ]; then
				scp $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/README.md /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/
			elif [ "$sessionNum" == "3" ]; then
				scp $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/README.md /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/
			fi
		fi
	ACCESS
;;	
###### CLUSTER, NO DROPBOX	
"3")		
	#enter subject and session details
	echo "Enter subject name (TOME_3xxx):"
	read subjName
	echo "Enter session date (mmddyy) :"
	read sessionDate
	echo "Enter session number (1, 2 or 3):"
	read sessionNum
	# make folders on the cluster
	echo "Creating folders on the cluster..."
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
	
	# copy Pulse ox files on the cluster
	echo "Paste the common part (first part) of the PulseOx file names and press [ENTER]. (Hint: in another terminal window, navigate into /mnt/disk_c/MedCom/log/Physio on rico, execute ls -ltr and locate the PulseOx files)."
	read pulseOxFiles
	echo "Copying PulseOx files on the cluster..."
	mkdir /data/jag/TOME/$subjName/$sessionDate/PulseOx
	scp aguirrelab@rico:/mnt/disk_c/MedCom/log/Physio/$pulseOxFiles*PULS.log /data/jag/TOME/$subjName/$sessionDate/PulseOx/
	echo "PulseOx files copied on the cluster."
	# copy Protocols Files on the cluster
	echo "Paste the common part (first part) of the Protocol file names and press [ENTER]. (Hint: in another terminal window, navigate into /mnt/disk_c/MedCom/User/Aguirre on rico, execute ls -ltr and locate the Protocol files)."
	read protocolFiles
	echo "Copying protocol files on the cluster..."
	mkdir /data/jag/TOME/$subjName/$sessionDate/Protocols
	scp -r aguirrelab@rico:/mnt/disk_c/MedCom/User/Aguirre/$protocolFiles* /data/jag/TOME/$subjName/$sessionDate/Protocols/
	scp aguirrelab@rico:/mnt/disk_c/MedCom/MriSiteData/GradientCoil/coeff.grad /data/jag/TOME/$subjName/$sessionDate/Protocols/
	echo "Protocol files copied on the cluster."
	#copy DICOM files on the cluster
	echo "Paste the full path to the dicom folder on the scanner computer and press [ENTER]. (Hint: navigate into the dicom folder on rico, execute pwd and paste the output here)."
	read dicomSource
	echo "Copying DICOM files on the cluster..."
	mkdir /data/jag/TOME/$subjName/$sessionDate/DICOMS
	scp aguirrelab@rico:$dicomSource/* /data/jag/TOME/$subjName/$sessionDate/DICOMS/
	echo "DICOMs copied on the cluster."
	echo "All files copied from the scanner to the cluster."
	echo "Do you want to write the README.md file now?[y/n]"
	read readme
	if [ "$readme" == "y" ]; then
		echo "The README file will be created and opened. Write and save its content, and close gedit GUI to continue with this script."
		read -rsp $'Press enter to continue...\n'
		touch /data/jag/TOME/$subjName/$sessionDate/README.md
		gedit /data/jag/TOME/$subjName/$sessionDate/README.md
	else
		echo "Remember to write the README file as soon as possible!"
	fi
	echo "No backup has been done on dropbox. Make sure it is done promptly!"
;;
*) exit 1
;;
esac