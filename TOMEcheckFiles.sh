#!/bin/bash
#set -ex  #uncomment just for debugging

echo "Which files do you want to check?"
echo "1. All subject and sessions on the cluster (must be on the cluster)"
echo "2. All subject and sessions on Dropbox (must be on machine with read access to TOME_data)"
read lookHere

case $lookHere in
"1")
	echo "List of all existing subjects in /data/jag/TOME/ :"
	ls -ltr /data/jag/TOME/TOME*
	echo "Checking if all sessions contain all needed files..."
	
	### put a loop here
	
	for subjName in /data/jag/TOME/*; do
		if [[ $subjName == "TOME"* ]]; then
			for sessionDate in /data/jag/TOME/$subjName/*; do
				if [ ! -d /data/jag/TOME/$subjName/$sessionDate/DICOMS ]; then
					faultySession="/data/jag/TOME/$subjName/$sessionDate/"
					echo "MISSING DICOMS DIRECTORY IN:"
					echo $faultySession
				else
					echo "..."
				fi
		
				if [ ! -d /data/jag/TOME/$subjName/$sessionDate/PulseOx ]; then
					faultySession="/data/jag/TOME/$subjName/$sessionDate/"
					echo "MISSING PulseOx DIRECTORY IN:"
					echo $faultySession
				else
					echo "..."
				fi
		
				if [ ! -d /data/jag/TOME/$subjName/$sessionDate/Protocols ]; then
					faultySession="/data/jag/TOME/$subjName/$sessionDate/"
					echo "MISSING Protocols DIRECTORY IN:"
					echo $faultySession
				else
					echo "..."
				fi
		
				if [ ! -f /data/jag/TOME/$subjName/$sessionDate/Protocols/coeff.grad ]; then
					faultySession="/data/jag/TOME/$subjName/$sessionDate/"
					echo "MISSING coeff.grad FILE IN:"
					echo $faultySession
				else
					echo "..."
				fi
			
				if [ ! -d /data/jag/TOME/$subjName/$sessionDate/Stimuli ]; then
					faultySession="/data/jag/TOME/$subjName/$sessionDate/"
					echo "MISSING Stimuli DIRECTORY IN:"
					echo $faultySession
				else
					echo "..."
				fi
			
				if [ ! -f /data/jag/TOME/$subjName/$sessionDate/README.md ]; then
					faultySession="/data/jag/TOME/$subjName/$sessionDate/"
					echo "MISSING README.md DOCUMENT IN:"
					echo $faultySession
				else
					echo "..."
				fi
			done
		fi
	done
	echo "Check completed!"
;;

"2")
	echo "Checking if all sessions contain all needed files..."
	cons=( "session1_restAndStructure" "session2_spatialStimuli" )
	for condition in "${cons[@]}"; do
		echo "List of all existing subjects in /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/$condition/:"
		ls /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/$condition/
		subjs=(/Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/$condition/*)
		echo $subjs
		for subjName in "${subjs[@]}"; do
			echo $subjName
			sessionDirs=(/Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/"$condition"/"$subjName"/*)
			#if [[ subjName == "TOME"* ]]; then
				for sessionDate in "${sessionDirs[@]}"; do
				ls /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/"$condition"/"$subjName"/
				echo $sessionDate
				echo "AAAAA"
					if [ ! -d /Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/"$condition"/"$subjName"/"$sessionDate"/DICOMS ]; then
						echo "MISSING DICOMS DIRECTORY IN:"
						echo "/Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/$condition/$subjName/$sessionDate/"
						continue
					else
						echo "..."
					fi
	
					if [ ! -d "/Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/$condition/$subjName/$sessionDate/ScannerFiles" ]; then
						echo "MISSING ScannerFiles DIRECTORY IN:"
						echo "/Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/$condition/$subjName/$sessionDate/"
					else
						echo "..."
					fi
	
					if [ ! -d "/Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/$condition/$subjName/$sessionDate/Scan_Checklists" ]; then
						echo "MISSING ScanChecklists DIRECTORY IN:"
						echo "/Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/$condition/$subjName/$sessionDate/"
					else
						echo "..."
					fi
	
					if [ ! -d "/Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/$condition/$subjName/$sessionDate/EyeTracking" ]; then
						echo "MISSING EyeTracking DIRECTORY IN:"
						echo "/Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/$condition/$subjName/$sessionDate/"
					else
						echo "..."
					fi
		
					if [ ! -d "/Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/$condition/$subjName/$sessionDate/Stimuli" ]; then
						echo "MISSING Stimuli DIRECTORY IN:"
						echo "/Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/$condition/$subjName/$sessionDate/"
					else
						echo "..."
					fi
		
					if [ ! -f "/Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/$condition/$subjName/$sessionDate/README.md" ]; then
						echo "MISSING README.md document IN:"
						echo "/Users/$USER/Dropbox-Aguirre-Brainard-Lab/TOME_data/$condition/$subjName/$sessionDate/"
					else
						echo "..."
					fi
				done
			#fi
		done
	done
	echo "Check completed!"	
	;;
esac