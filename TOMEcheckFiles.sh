#!/bin/bash
#set -ex  #uncomment just for debugging

echo "Which files do you want to check?"
echo "1. All subject and sessions on the cluster (must be on the cluster or have cluster mounted as /data/jag/...)"
echo "2. All subject and sessions on Dropbox (must be on machine with read access to TOME_data)"
read lookHere

case $lookHere in
"1")
	echo "List of all existing subjects in /data/jag/TOME/ :"
	ls -ltr /data/jag/TOME/TOME*
	echo "Checking if all sessions contain all needed files..."
	subjs=(/data/jag/TOME/TOME*)
	echo "${subjs[@]}"
	for subjDir in "${subjs[@]}"; do
		sessionDirs=("$subjDir"/*)
		echo "Checking all existing session in $subjDir :" 
		ls "$subjDir"/
			for sessionDate in "${sessionDirs[@]}"; do
				if [ ! -d "$sessionDate"/DICOMS ]; then
					echo ">>> MISSING DICOMS DIRECTORY IN:"
					echo "$sessionDate"
				else
					echo "..."
				fi
		
				if [ ! -d "$sessionDate"/PulseOx ]; then
					echo "MISSING PulseOx DIRECTORY IN:"
					echo "$sessionDate"
				else
					echo "..."
				fi
		
				if [ ! -d "$sessionDate"/Protocols ]; then
					echo "MISSING Protocols DIRECTORY IN:"
					echo "$sessionDate"
				else
					echo "..."
				fi
		
				if [ ! -f "$sessionDate"/Protocols/coeff.grad ]; then
					echo "MISSING coeff.grad FILE IN:"
					echo "$sessionDate"
				else
					echo "..."
				fi
			
				if [ ! -d "$sessionDate"/Stimuli ]; then
					echo "MISSING Stimuli DIRECTORY IN:"
					echo "$sessionDate"
				else
					echo "..."
				fi
			
				if [ ! -f "$sessionDate"/README.md ]; then
					echo "MISSING README.md DOCUMENT IN:"
					echo "$sessionDate"
				else
					echo "..."
				fi
			done
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
		for subjDir in "${subjs[@]}"; do
			sessionDirs=("$subjDir"/*)
			echo "Checking all existing session in $subjDir :" 
			ls "$subjDir"/
				for sessionDate in "${sessionDirs[@]}"; do
					if [ ! -d "$sessionDate"/ScannerFiles ]; then
						echo ">>> MISSING ScannerFiles DIRECTORY IN:"
						echo "$sessionDate"
					else
						echo "..."
					fi
					
					if [ ! -d "$sessionDate"/ScannerFiles/Protocols ]; then
						echo ">>> MISSING ScannerFiles/Protocols DIRECTORY IN:"
						echo "$sessionDate/"
					else
						echo "..."
					fi
					
					if [ ! -d "$sessionDate/Scan_Checklists" ]; then
						echo ">>> MISSING ScanChecklists DIRECTORY IN:"
						echo "$sessionDate/"
					else
						echo "..."
					fi
	
					if [ ! -d "$sessionDate/EyeTracking" ]; then
						echo ">>> MISSING EyeTracking DIRECTORY IN:"
						echo "$sessionDate/"
					else
						echo "..."
					fi
		
					if [ ! -d "$sessionDate/Stimuli" ]; then
						echo ">>> MISSING Stimuli DIRECTORY IN:"
						echo "$sessionDate"
					else
						echo "..."
					fi
		
					if [ ! -f "$sessionDate/README.md" ]; then
						echo ">>> MISSING README.md document IN:"
						echo "$sessionDate"
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