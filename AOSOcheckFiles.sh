#!/bin/bash
#set -ex  #uncomment just for debugging

echo "Checking username. If not familiar, will just assume standard dropbox location"
echo "Username:"
echo $USER

# special user cases
if [ $USER == "GKALab" ]; then
	dbRoot="Volumes/External\ \GKA20\ \Drive"
else
	dbRoot="Users"
fi

echo "Checking if all AOSO sessions on Dropbox contain all needed files..."
echo "   "
echo "   "
echo "List of all existing subjects in /$dbRoot/$USER/Dropbox (Aguirre-Brainard Lab)/AOSO_data/connectomeRetinaData/:"
ls /$dbRoot/$USER/Dropbox\ \(Aguirre-Brainard\ Lab\)/AOSO_data/connectomeRetinaData/
subjs=(/$dbRoot/$USER/Dropbox\ \(Aguirre-Brainard\ Lab\)/AOSO_data/connectomeRetinaData/*)
for subjDir in "${subjs[@]}"; do
	echo "   "
	echo "   "
	echo "Checking files in $subjDir ..."
	
	# get subjectName
	subjName="${subjDir: -5}"
	echo "Subject code = $subjName"
	
	# check pdf file
	for files in "$subjDir"/"$subjName"*.pdf; do
			if [ ! -e "$files" ]; then
				echo ">>> MISSING pdf FILE IN:"
				echo "$subjDir/"
				break
			fi
	done
	
	# check Fundus folder
	if [ ! -d "$subjDir"/Fundus ]; then
		echo ">>> MISSING Fundus DIRECTORY IN:"
		echo "$subjDir"
	else
		for files in "$subjDir"/Fundus/"$subjName"*.bmp; do
			if [ ! -e "$files" ]; then
				echo ">>> MISSING Fundus.bpm FILES IN:"
				echo "$subjDir/"
				break
			fi
		done
	fi
	
	# check HeidelbergSpectralisOCT folder
	if [ ! -d "$subjDir"/HeidelbergSpectralisOCT ]; then
		echo ">>> MISSING HeidelbergSpectralisOCT DIRECTORY IN:"
		echo "$subjDir"
	else
		# check HeidelbergSpectralisOCT/OD folder
		if [ ! -d "$subjDir"/HeidelbergSpectralisOCT/OD ]; then
			echo ">>> MISSING HeidelbergSpectralisOCT/OD DIRECTORY IN:"
			echo "$subjDir"
		else
			for files in "$subjDir"/HeidelbergSpectralisOCT/OD/"$subjName"*.E2E; do
				if [ ! -e "$files" ]; then
					echo ">>> MISSING OD E2E FILES IN:"
					echo "$subjDir/"
					break
				fi
			done
	
			for files in "$subjDir"/HeidelbergSpectralisOCT/OD/"$subjName"*.vol; do
				if [ ! -e "$files" ]; then
					echo ">>> MISSING HeidelbergSpectralisOCT/OD vol FILES IN:"
					echo "$subjDir/"
					break
				fi
			done
		fi	
		# check HeidelbergSpectralisOCT/OS folder			
		if [ ! -d "$subjDir"/HeidelbergSpectralisOCT/OS ]; then
			echo ">>> MISSING HeidelbergSpectralisOCT/OS DIRECTORY IN:"
			echo "$subjDir"
		else
			for files in "$subjDir"/HeidelbergSpectralisOCT/OS/"$subjName"*.E2E; do
				if [ ! -e "$files" ]; then
					echo ">>> MISSING OS E2E FILES IN:"
					echo "$subjDir/"
					break
				fi
			done
			for files in "$subjDir"/HeidelbergSpectralisOCT/OS/"$subjName"*.vol; do
				if [ ! -e "$files" ]; then
					echo ">>> MISSING HeidelbergSpectralisOCT/OS vol FILES IN:"
					echo "$subjDir/"
					break
				fi
			done
		fi	
	fi
	
	# check MAIA folder		
	if [ ! -d "$subjDir"/MAIA ]; then
		echo ">>> MISSING MAIA DIRECTORY IN:"
		echo "$subjDir"
	else
		for files in "$subjDir"/MAIA/"$subjName"*.png; do
			if [ ! -e "$files" ]; then
				echo ">>> MISSING png FILES IN:"
				echo "$subjDir/MAIA"
				break
			fi
		done
	
		for files in "$subjDir"/MAIA/"$subjName"*.tgz; do
			if [ ! -e "$files" ]; then
				echo ">>> MISSING MAIA.tgz FILE IN:"
				echo "$subjDir/MAIA"
				break
			fi
		done
	fi
	
	# check OptosSLO folder
	if [ ! -d "$subjDir"/OptosSLO ]; then
		echo ">>> MISSING OptosSLO DIRECTORY IN:"
		echo "$subjDir"
	else
		for files in "$subjDir"/OptosSLO/"$subjName"*; do
			if [ ! -e "$files" ]; then
				echo ">>> MISSING tif FILES IN:"
				echo "$subjDir/OptosSLO"
				break
			fi
		done
	fi	
done

echo "   "
echo "   "
echo "Check completed!"	