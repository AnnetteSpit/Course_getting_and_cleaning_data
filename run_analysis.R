## ----- 0. Document Settup ----- 

# install.packages(pacman)
library(pacman)
## Use the pacman library to load packages, 
##    it automatically installs tha package if you do not have it installed yet
p_load(dplyr)

## Set working dir
directory <- "//wp.sdc-gsa.intra/Home/spithoa/Documents/Cursus/Data scientist specialization/UCI HAR Dataset"
setwd(directory)

## Load features and activities data
features <- read.table("features.txt", col.names = c("n","functions"))
activities <- read.table("activity_labels.txt", col.names = c("code", "activity"))
## loading test data
subject_test <- read.table("./test/subject_test.txt", col.names = "subject")
x_test <- read.table("./test/X_test.txt", col.names = features$functions)
y_test <- read.table("./test/y_test.txt", col.names = "code")
## loading trianing data
subject_train <- read.table("./train/subject_train.txt", col.names = "subject")
x_train <- read.table("./train/X_train.txt", col.names = features$functions)
y_train <- read.table("./train/y_train.txt", col.names = "code")

## clean the environment

## ----- 1. Merge the training and the test sets to create one data set. ----- 
training_data <- cbind(subject_train, y_train, x_train)
test_data <- cbind(subject_test, y_test, x_test)

full_data <- rbind(training_data,test_data)

## clean the environment
rm(training_data, test_data, subject_train,
   x_train, y_train, subject_test, y_test, x_test)


## ----- 2. Extracts only the measurements on the mean and standard deviation for each measurement.  ----- 

## Create a vector containing the column names that we want to keep
columns_to_keep <- colnames(full_data)[which(grepl("subject|code|mean|std", colnames(full_data)))]

## Use the vector in a dplyr pipeline to select the columns we want to keep
full_data <- full_data %>% 
  select(!!columns_to_keep)

## clean the environment
rm(columns_to_keep)

## ----- 3. Uses descriptive activity names to name the activities in the data set ----

full_data <- full_data %>% 
  ## Add the activities descriptive
  left_join(activities, by = "code") %>% 
  ## Variable/column "code" now is redudant, so remove that
  select(-code) 

## ----- 4. Appropriately labels the data set with descriptive variable names. ----- 
## This was already partly done when loading the data
## However, I am not sure whether the used names (especially from the
## features file) are clear to understand for everyone. Therefore,
## I tried my best to expand the names so that everyone knows what type of 
## data is in the column.

## Get the column names
new_colnames <- colnames(full_data)

## Correct something that looks like a typo
new_colnames <- gsub("BodyBody", "Body", new_colnames)

## Remove excessive dots
new_colnames <- gsub("\\.\\.", "", new_colnames)

## Expand abbreviations and clean up names
new_colnames <- gsub("Acc", "Accelerometer_", new_colnames)
new_colnames <- gsub("Gyro", "Gyroscope_", new_colnames)
new_colnames <- gsub("Mag", "Magnitude_", new_colnames)
new_colnames <- gsub("Freq", "Frequency_", new_colnames)
new_colnames <- gsub("mean", "Mean", new_colnames)
new_colnames <- gsub("std", "StandardDeviation", new_colnames)
new_colnames <- gsub("^f", "FrequencyDomain_", new_colnames)
new_colnames <- gsub("^t", "TimeDomain_", new_colnames)
new_colnames <- gsub("Body", "Body_", new_colnames)
new_colnames <- gsub("Gravity", "Gravity_", new_colnames)

## correct the special characters
new_colnames <- gsub("\\_\\.|\\.", "\\_", new_colnames)
new_colnames <- gsub("MeanFrequency_$", "Mean_Frequency", new_colnames)

## use new labels as column names
colnames(full_data) <- new_colnames

## ----- 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. -----
full_data_means <- full_data %>% 
  group_by(subject, activity) %>%
  summarise_each(list(~mean(.,na.rm = TRUE)))

write.table(full_data_means, "tidy_dataset.txt", row.names = FALSE)