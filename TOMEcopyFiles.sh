#!/bin/bash
#set -ex  #uncomment just for debugging

echo -e "===== Script for copying TOME Files from the scanner computer to dropbox and/or on a local path for backup purposes ====="
echo " "
echo " "

PS3="What do you want to do?"
options=("Copy DICOMS from the scanner computer to a local folder for DVD burning purposes" "Copy SCANNER FILES from the scanner computer to a local folder" "Copy SCANNER FILES from the scanner computer directly in TOME_data" "Read the HELP for this script" "Quit")

select start in "${options[@]}"; do

case $start in
"Quit") echo "Bye!"
	 break
;;

###### Copy DICOMS from the scanner computer to local
"Copy DICOMS from the scanner computer to a local folder for DVD burning purposes")	
	#enter subject and session details
	echo "Enter subject name (TOME_3xxx):"
	read subjName
	echo "Enter session date (mmddyy) :"
	read sessionDate
	echo "Enter session number (1, 2 or 3):"
	read sessionNum
	# make folders on the cluster
	echo "Creating TEMP folders on the desktop..."
	mkdir -p ~/Desktop/$subjName/
	if [ ! -d ~/Desktop/$subjName/$sessionDate/DICOMS ]; then
		mkdir ~/Desktop/$subjName/$sessionDate/DICOMS
	else
		echo "This DICOM folder already exists. How do you want to rename the existing DICOM folder (e.g. 022912a)?"
		read renameExisting
		mv ~/Desktop/$subjName/$sessionDate /data/jag/TOME/$subjName/$renameExisting
		echo "How do you want to name the new session folder (e.g. 022912b)?"
		read sessionDate
		mkdir ~/Desktop/$subjName/$sessionDate
		mkdir ~/Desktop/$subjName/$sessionDate/DICOMS
	fi
	
	#copy DICOM files
	echo "Firstly, locate the DICOMS on the scanner computer. Open a new terminal window and access rico, the scanner computer typing:"
	echo "1. Open a new terminal window and access rico, the scanner computer typing:"
	echo "ssh aguirrelab@rico"
	echo "2. Navigate in the dicom folder on rico. For the standard DICOM path type:"
	echo "ls -ltr /mnt/rtexport/RTexport_current/"
	echo "3. Navigate into the current session DICOM folder using the command:"
	echo "cd <folder name>"
	echo "4. Execute:"
	echo "pwd"
	echo "5. Paste the output here"
	read dicomSource
	echo "Copying DICOM files in the local folder..."
	scp aguirrelab@rico:$dicomSource/* ~/Desktop/$subjName/$sessionDate/DICOMS/
	echo "DICOMs copied!"
	echo " "
;;

"Copy SCANNER FILES from the scanner computer to a local folder")
	echo "Warning: No backup has been done on dropbox. Make sure it is done promptly!"
	#enter subject and session details
	echo "Enter subject name (TOME_3xxx):"
	read subjName
	echo "Enter session date (mmddyy) :"
	read sessionDate
	echo "Enter session number (1, 2 or 3):"
	read sessionNum
	# make folders on the cluster
	echo "Creating TEMP folders on the desktop..."
	mkdir -p ~/Desktop/$subjName
	if [ ! -d ~/Desktop/$subjName/$sessionDate/ScannerFiles ]; then
		mkdir ~/Desktop/$subjName/$sessionDate/ScannerFiles
	else
		echo "This ScannerFiles folder already exists. How do you want to rename the existing scannerFiles folder (e.g. 022912a)?"
		read renameExisting
		mv ~/Desktop/$subjName/$sessionDate /data/jag/TOME/$subjName/$renameExisting
		echo "How do you want to name the new session folder (e.g. 022912b)?"
		read sessionDate
		mkdir ~/Desktop/$subjName/$sessionDate/ScannerFiles
	fi
	
	# copy pulseOx files
	echo "Copy pulseOx files:"
	echo "1. Open a new terminal window and access rico, the scanner computer typing:"
	echo "ssh aguirrelab@rico"
	echo "2. Copy and paste:"
	echo "cd /mnt/disk_c/MedCom/log/Physio"
	echo "ls -ltr"
	echo "3. Locate the pulseOx files in the list."
	echo "4. Copy the INITIAL COMMON part of the name of the pulseOx files,paste it here and press [ENTER]." 
	read pulseOxFiles
	echo "Copying PulseOx files in the local folder..."
	mkdir ~/Desktop/$subjName/$sessionDate/ScannerFiles/PulseOx
	scp aguirrelab@rico:/mnt/disk_c/MedCom/log/Physio/$pulseOxFiles*PULS.log ~/Desktop/$subjName/$sessionDate/ScannerFiles/PulseOx/
	echo "PulseOx files copied!"
	
	# copy Protocols Files on the cluster
	echo "5. For the protocol files, Copy and paste the following IN THE OTHER TERMINAL WINDOW"
	echo "cd /mnt/disk_c/MedCom/User/Aguirre"
	echo "ls -ltr"
	echo "6. Locate the protocol files in the list."
	echo "7. Copy the INITIAL COMMON part of the name of the protocol files,paste it here and press [ENTER]." 
	read protocolFiles
	echo "Copying protocol files..."
	mkdir ~/Desktop/$subjName/$sessionDate/ScannerFiles/Protocols
	scp -r aguirrelab@rico:/mnt/disk_c/MedCom/User/Aguirre/$protocolFiles* ~/Desktop/$subjName/$sessionDate/ScannerFiles/Protocols/
	scp aguirrelab@rico:/mnt/disk_c/MedCom/MriSiteData/GradientCoil/coeff.grad ~/Desktop/$subjName/$sessionDate/ScannerFiles/
	echo "Protocol files copied!"
	echo "Do you want to write the README.md file now?[y/n]"
	read readme
	if [ "$readme" == "y" ]; then
		echo "The README file will be created and opened. Write and save its content, and close text editor to continue with this script."
		read -rsp $'Press enter to continue...\n'
		touch ~/Desktop/$subjName/$sessionDate/README.md
		open -e ~/Desktop/$subjName/$sessionDate/README.md
	else
		echo "Remember to write the README file as soon as possible!"
	fi
	echo "All done!"
;;

"Copy SCANNER FILES from the scanner computer directly in TOME_data")
	
	echo "Enter the local path to the Dropbox folder with write access to TOME_data"
	read dropboxPath
	
	#enter subject and session details
	echo "Enter subject name (TOME_3xxx):"
	read subjName
	echo "Enter session date (mmddyy) :"
	read sessionDate
	echo "Enter session number (1, 2 or 3):"
	read sessionNum
		
	# copy scanner files on dropbox
	echo "Copying files on dropbox..."
	if [ "$sessionNum" == "1" ]; then
		sessionName="session1_restAndStructure"
		mkdir $dropboxPath/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles 
		mkdir $dropboxPath/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/PulseOx 
		mkdir $dropboxPath/TOME_data/session1_restAndStructure/$subjName/$sessionDate/ScannerFiles/Protocols
	elif [ "$sessionNum" == "2" ]; then
		sessionName="session2_spatialStimuli"
		mkdir $dropboxPath/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles 
		mkdir $dropboxPath/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/PulseOx 
		mkdir $dropboxPath/TOME_data/session2_spatialStimuli/$subjName/$sessionDate/ScannerFiles/Protocols	
	elif [ "$sessionNum" == "3" ]; then
		sessionName="session3_OneLight"
		mkdir $dropboxPath/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles 
		mkdir $dropboxPath/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/PulseOx 
		mkdir $dropboxPath/TOME_data/session3_OneLight/$subjName/$sessionDate/ScannerFiles/Protocols	
	fi
	
	# copy pulseOx files
	echo "Copy pulseOx files:"
	echo "1. Open a new terminal window and access rico, the scanner computer typing:"
	echo "ssh aguirrelab@rico"
	echo "2. Copy and paste:"
	echo "cd /mnt/disk_c/MedCom/log/Physio"
	echo "ls -ltr"
	echo "3. Locate the pulseOx files in the list."
	echo "4. Copy the INITIAL COMMON part of the name of the pulseOx files,paste it here and press [ENTER]." 
	read pulseOxFiles
	echo "Copying PulseOx files in the dropbox folder..."
	scp aguirrelab@rico:/mnt/disk_c/MedCom/log/Physio/$pulseOxFiles*PULS.log $dropboxPath/TOME_data/$sessionName/$subjName/$sessionDate/ScannerFiles/PulseOx/
	echo "PulseOx files copied!"
	
	# copy Protocols Files on the cluster
	echo "5. For the protocol files, Copy and paste the following IN THE OTHER TERMINAL WINDOW"
	echo "cd /mnt/disk_c/MedCom/User/Aguirre"
	echo "ls -ltr"
	echo "6. Locate the protocol files in the list."
	echo "7. Copy the INITIAL COMMON part of the name of the protocol files,paste it here and press [ENTER]." 
	read protocolFiles
	echo "Copying protocol files..."
	scp -r aguirrelab@rico:/mnt/disk_c/MedCom/User/Aguirre/$protocolFiles* $dropboxPath/TOME_data/$sessionName/$subjName/$sessionDate/ScannerFiles/Protocols/
	scp aguirrelab@rico:/mnt/disk_c/MedCom/MriSiteData/GradientCoil/coeff.grad $dropboxPath/TOME_data/$sessionName/$subjName/$sessionDate/ScannerFiles/
	echo "Protocol files copied!"
	
	# readme file
	echo "Do you want to write the README.md file now?[y/n]"
	read readme
	if [ "$readme" == "y" ]; then
		echo "The README file will be created and opened. Write and save its content, and close text editor to continue with this script."
		read -rsp $'Press enter to continue...\n'
		touch $dropboxPath/TOME_data/$sessionName/$subjName/$sessionDate/README.md
		open -e $dropboxPath/TOME_data/$sessionName/$subjName/$sessionDate/README.md
	else
		echo "Remember to write the README file as soon as possible!"
	fi
	
	
	# HCLV data collection
	echo "Copying HCLV-dataCollection.pdf on Dropbox"
	mkdir $dropboxPath/TOME_data/$sessionName/$subjName/$sessionDate/ScanChecklists
	cp $dropboxPath/TOME_materials/dataCollectionForms/HCLV-dataCollection.pdf $dropboxPath/TOME_data/$sessionName/$subjName/$sessionDate/ScanChecklists/
	
	echo "All done!"
	
;;		
"Read the HELP for this script")		
	echo "Help file not available"
;;
*) 
	echo "This option is not available"
;;
esac
done