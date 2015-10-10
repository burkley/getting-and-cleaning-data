#
# Author:  Frederick Burkley
# File:    run_analysis.R
# Purpose: Prepare tidy data that can be used for later analysis.
#


##
## Function run_analysis
##
## This is a convenience function to execute the script.
##
## To run: tidy_data <- run_analysis()
## 
## This function expects that the data from the project zip file "getdata_projectfiles_UCI HAR Dataset.zip" is extracted in
## its default location, that is, a folder named "UCI HAR Dataset", and that the files exist within the folder in their
## default location.
##
run_analysis <- function() {
        # download the data if necessary
        util_check_for_data(verbose=TRUE)

        # call do_run_analysis to do the actual work.
        # designing the program this way (by passing the names of the data files into do_run_analysis)
        # allows flexibility if the data files are not in their standard location.
        tidy_data <- do_run_analysis(
                activity_labels_filename="UCI HAR Dataset/activity_labels.txt",
                features_filename       ="UCI HAR Dataset/features.txt",
                test_subjects_filename  ="UCI HAR Dataset/test/subject_test.txt",
                test_data_filename      ="UCI HAR Dataset/test/X_test.txt",
                test_activity_filename  ="UCI HAR Dataset/test/y_test.txt",
                train_subjects_filename ="UCI HAR Dataset/train/subject_train.txt",
                train_data_filename     ="UCI HAR Dataset/train/X_train.txt",
                train_activity_filename ="UCI HAR Dataset/train/y_train.txt",
                output_filename         ="tidy_data.txt",
                view_data               =FALSE,
                verbose                 =TRUE)
}


##
## Function do_run_analysis
##
## This function directs the actual work of cleaning the data.  It is possible to call this function directly
## (from RStudio for example) if so desired.
##
## Arguments
##   activity_labels_filename    Links the class labels with their activity name.
##   features_filename           List of all features.
##   test_subjects_filename      Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
##   test_data_filename          Test set.
##   test_activity_filename      Activity labels for the Test data set.
##   train_subjects_filename     Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
##   train_data_filename         Training set.
##   train_activity_filename     Activity labels for the Training data set.
##   output_filename             The name of the tidy output file.
##   view_data                   To view data frames created while the program is running.
##   verbose                     Verbose mode.
##
do_run_analysis <- function(activity_labels_filename,
                         features_filename,
                         test_subjects_filename,
                         test_data_filename,
                         test_activity_filename,
                         train_subjects_filename,
                         train_data_filename,
                         train_activity_filename,
                         output_filename=NULL,
                         view_data=FALSE,
                         verbose=FALSE) {
        # prepare (i.e. clean) the test data set
        if(verbose) {print("Processing test data")}
        test_data <- util_prepare_raw_data_set_for_merge(activity_labels_filename,
                                                    features_filename,
                                                    test_subjects_filename,
                                                    test_data_filename,
                                                    test_activity_filename,
                                                    view_data=FALSE,
                                                    verbose=FALSE)
        # prepare (i.e. clean) the training data set
        if(verbose) {print("Processing training data")}
        train_data <- util_prepare_raw_data_set_for_merge(activity_labels_filename,
                                                     features_filename,
                                                     train_subjects_filename,
                                                     train_data_filename,
                                                     train_activity_filename,
                                                     view_data,
                                                     verbose=FALSE)
        if(view_data) {
                View(test_data)
                View(train_data)
        }

        # merge the test and training date sets
        if(verbose) {print("Merging data")}
        merged_data <- rbind(test_data, train_data)

        if(view_data) {
                if(verbose) {print("Viewing data")}
                View(merged_data)
        }

        # create the tidy data set
        if(verbose) {print("Creating tidy data set")}
        tidy_data <- plyr::ddply(merged_data,
                                 plyr::.(Subject, Activity),
                                 plyr::numcolwise(mean))
        #tidy_data <- group_by(merged_data, Subject, Activity) %>% summarize_each(funs(mean))

        # serialize the tidy data set to the file system
        if(!is.null(output_filename)) {
                if(verbose) {print("Serializing tidy data set")}
                write.table(tidy_data, output_filename, sep=",")
        }

        if(verbose) {print("Processing complete")}
        tidy_data
}



###
### The rest of the functions in this file are utility functions that support the
### work done in do_run_analysis or other utility functions defined in this script.
###



