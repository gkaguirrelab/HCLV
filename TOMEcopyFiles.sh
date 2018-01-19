#!/bin/bash
#set -ex  #uncomment just for debugging

while :
do
    cat<<EOF
    ========================================================================
             Backup script for TOME files from the scanner computer        
    ------------------------------------------------------------------------
    What do you want to do?

    Copy DICOMS from the scanner computer to a local folder            (1)
    Copy SCANNER FILES from the scanner computer to a local folder     (2)
    Copy SCANNER FILES from the scanner computer directly in TOME_data (3)
    Read the HELP for this script                                      (4)
    Quit                                                               (q)
    ------------------------------------------------------------------------
EOF
    read -n1 -s
    case "$REPLY" in
    
"q") echo "Bye!"
	 break
;;

###### Copy DICOMS from the scanner computer to local
"1")	
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
	mkdir -p ~/Desktop/$subjName/$sessionDate/
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
	cat<<EOF
	
	Copy the DICOMS:
	
	1. Open a new terminal window and access rico, the scanner computer typing:
	ssh aguirrelab@rico
	
	2. Navigate in the dicom folder on rico. For the standard DICOM path type:
	cd /mnt/rtexport/RTexport_current/
	ls -ltr
	
	3. Navigate into the current session DICOM folder using the command:
	cd <folder name>
	
	4. Execute:
	pwd
	
	5. Paste the output here and press [RETURN]
	
