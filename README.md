# HCLV
Project repository for the Human Connectome Low Vision project


## Data Managment shell scripts
These shell scripts are useful to copy newly acquired data on the cluster and on dropbox and to check the integrity of data already backed up, both on dropbox and on the cluster.

The "checkFiles" scripts will loop into the data directory and check if every subfolder is organized according to the standard structure and if it contains the appropriate amount/kind of files. If not, a warning message is presented to the user.
The "checkFiles" scripts DO NOT have the ability to alter saved data in any way. Any intervention on existing data following a warning message should be done by hand and with extreme caution. 

To use the "checkFiles" scripts the following is required:
- read access to TOME_data or AOSO_data on dropbox.

The "copyFiles" scripts will automatically create the standard folder structure on the cluster and/or on dropbox and copy data in the appropriate location. Every copying step depends on the user input for paths and passwords.
The "copyFiles" scripts do not have the ability to delete any previously saved data, but a user mistake may cause data to be erroneously overwritten. Use with caution.

To use the "copyFiles" scripts the following is required:
- read access to aguirrelab@rico
- read/write access to /data/jag/TOME on the cluster
- read/write access to TOME_data on dropbox (on a local machine, or the ability to remote into a machine that has it).

## eyeTracking folder
Contains the wrapper function to run the eyetracker and save fMRI eyetracking data according to the standard protocol for the Connectome project.
