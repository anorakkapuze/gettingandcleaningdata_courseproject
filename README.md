
# gettingandcleaningdata_courseproject

## Introduct, setup and requirements

This repository contains a single script that works on data in the given data set, https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
and for proper execution must be placed at the same hierarchy level as the UCI HAR Dataset folder.

## What the script does
The script solely operates on the given feature vectors of the given test and training set (cf. the README of the original
data set), i.e. the X_test and X_train data; the original intertial signals are not processes.
The feature vectors contained in X_test and X_train are merged, and each variable labelled according to the names in the features.txt file, which are explained in features_info.txt. 
Each obervation in the data is associated with an activity (see y_train.txt, y_test.txt)
which are number coded to signify a certain named activity (see activity_labels.txt). The appropriate activity labels are read into an extra column.
Furthermore, each observation is associated with one out of 30 subjects performing the activity (see subject_train.txt, subject_test.txt). The appropriate subject numbers are read into an extra column.
Next, all variables not containing the mean() or std() of a variable in the title are removed.
From this full data set, a new data set is generated which, for each subject and each activity, gives the mean of each variable, taken over all observations with the same subject and activity. This is indicated by adding an external "mean()" to the column names.
As a last step, the final data set is written out to the file "final_data_set.txt"