EOF
	read dicomSource
	echo "Copying DICOM files in the local folder..."
	scp aguirrelab@rico:$dicomSource/* ~/Desktop/$subjName/$sessionDate/DICOMS/
	echo " "
	echo "DICOMs copied!"
	echo " "
	echo "Remeber to delete the temp folder from the desktop after burning the DVD!"
	echo " "
;;

"2")
	echo "Warning: No backup will be done on dropbox. Make sure it is done promptly!"
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
	mkdir -p ~/Desktop/$subjName/$sessionDate/
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
	cat<<EOF
	
	Copy pulseOx files:
	
	1. Open a new terminal window and access rico, the scanner computer, typing:
	ssh aguirrelab@rico
	
	2. Copy and paste:
	cd /mnt/disk_c/MedCom/log/Physio
	ls -ltr
	
	3. Locate the pulseOx files in the list.
	
	4. Copy the INITIAL COMMON PART of the name of the pulseOx files,paste it here and press [RETURN]."
	
EOF
	read pulseOxFiles
	echo "Copying PulseOx files in the local folder..."
	mkdir ~/Desktop/$subjName/$sessionDate/ScannerFiles/PulseOx
	scp aguirrelab@rico:/mnt/disk_c/MedCom/log/Physio/$pulseOxFiles*PULS.log ~/Desktop/$subjName/$sessionDate/ScannerFiles/PulseOx/
	echo "PulseOx files copied!"
	
	# copy Protocols Files locally
	cat<<EOF
	
	5. For the protocol files, Copy and paste the following IN THE RICO TERMINAL WINDOW
	cd /mnt/disk_c/MedCom/User/Aguirre
	
	ls -ltr
	
	6. Locate the protocol files in the list.
	
	7. Copy the INITIAL COMMON part of the name of the protocol files,paste it here and press [RETURN].
	
EOF
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
		cat<<EOF
		
		Here is a handy template for the README:
		
		DATA COLLECTED AT SC3T ON xx/xx/xx (tech:xx, sc:xx, eo:xx, so:xx)

​ 		Subject was TOME_30xx, running the Connectome Session x protocol. Subject's eyes were <uncorrected/corrected by contacts or lens/ patched>

		Eye tracking data was acquired using the LiveTrack device, raw videos of the eye were acquired concurrently using the VTOP device.
		
		<Any subject issue here>
		
		<Any hardware issue here>
		
		<Any protocol issue here>

		The order of the acquired protocols is as follows:

		... 
		<specify all runs as they are reported in the final page of the protocol pdf and 
		the calibrations. Add all relevant comment to the run, i.e. subject sleepy, stopped
		hardware error etc>
		
		
 
EOF
		read -rsp $'When ready, press [RETURN] to continue...\n'
		touch ~/Desktop/$subjName/$sessionDate/README.md
		open -e ~/Desktop/$subjName/$sessionDate/README.md
	else
		echo "Remember to write the README file as soon as possible!"
	fi
	echo "All done!"
;;

"3")
	
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
	
	# copy pulseOx files on dropbox
	cat<<EOF
	
	Copy pulseOx files:
	
	1. Open a new terminal window and access rico, the scanner computer, typing:
	ssh aguirrelab@rico
	
	2. Copy and paste:
	cd /mnt/disk_c/MedCom/log/Physio
	ls -ltr
	
	3. Locate the pulseOx files in the list.
	
	4. Copy the INITIAL COMMON PART of the name of the pulseOx files,paste it here and press [RETURN]."
	
EOF
	read pulseOxFiles
	echo "Copying PulseOx files in the dropbox folder..."
	scp aguirrelab@rico:/mnt/disk_c/MedCom/log/Physio/$pulseOxFiles*PULS.log $dropboxPath/TOME_data/$sessionName/$subjName/$sessionDate/ScannerFiles/PulseOx/
	echo "PulseOx files copied!"
	
	# copy Protocols Files on dropbox
	cat<<EOF
	
	5. For the protocol files, Copy and paste the following IN THE RICO TERMINAL WINDOW
	cd /mnt/disk_c/MedCom/User/Aguirre
	
	ls -ltr
	
	6. Locate the protocol files in the list.
	
	7. Copy the INITIAL COMMON part of the name of the protocol files,paste it here and press [RETURN].
	
EOF
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
		cat<<EOF
		
		Here is a handy template for the README:
		
		----------------------------
		
		DATA COLLECTED AT SC3T ON xx/xx/xx (tech:xx, sc:xx, eo:xx, so:xx)

​ 		Subject was TOME_30xx, running the Connectome Session x protocol. 
        Subject's eyes were <uncorrected/corrected by contacts or lens/ patched>

		Eye tracking data was acquired using the LiveTrack device, raw videos of the eye 
		were acquired concurrently using the VTOP device.
		
		<Any subject issue here>
		
		<Any hardware issue here>
		
		<Any protocol issue here>

		The order of the acquired protocols is as follows:

		<specify all runs as they are reported in the final page of the protocol pdf and 
		the calibrations. Add all relevant comment to the run, i.e. subject sleepy, stopped
		hardware error etc>
		
		------------------------------
 
EOF
		read -rsp $'When ready, press [RETURN] to continue...\n'
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
"4")		
	cat<<EOF
	
	                         HELP for TOMEcopyFiles.sh
	
	This script is used to retrieve data from the scanner computer (aguirrelab@rico) and
	back it up according to the standard TOME procedures.
	
	In order to work, this script needs to be run on a machine with ssh access to the
	scanner computer. All machines on the LAN hospital network (uphs) can ssh into rico.
	Machines on the wifi network won't be able to access rico and transfer scanner data.
	Machine on VPN might be able to transfer files from rico, depending on the vpn
	pemissions.
	
	Data should be backed up as soon as possible after the session, as the scanner hard
	drive is frequently erased. All session files must be burned on DVD. 
	
	Option 1 allows to copy the DICOMS file on a local folder. The local folder is saved 
	on the desktop and should be erased immediately after transferring the DICOM data on a
	DVD. The script will prompt the instructions on how to locate the DICOMS on rico, based
	on their standard location.
	
	Option 2 allows to copu the PulseOx and Protocol files to a local folder on the desktop.
	The files in this folder (specifically in the "ScannerFiles" folder) should be copied 
	on Dropbox and on DVD as soon as possible. It is highly recommended to write the README
	file for the session at this moment as well.
	
	Option 3 will do the same as 2, except that it will write the data directly on dropbox.
	If the machine in use has direct writing access to a synced TOME_data folder on dropox,
	this is the preferred option to copy the scanner files. The files must also be copied
	on DVD. It is highly recommended to write the README file for the session at this 
	moment.
	
EOF

;;
*) 
	echo "This option is not available"
;;
esac
sleep 1
done