
# Data Introduction

The current project uses data from the Human Activity Recognition Using Smartphones experiment. [The data can be downloaded from their site](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 
Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 
The experiments have been video-recorded to label the data manually. 
The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

More information on the data can be found on the [Human Activity Recognition Using Smartphones website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

## Available files 
In total, there are six data files, namely:
- `x_train.txt`: Training set.
- `x_test.txt`: Training labels. 
- `y_train.txt`: Test set. 
- `y_test.txt`:  Test labels.
- `subject_train.txt`: in which each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- `subject_test.txt`:in which each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

In addition, there are some explanatory files:
- `features.txt` which contains the correct variable name, which corresponds to each column of `x_train.txt` and `x_test.txt`. Further explanation of each feature is in the `features_info.txt`. 
- `activity_labels.txt` which contains the desciptive names for each activity label, which corresponds to each number in the `y_train.txt` and `y_test.txt`.
- The `README.txt` is the overall desciption about the overall process of how publishers of this dataset did the experiment and got the data result.

# Course Project Assignment
The script `run_analysis.R` uses the `dplyr` package for renaming column and reading in files. It performs 5 (and a half?) major steps including:

0. Setting the correct setting.
* Loading the needed packages
* Setting working dir
* Loading the data, the column names are manually set with exception of the `x_train.txt` and `x_test.txt` for which the `features.txt` is used to set the column names.

1. Merges the training and the test sets to create one data set. 
* The `x_train.txt`, `y_train.txt`, `subject_train.txt` are binded by column, resulting in `training_data`.
* The `x_test.txt`, `y_test.txt`, `subject_test.txt` are binded by column, resulting in `test_data`.
* `training_data` and `test_data` are row binded, resulting in `full_data`.

2. Extracts only the measurements on the mean and standard deviation for each measurement. 
* Extract the columns (from `full_data`) which we want to keep. That is, only keep subject, code, those with mean or std in their names.
* Select the columns we want to keep using the previously created vector.

3. Uses descriptive activity names to name the activities in the data set.
* Join the activities data by code so that a new column is added with the descriptive names

4. Appropriately labels the data set with descriptive variable names. 
* Partly done above (by manually setting the names + using the features file)
* Using regular expressions, expand the variable names so that they are readable for people who are not familiar with the data.
   * All Acc in column’s name replaced by Accelerometer.
   * All Gyro in column’s name replaced by Gyroscope.
   * All BodyBody in column’s name replaced by Body.
   * All Mag in column’s name replaced by Magnitude.
   * All start with character f in column’s name replaced by Frequency.
   * All start with character t in column’s name replaced by Time.
   * Adding [_] to seperate words, making names easier to read. 

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.   
* Group by subject and activity in order to get their means. 
* Summarise the data
* Write out the tidy (aggegrated) dataset to `tidy_dataset.txt`.

# Final Tidy Data Description
The final tidy data is produced inside the `run_analysis.R`. 

- `full_data` is the tidy data produced after going through the first 4 steps of the course project. It contains 10299 observations and 81 variables.
  * The first column refers to each subject that did the experiment. 
  * Column 2~80 are the feature variables(mean and std of the whole feature variables).
  * The last column is refers to the activity (with descriptive labels) that the subjects were doing.
- `full_data_means` (can be found as `tidy_dataset.txt` on this github repo) is the tidy data produced after going through all 5 steps of the course project. It contains 180 observations and 81 variables. Where the first column is the subject id, second column is the activity and the rest are the average of each feature variables. 
