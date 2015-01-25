# getting-and-cleaning-data
=============

This repository holds the course project delivered as part of Coursera's "Getting and Cleaning Data" course. 

##Introduction
The project consists of one script and one code book.

###Script
The script is named run\_analysis.R

This script:
1. Takes care of downloading and unzipping data if not present. If unzipped data is already there, no unzipping is done. If ZIP source file is already there, no download is done.
2. Loads data in memory and performs operations to make it tidy, by combining different data fragments together into a clean data frame.
4. Extracts and processes data as required by the assignment.
5. Writes the result into a text file named tidy.txt

**Note:** This script might require the installation of some additional packages, depending on your initial setup.

This script was tested on a Windows 7 64-bit machine.

###Code book
The codebook can be found [TO BE DEFINED](xxx).

##Source data
- [ZIP file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
- [full details](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

##How to use
1. Set working directory to where you want source and output data to be located.
2. Load the script.
3. Call its main() function.
4. Collect output file tidy.txt in the working directory.
5. You will also find the source data in zipped (dataset.zip file) and unzipped (dataset directory and sub-directories) forms.

- You can call the removeFiles() function to remove the ZIP file and the dataset directory holding the unzipped data.

##Output format
Output files is in CSV format.
It can be loaded using read.table().

###tidy.txt
This file contains the input data filtered to mean and standard deviation measures, and listed along with the relevant subject and activity name. 
###tidy2.txt
This file contains the average of each measure for each activity and each subject present in the input.

##Requirements
* File download is enabled or source ZIP file is already present in the script's directory and named 'dataset.zip' or unzipped data is already present in a subdirectory called 'dataset' in the script's directory.
* Directory structure and filenames comply to the initial setup:
  * directory 'dataset', containing:
    * directory 'UCI HAR Dataset', containing:
      * 'activity\_labels.txt' file.
      * 'features.txt' file.
      * directories \<setname\> where \<setname\> is 'train' or 'test', containing each a dataset, structured as follows:
        * 'X\_\<setname\>.txt' file
        * 'y\_\<setname\>.txt' file
        * 'subject_\<setname\>.txt' file
        * directory 'Inertial Signals', containing 9 files (\<axis\> is 'x' or 'y' or 'z'):
          * body\_acc\_\<axis\>\_<setname>.txt
          * body\_gyro\_\<axis\>\_<setname>.txt
          * body\_acc\_\<axis\>\_<setname>.txt