##
## Function util_prepare_raw_data_set_for_merge
##
## This function does the actual work of cleaning the data.  The steps performed are:
##   1) Read all pertinent files (data, subjects, features, activities, etc.)
##   2) Prepare the features.  The features are used for the variable names in the tidy data set.
##   3) Prepare the activity labels.  The activity labels are added as a variable in the tidy data set.
##   4) Use the features to name the variables of the tidy data set.
##   5) Prune unwanted variables from the tidy data set.  We want the variables that represent the mean and standard deviation of the data set.
##   6) Combine the subjects, activity labels, and data (in that order) to create a tidy data set from the (raw) data set.
##
## Arguments
##   activity_labels_filename    Links the class labels with their activity name.
##   features_filename           List of all features.
##   subjects_filename           Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
##   data_filename               The data set.
##   activity_filename           Activity labels for the data set.
##   view_data                   To view data frames created while the program is running.
##   verbose                     Verbose mode.
##
util_prepare_raw_data_set_for_merge <- function(activity_labels_filename,
                                                features_filename,
                                                subjects_filename,
                                                data_filename,
                                                activity_filename,
                                                view_data=FALSE,
                                                verbose=FALSE) {
        # read the subjects file
        subjects <- read.table(subjects_filename, header=FALSE)
        # read the data file.  This is the file that contains the actual data
        data <- read.table(data_filename, header=FALSE)
        
        # prepare the features and activities
        features <- util_prepare_features(features_filename)
        activity <- util_prepare_activity(activity_labels_filename,
                                          activity_filename,
                                          view_data,
                                          verbose)
        if(verbose) {print(features)}
        
        # name the variables of the dataframes.
        colnames(subjects) <- c("Subject")
        colnames(data) <- features
        colnames(activity) <- c("Activity")
        
        # prune the variables that are not mean or std        
        data <- data[ ,
                     sort(
                             c(grep("mean", names(data), ignore.case=FALSE),
                               grep("std", names(data), ignore.case=FALSE)
                               )
                         )
                    ]

        # now column bind the subjects, activity, and data into one dataframe
        data <- cbind(cbind(subjects, activity), data)
        # view the data frames
        if(view_data) {
                View(subjects)
                View(data)
                View(activity)
        }
        data
}


##
## Function util_prepare_features
##
## This function prepares the variable names (i.e. features) that are used to create the tidy data set.
##
## The following steps are performed to prepare the varialbe names:
##   1) Remove all parentheses, both left '(' and right ')', from the features.
##   2) Remove all dashes '-' from the features.
##   3) Remove all commas ',' from the features.
##
## Arguments
##   features_filename           List of all features.
##
util_prepare_features <- function(features_filename) {
        # Read the features file
        features <- read.table(features_filename, header=FALSE)
        # Delete the first column
        features <- dplyr::select(features, -V1)
        features_as_chars <- sapply(features, as.character)
        features_as_chars <- gsub("\\(", "", features_as_chars)
        features_as_chars <- gsub("\\)", "", features_as_chars)
        features_as_chars <- gsub("-", "", features_as_chars)
        features_as_chars <- gsub(",", "", features_as_chars)
}


##
## Function util_prepare_activity
##
## This function reads the activity file and replaces the numeric codes with the
## appropriate activity labels.  The mapping between the numeric codes and the
## labels is defined by the activity labels file.
##
## Arguments
##   activity_labels_filename    Links the class labels with their activity name.
##   activity_filename           Activity labels for the data set.
##   view_data                   To view data frames created while the program is running.
##   verbose                     Verbose mode.
##
util_prepare_activity <- function(activity_labels_filename,
                                  activity_filename,
                                  view_data=FALSE,
                                  verbose=FALSE) {
        # read the activity labels file
        activity_labels <- read.table(activity_labels_filename, header=FALSE)
        # read the activity file
        activity <- read.table(activity_filename, header=FALSE)
        if(verbose) {print(sapply(activity, class))}
        activity$V1 <- activity_labels$V2[activity$V1]
        if(view_data) {
                View(activity_labels)
                View(activity)
        }
        activity
}

##
## Function util_check_for_data
##
## This 
util_check_for_data <- function(verbose=FALSE) {
        data_dir <- "data"
        if(!file.exists("data")) {
                if(verbose) {print("Creating directory")}
                dir.create("data")
        }
        zip_file <- "data/UCI HAR Dataset.zip"
        if(!file.exists(zip_file)) {
                if (verbose) {print("Downloading data file")}
                file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                download.file(file_url, destfile=zip_file, method="curl")
        }
        # unzip the project data in the current working directory
        project_data <- "UCI HAR Dataset"
        if(!file.exists(project_data)) {
                if (verbose) {print("Unzipping data")}
                unzip(zip_file)
        }
}
