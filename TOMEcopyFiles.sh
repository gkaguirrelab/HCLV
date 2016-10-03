#!/bin/bash
#set -ex  #uncomment just for debugging

echo -e "Copying Files from the scanner computer from dropbox and on the cluster. \nHow are you running this script? \n1. On the cluster, and I can remote in a machine with write access to Dropbox-Aguirre-Brainard-Lab/TOME_data\n2. On the cluster, and I don't have access to Dropbox.\n3.On a local machine, I want to copy the scanner files on dropbox.\n4. None of the above."
read start

case $start in
"4") echo "This script will not work in your current setting. Please copy all files manually."
	 exit 1
;;

###### ON CLUSTER, DROPBOX ACCESS
"1")	
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
	
	# enter credentials to remote in machine with write access to Dropbox
	echo "Enter your Username on the remote machine with write permission to TOME_data (e.g. <you>  @170.xxx.xx.xx)"
	read remoteUser
	echo "Enter your the remote machine IP address or alias (e.g. you@ <170.xxx.xx.xx>)"
	read remoteIP
	
	# copy Stimulus files from Dropbox to the cluster
	echo "Copying Stimuli folder from Dropbox to the cluster..."
	if [ "$sessionNum" == "1" ]; then
			scp -r $remoteUser@$remoteIP:/Users/$remoteUser/\ \(Aguirre-Brainard\ Lab\)/TOME_data/session1_restAndStructure/$subjName/$sessionDate/Stimuli/ /data/jag/TOME/$subjName/$sessionDate/
	elif [ "$sessionNum" == "2" ]; then
			scp -r $remoteUser@$remoteIP:/Users/$remoteUser/\ \(Aguirre-Brainard\ Lab\)/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/Stimuli/ /data/jag/TOME/$subjName/$sessionDate/
	elif [ "$sessionNum" == "3" ]; then
			scp -r $remoteUser@$remoteIP:/Users/$remoteUser/\ \(Aguirre-Brainard\ Lab\)/TOME_data/session3_OneLight/$subjName/$sessionDate/Stimuli/ /data/jag/TOME/$subjName/$sessionDate/
	fi
		echo "Stimuli folder copied on the cluster."

	# copy stimulus files on the cluster (from dropbox)	
		echo "Copying scanner files on Dropbox..."
		if [ "$sessionNum" == "1" ]; then
		echo "Creating folders."
			ssh $remoteUser@$remoteIP "mkdir /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles; mkdir /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/PulseOx; mkdir /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/Protocols"
			echo "Copying files."
			scp /data/jag/TOME/$subjName/$sessionDate/PulseOx/* $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/PulseOx/
			scp -r /data/jag/TOME/$subjName/$sessionDate/Protocols/* $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/Protocols/
			ssh $remoteUser@$remoteIP "mv /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/Protocols/coeff.grad /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/"
		elif [ "$sessionNum" == "2" ]; then
			echo "Creating folders."
			ssh $remoteUser@$remoteIP "mkdir /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles; mkdir /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/PulseOx; mkdir /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/Protocols"
			echo "Copying files."
			scp /data/jag/TOME/$subjName/$sessionDate/PulseOx/* $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/PulseOx/
			scp -r /data/jag/TOME/$subjName/$sessionDate/Protocols/* $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/Protocols/
			ssh $remoteUser@$remoteIP "mv /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/Protocols/coeff.grad /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/"
		elif [ "$sessionNum" == "3" ]; then
			echo "Creating folders."
			ssh $remoteUser@$remoteIP "mkdir /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles; mkdir /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/PulseOx; mkdir /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/Protocols"
			echo "Copying files."
			scp /data/jag/TOME/$subjName/$sessionDate/PulseOx/* $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/PulseOx/
			scp -r /data/jag/TOME/$subjName/$sessionDate/Protocols/* $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/Protocols/
			ssh $remoteUser@$remoteIP "mv /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/Protocols/coeff.grad /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/"
		fi
		echo "Scanner files copied on Dropbox."
		if [ "$readme" == "y" ]; then
		echo "Copying README.md file on Dropbox"
			if [ "$sessionNum" == "1" ]; then
				scp /data/jag/TOME/$subjName/$sessionDate/README.md $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/
			elif [ "$sessionNum" == "2" ]; then
				scp /data/jag/TOME/$subjName/$sessionDate/README.md $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/
			elif [ "$sessionNum" == "3" ]; then
				scp /data/jag/TOME/$subjName/$sessionDate/README.md $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/
			fi
		fi
		echo "Copying ScanChecklists on Dropbox"
		if [ "$sessionNum" == "1" ]; then
			ssh $remoteUser@$remoteIP "mkdir /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScanChecklists"
			scp $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_materials/dataCollectionForms/HCLV-dataCollection.pdf $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScanChecklists/
		elif [ "$sessionNum" == "2" ]; then
			ssh $remoteUser@$remoteIP "mkdir /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScanChecklists"
			scp $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_materials/dataCollectionForms/HCLV-dataCollection.pdf $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScanChecklists/
		elif [ "$sessionNum" == "3" ]; then
			ssh $remoteUser@$remoteIP "mkdir /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScanChecklists"
			scp $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_materials/dataCollectionForms/HCLV-dataCollection.pdf $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScanChecklists/
		fi
;;	
###### CLUSTER, NO DROPBOX	
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
	echo "No backup has been done on dropbox. Make sure it is done promptly!"
	echo "Stimuli folder has not been copied to the cluster. Make sure it is done promptly!"
;;

###### LOCAL, COPY FILES TO DROPBOX
"3")
	#enter subject and session details
	echo "Enter subject name (TOME_3xxx):"
	read subjName
	echo "Enter session date (mmddyy) :"
	read sessionDate
	echo "Enter session number (1, 2 or 3):"
	read sessionNum
	
	echo "Where do you want to copy the files from?"
	echo "1. From RICO (scanner computer)"
	echo "2. From the cluster"
	read fileSource
	case $fileSource in
	"1")
		echo "Copying files from RICO."
		echo "Paste the common part (first part) of the PulseOx file names and press [ENTER]. (Hint: in another terminal window, navigate into /mnt/disk_c/MedCom/log/Physio on rico, execute ls -ltr and locate the PulseOx files)."
		read pulseOxFiles
		echo "Paste the common part (first part) of the Protocol file names and press [ENTER]. (Hint: in another terminal window, navigate into /mnt/disk_c/MedCom/User/Aguirre on rico, execute ls -ltr and locate the Protocol files)."
		read protocolFiles
			
		if [ "$sessionNum" == "1" ]; then
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/PulseOx
			scp aguirrelab@rico:/mnt/disk_c/MedCom/log/Physio/$pulseOxFiles*PULS.log /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/PulseOx/
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/Protocols
			scp -r aguirrelab@rico:/mnt/disk_c/MedCom/User/Aguirre/$protocolFiles* /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/Protocols/
			scp aguirrelab@rico:/mnt/disk_c/MedCom/MriSiteData/GradientCoil/coeff.grad /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/
		elif [ "$sessionNum" == "2" ]; then
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/PulseOx
			scp aguirrelab@rico:/mnt/disk_c/MedCom/log/Physio/$pulseOxFiles*PULS.log /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/PulseOx/
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/Protocols
			scp -r aguirrelab@rico:/mnt/disk_c/MedCom/User/Aguirre/$protocolFiles* /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/Protocols/
			scp aguirrelab@rico:/mnt/disk_c/MedCom/MriSiteData/GradientCoil/coeff.grad /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/
		elif [ "$sessionNum" == "3" ]; then
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/PulseOx
			scp aguirrelab@rico:/mnt/disk_c/MedCom/log/Physio/$pulseOxFiles*PULS.log /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/PulseOx/
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/Protocols
			scp -r aguirrelab@rico:/mnt/disk_c/MedCom/User/Aguirre/$protocolFiles* /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/Protocols/
			scp aguirrelab@rico:/mnt/disk_c/MedCom/MriSiteData/GradientCoil/coeff.grad /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/	
		fi
		echo "Scanner files copied on Dropbox."
	;;
	"2")
		echo "Copying files from the cluster."
		echo "Enter your cluster username:"
		read clusterUser
		if [ "$sessionNum" == "1" ]; then
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/PulseOx
			scp $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/PulseOx/* /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/PulseOx/
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/Protocols
			scp -r $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/Protocols/* /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/Protocols/
			mv /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/Protocols/coeff.grad /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/
		elif [ "$sessionNum" == "2" ]; then
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/PulseOx
			scp $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/PulseOx/* /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/PulseOx/
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/Protocols
			scp -r $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/Protocols/* /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/Protocols/
			mv /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/Protocols/coeff.grad /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/
		elif [ "$sessionNum" == "3" ]; then
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/PulseOx
			scp $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/PulseOx/* /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/PulseOx/
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/Protocols
			scp -r $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/Protocols/* /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/Protocols/
			mv /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/Protocols/coeff.grad /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/	
		fi
		echo "Scanner files copied on Dropbox."
		echo "Copying README file. NOTE: if the file does not exist you'll receive an error message."
		if [ "$sessionNum" == "1" ]; then
			scp $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/README.md /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/
		elif [ "$sessionNum" == "2" ]; then
			scp $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/README.md /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/
		elif [ "$sessionNum" == "3" ]; then
			scp $clusterUser@chead:/data/jag/TOME/$subjName/$sessionDate/README.md /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/
		fi	
	;;
	*)
		echo "This option is not available."
	;;
	esac
	echo "Copying ScanChecklists in the session folder"
	if [ "$sessionNum" == "1" ]; then
		mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScanChecklists
		cp /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_materials/dataCollectionForms/HCLV-dataCollection.pdf /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScanChecklists/
	elif [ "$sessionNum" == "2" ]; then
		mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScanChecklists
		cp /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_materials/dataCollectionForms/HCLV-dataCollection.pdf /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScanChecklists/
	elif [ "$sessionNum" == "3" ]; then
		mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScanChecklists
		cp /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_materials/dataCollectionForms/HCLV-dataCollection.pdf /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/session3_OneLight/$subjName/$sessionDate/ScanChecklists/
	fi
;;
*) 
	echo "This option is not available"
	exit 1
;;
esac