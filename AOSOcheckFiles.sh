#!/bin/bash
#set -ex  #uncomment just for debugging

echo "Checking if all AOSO sessions on Dropbox contain all needed files..."
echo "   "
echo "   "
echo "List of all existing subjects in /Users/$USER/Dropbox (Aguirre-Brainard Lab)/AOSO_data/connectomeRetinaData/:"
ls /Users/$USER/Dropbox\ \(Aguirre-Brainard\ Lab\)/AOSO_data/connectomeRetinaData/
subjs=(/Users/$USER/Dropbox\ \(Aguirre-Brainard\ Lab\)/AOSO_data/connectomeRetinaData/*)
for subjDir in "${subjs[@]}"; do
	echo "   "
	echo "   "
	echo "Checking files in $subjDir ..."
	if [ ! -d "$subjDir"/Fundus ]; then
		echo ">>> MISSING Fundus DIRECTORY IN:"
		echo "$subjDir"
	fi
	
	for files in "$subjDir"/Fundus/*.bmp; do
		if [ ! -e "$files" ]; then
			echo ">>> MISSING Fundus.bpm FILES IN:"
			echo "$subjDir/"
			break
		fi
	done
	
	if [ ! -d "$subjDir"/HeidelbergSpectralisOCT ]; then
		echo ">>> MISSING HeidelbergSpectralisOCT DIRECTORY IN:"
		echo "$subjDir"
	fi
	
	if [ ! -d "$subjDir"/HeidelbergSpectralisOCT/OD ]; then
		echo ">>> MISSING HeidelbergSpectralisOCT/OD DIRECTORY IN:"
		echo "$subjDir"
	fi
	
	for files in "$subjDir"/HeidelbergSpectralisOCT/OD/*.E2E; do
		if [ ! -e "$files" ]; then
			echo ">>> MISSING OD E2E FILES IN:"
			echo "$subjDir/"
			break
		fi
	done
	
	if [ ! -d "$subjDir"/HeidelbergSpectralisOCT/OD/OD-Raw-Vol/ ]; then
		echo ">>> MISSING HeidelbergSpectralisOCT/OD/OD-Raw-Vol/ DIRECTORY IN:"
		echo "$subjDir"
	fi
	
	for files in "$subjDir"/HeidelbergSpectralisOCT/OD/OD-Raw-Vol/*.vol; do
		if [ ! -e "$files" ]; then
			echo ">>> MISSING OD vol FILES IN:"
			echo "$subjDir/"
			break
		fi
	done				
	
	if [ ! -d "$subjDir"/HeidelbergSpectralisOCT/OS ]; then
		echo ">>> MISSING HeidelbergSpectralisOCT/OS DIRECTORY IN:"
		echo "$subjDir"
	fi
	
	for files in "$subjDir"/HeidelbergSpectralisOCT/OS/*.E2E; do
		if [ ! -e "$files" ]; then
			echo ">>> MISSING OS E2E FILES IN:"
			echo "$subjDir/"
			break
		fi
	done
	
	if [ ! -d "$subjDir"/HeidelbergSpectralisOCT/OS/OS-Raw-Vol ]; then
		echo ">>> MISSING HeidelbergSpectralisOCT/OS/OS-Raw-Vol/ DIRECTORY IN:"
		echo "$subjDir"
	fi
	
	for files in "$subjDir"/HeidelbergSpectralisOCT/OS/OS-Raw-Vol/*.vol; do
		if [ ! -e "$files" ]; then
			echo ">>> MISSING OD vol FILES IN:"
			echo "$subjDir/"
			break
		fi
	done		
		
	if [ ! -d "$subjDir"/MAIA ]; then
		echo ">>> MISSING MAIA DIRECTORY IN:"
		echo "$subjDir"
	fi
	
	for files in "$subjDir"/MAIA/*.png; do
		if [ ! -e "$files" ]; then
			echo ">>> MISSING png FILES IN:"
			echo "$subjDir/MAIA"
			break
		fi
	done
	
	for files in "$subjDir"/MAIA/*.tgz; do
		if [ ! -e "$files" ]; then
			echo ">>> MISSING MAIA.tgz FILE IN:"
			echo "$subjDir/MAIA"
			break
		fi
	done
	
	if [ ! -d "$subjDir"/Optos ]; then
		echo ">>> MISSING Optos DIRECTORY IN:"
		echo "$subjDir"
	fi
	
	for files in "$subjDir"/Optos/*; do
		if [ ! -e "$files" ]; then
			echo ">>> MISSING tif FILES IN:"
			echo "$subjDir/Optos"
			break
		fi
	done
done
echo "   "
echo "   "
echo "Check completed!"	