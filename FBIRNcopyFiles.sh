#!/bin/bash
#set -ex  #uncomment just for debugging

echo -e "Copying FBIRN DICOMS from the scanner computer to the cluster and/or Dropbox. \nHow are you running this script? \n1. On the cluster, and I can remote in a machine with write access to Dropbox-Aguirre-Brainard-Lab/TOME_data\n2. On the cluster, and I don't have access to Dropbox.\n3.On a local machine, I just want to copy the scanner files on dropbox.\n4. None of the above."
read start

case $start in
"4") echo "This script will not work in your current setting. Please copy all files manually."
	 exit 1
;;

###### ON CLUSTER, DROPBOX ACCESS
"1")	
#enter subject and session details
	echo "Enter session date (mmddyy) :"
	read sessionDate
# make folders on the cluster
	echo "Creating session folder on the cluster..."
	mkdir /data/jag/TOME/FBIRN/$sessionDate
	#copy DICOM files on the cluster
	echo "Paste the full path to the dicom folder on the scanner computer and press [ENTER]. (Hint: navigate into the dicom folder on rico, execute pwd and paste the output here)."
	read dicomSource
	echo "Copying DICOM files on the cluster..."
	mkdir /data/jag/TOME/FBIRN/$sessionDate/DICOMS
	scp aguirrelab@rico:$dicomSource/* /data/jag/TOME/FBIRN/$sessionDate/DICOMS/
	echo "FBIRN DICOMs copied on the cluster."
	
	# enter credentials to remote in machine with write access to Dropbox
	echo "Enter your Username on the remote machine with write permission to TOME_data (e.g. <you>  @170.xxx.xx.xx)"
	read remoteUser
	echo "Enter your the remote machine IP address or alias (e.g. you@ <170.xxx.xx.xx>)"
	read remoteIP
	echo "Copying FBIRN DICOMS on Dropbox"
	ssh $remoteUser@$remoteIP "mkdir /Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/FBIRN/$sessionDate/"
	echo "Copying files..."
	scp -r /data/jag/TOME/FBIRN/$sessionDate/DICOMS $remoteUser@$remoteIP:/Users/$remoteUser/Dropbox-Aguirre-Brainard-Lab/TOME_data/FBIRN/$sessionDate/
	echo "FBIRN DICOMs copied on Dropbox."
;;
	
###### CLUSTER, NO DROPBOX	
"2")		
#enter subject and session details
	echo "Enter session date (mmddyy) :"
	read sessionDate
# make folders on the cluster
	echo "Creating session folder on the cluster..."
	mkdir /data/jag/TOME/FBIRN/$sessionDate
	#copy DICOM files on the cluster
	echo "Paste the full path to the dicom folder on the scanner computer and press [ENTER]. (Hint: navigate into the dicom folder on rico, execute pwd and paste the output here)."
	read dicomSource
	echo "Copying DICOM files on the cluster..."
	mkdir /data/jag/TOME/FBIRN/$sessionDate/DICOMS
	scp aguirrelab@rico:$dicomSource/* /data/jag/TOME/FBIRN/$sessionDate/DICOMS/
	echo "FBIRN DICOMs copied on the cluster."
;;

###### LOCAL, COPY FILES TO DROPBOX
"3")
	#enter subject and session details
	echo "Enter session date (mmddyy) :"
	read sessionDate	
	echo "Where do you want to copy the files from?"
	echo "1. From RICO (scanner computer)"
	echo "2. From the cluster"
	read fileSource
	case $fileSource in
	"1")
		echo "Copying FBIRN files from RICO."
		echo "Paste the full path to the dicom folder on the scanner computer and press [ENTER]. (Hint: navigate into the dicom folder on rico, execute pwd and paste the output here)."
		read dicomSource
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/FBIRN/$sessionDate/
			mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/FBIRN/$sessionDate/DICOMS
			scp aguirrelab@rico:$dicomSource/* /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/FBIRN/$sessionDate/DICOMS/
			
		echo "FBIRN DICOM files copied on Dropbox."
	;;
	"2")
		echo "Copying FBIRN files from the cluster."
		echo "Enter your cluster username:"
		read clusterUser
		mkdir /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/FBIRN/$sessionDate/
		scp -r $clusterUser@chead:/data/jag/TOME/FBIRN/$sessionDate/DICOMS /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/FBIRN/$sessionDate/
		echo "FBIRN DICOM files copied on Dropbox."
	;;
	*)
		echo "This option is not available."
	;;
	esac
;;
*) 
	echo "This option is not available"
	exit 1
;;
esac