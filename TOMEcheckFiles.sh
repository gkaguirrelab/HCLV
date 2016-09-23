#!/bin/bash
#set -ex  #uncomment just for debugging

echo "Which files do you want to check?"
echo "1. All subject and sessions on the cluster (must be on the cluster or have cluster mounted as /data/jag/...)"
echo "2. All subject and sessions on Dropbox (must be on machine with read access to TOME_data)"
read lookHere

case $lookHere in
"1")
	echo "List of all existing subjects in /data/jag/TOME/ :"
	ls /data/jag/TOME/TOME_3*
	echo "   "
	echo "   "
	echo "Checking if all sessions contain all needed files..."
	subjs=(/data/jag/TOME/TOME_3*)
	for subjDir in "${subjs[@]}"; do
		sessionDirs=("$subjDir"/*)
			for sessionDate in "${sessionDirs[@]}"; do
				echo "   "
				echo "   "
				echo "Checking files in $sessionDate ..."
				if [ ! -d "$sessionDate"/DICOMS ]; then
					echo ">>> MISSING DICOMS DIRECTORY IN:"
					echo "$sessionDate"
				fi
		
				if [ ! -d "$sessionDate"/PulseOx ]; then
					echo ">>> MISSING PulseOx DIRECTORY IN:"
					echo "$sessionDate"
				fi
		
				if [ ! -d "$sessionDate"/Protocols ]; then
					echo ">>> MISSING Protocols DIRECTORY IN:"
					echo "$sessionDate"
				fi
		
				if [ ! -f "$sessionDate"/Protocols/coeff.grad ]; then
					echo ">>> MISSING coeff.grad FILE IN:"
					echo "$sessionDate"
				fi
			
				if [ ! -d "$sessionDate"/Stimuli ]; then
					echo ">>> MISSING Stimuli DIRECTORY IN:"
					echo "$sessionDate"
				fi
			
				if [ ! -f "$sessionDate"/README.md ]; then
					echo ">>> MISSING README.md DOCUMENT IN:"
					echo "$sessionDate"
				fi
			done
	done
	echo "   "
	echo "   "
	echo "Check completed!"
;;

"2")
	echo "Checking if all sessions contain all needed files..."
	cons=( "session1_restAndStructure" "session2_spatialStimuli" )
	for condition in "${cons[@]}"; do
		echo "   "
		echo "   "
		echo "List of all existing subjects in /Users/$USER/Dropbox (Aguirre-Brainard Lab)/TOME_data/$condition/:"
		ls /Users/$USER/Dropbox\ \(Aguirre-Brainard\ Lab\)/TOME_data/$condition/
		subjs=(/Users/$USER/Dropbox\ \(Aguirre-Brainard\ Lab\)/TOME_data/$condition/*)
		for subjDir in "${subjs[@]}"; do
			sessionDirs=("$subjDir"/*)
				for sessionDate in "${sessionDirs[@]}"; do
				echo "   "
				echo "   "
				echo "Checking files in $sessionDate ..."
					if [ ! -d "$sessionDate"/ScannerFiles ]; then
						echo ">>> MISSING ScannerFiles DIRECTORY IN:"
						echo "$sessionDate"
					fi
					
					if [ ! -d "$sessionDate"/ScannerFiles/Protocols ]; then
						echo ">>> MISSING ScannerFiles/Protocols DIRECTORY IN:"
						echo "$sessionDate/"
					fi
					
					if [ ! -d "$sessionDate"/ScannerFiles/PulseOx ]; then
						echo ">>> MISSING ScannerFiles/PulseOx DIRECTORY IN:"
						echo "$sessionDate/"
					fi

					if [ ! -f "$sessionDate"/ScannerFiles/coeff.grad ]; then
						echo ">>> MISSING ScannerFiles/coeff.grad FILE IN:"
						echo "$sessionDate/"
					fi
										
					if [ ! -d "$sessionDate/Scan_Checklists" ]; then
						echo ">>> MISSING ScanChecklists DIRECTORY IN:"
						echo "$sessionDate/"
					fi
	
					if [ ! -d "$sessionDate/EyeTracking" ]; then
						echo ">>> MISSING EyeTracking DIRECTORY IN:"
						echo "$sessionDate/"
					fi
		
					if [ ! -d "$sessionDate/Stimuli" ]; then
						echo ">>> MISSING Stimuli DIRECTORY IN:"
						echo "$sessionDate"
					fi
		
					if [ ! -f "$sessionDate/README.md" ]; then
						echo ">>> MISSING README.md document IN:"
						echo "$sessionDate"
					fi
				done
			#fi
		done
	done
	echo "   "
	echo "   "
	echo "Check completed!"	
	;;
esac