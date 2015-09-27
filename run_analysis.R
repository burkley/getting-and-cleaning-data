
##
##
##
run_analysis <- function(activity_labels_filename,
                         features_filename,
                         test_subjects_filename,
                         test_data_filename,
                         test_activity_filename,
                         train_subjects_filename,
                         train_data_filename,
                         train_activity_filename,
                         view_data=FALSE,
                         verbose=FALSE) {
        if(verbose) {print("Processing test data")}
        test_data <- prepare_raw_data_set_for_merge(activity_labels_filename,
                                                    features_filename,
                                                    test_subjects_filename,
                                                    test_data_filename,
                                                    test_activity_filename,
                                                    view_data=FALSE,
                                                    verbose=FALSE)
        if(verbose) {print("Processing training data")}
        train_data <- prepare_raw_data_set_for_merge(activity_labels_filename,
                                                     features_filename,
                                                     train_subjects_filename,
                                                     train_data_filename,
                                                     train_activity_filename,
                                                     view_data=FALSE,
                                                     verbose=FALSE)
        if(view_data) {
                View(test_data)
                View(train_data)
        }
        if(verbose) {print("Merging data")}
        merged_data <- rbind(test_data, train_data)

        if(view_data) {
                if(verbose) {print("Viewing data")}
                View(merged_data)
        }
        if(verbose) {print("Processing complete")}
        
        tidy_data <- plyr::ddply(merged_data,
                                 plyr::.(Subject, Activity),
                                 plyr::numcolwise(mean))
        #tidy_data <- group_by(merged_data, Subject, Activity) %>% summarize_each(funs(mean))
}


##
##
##
prepare_raw_data_set_for_merge <- function(activity_labels_filename,
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
        
        features <- prepare_features(features_filename)
        activity <- prepare_activity(activity_labels_filename,
                                     activity_filename,
                                     view_data=FALSE,
                                     verbose)
        if(verbose) {
                print(features)
        }
        
        # name the columns some of the dataframes.
        # ultimately want column names for the data dataframe
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
##
##
prepare_features <- function(filename) {
        # Read the features file
        features <- read.table(filename, header=FALSE)
        # Delete the first column
        features <- dplyr::select(features, -V1)
        features_as_chars <- sapply(features, as.character)
        features_as_chars <- gsub("\\(\\)", "", features_as_chars)
        features_as_chars <- gsub("\\(", "_", features_as_chars)
        features_as_chars <- gsub("\\)", "_", features_as_chars)
        features_as_chars <- gsub("-", "", features_as_chars)
        features_as_chars <- gsub(",", "", features_as_chars)
}

##
##
##
prepare_activity <- function(activity_labels_filename,
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
##
##
util_summarize_subject_numbers <- function(filename) {
        subjects <- read.table(filename, header=FALSE)
        #View(subjects)
        #print(sapply(subjects, class))
        subjects_unique <- unique(subjects)
}