---
title: "CodeBook for Getting and Cleaning Data"
author: "Frederick Burkley"
date: "09/27/2015"
output: html_document
---

This is a Code Book for the course "Getting and Cleaning Data.


### Project Description
This project analyzed data from a study on [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).  This study, and many others, is archived and publically available via the University of California, Irvine [Center for Machine Learning and Intelligent Systems](http://cml.ics.uci.edu/).

Commercial companies, such as Nike, are developing big data analytics to perform [Pattern-of-life analysis](https://en.wikipedia.org/wiki/Pattern-of-life_analysis) based on consumer activity.  This study is one such example.

***
***

### Data

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Additional information on the data is available [here](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.names).

***
***

### Variables

The tidy data set includes both *time domain* and *frequency domain* variables.  Time domain variables, prefixed with a "t", are either measurements or derived from measurements taken "in real time".  This is the most natural way to think about measuring "real world events".  Frequency domain variables, prefixed with a "f" are the result of *Digital Signal Processing* signal techniques.

The following variables appear in the tidy data set:

#### Variables added (i.e. do not appear in the raw data set)

1. Subject, The subject identifier, range 1 to 30 inclusive.
2. Activity, The activity, one of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

#### Variables that are included from the raw data set

3. tBodyAccmeanX, tBodyAccmeanY, tBodyAccmeanZ, tBodyAccstdX, tBodyAccstdY, tBodyAccstdZ, tGravityAccmeanX,tGravityAccmeanY, tGravityAccmeanZ, tGravityAccstdX, tGravityAccstdY, tGravityAccstdZ, tBodyAccJerkmeanX, tBodyAccJerkmeanY, tBodyAccJerkmeanZ, tBodyAccJerkstdX, tBodyAccJerkstdY, tBodyAccJerkstdZ, tBodyGyromeanX, tBodyGyromeanY, tBodyGyromeanZ, tBodyGyrostdX, tBodyGyrostdY, tBodyGyrostdZ, tBodyGyroJerkmeanX, tBodyGyroJerkmeanY, tBodyGyroJerkmeanZ, tBodyGyroJerkstdX, tBodyGyroJerkstdY, tBodyGyroJerkstdZ, tBodyAccMagmean, tBodyAccMagstd, tGravityAccMagmean, tGravityAccMagstd, tBodyAccJerkMagmean, tBodyAccJerkMagstd, tBodyGyroMagmean, tBodyGyroMagstd, tBodyGyroJerkMagmean, tBodyGyroJerkMagstd, fBodyAccmeanX, fBodyAccmeanY, fBodyAccmeanZ, fBodyAccstdX, fBodyAccstdY, fBodyAccstdZ, fBodyAccmeanFreqX, fBodyAccmeanFreqY, fBodyAccmeanFreqZ, fBodyAccJerkmeanX, fBodyAccJerkmeanY, fBodyAccJerkmeanZ, fBodyAccJerkstdX, fBodyAccJerkstdY, fBodyAccJerkstdZ, fBodyAccJerkmeanFreqX, fBodyAccJerkmeanFreqY, fBodyAccJerkmeanFreqZ, fBodyGyromeanX, fBodyGyromeanY, fBodyGyromeanZ, fBodyGyrostdX, fBodyGyrostdY, fBodyGyrostdZ, fBodyGyromeanFreqX, fBodyGyromeanFreqY, fBodyGyromeanFreqZ, fBodyAccMagmean, fBodyAccMagstd, fBodyAccMagmeanFreq, fBodyBodyAccJerkMagmean, fBodyBodyAccJerkMagstd, fBodyBodyAccJerkMagmeanFreq, fBodyBodyGyroMagmean, fBodyBodyGyroMagstd, fBodyBodyGyroMagmeanFreq, fBodyBodyGyroJerkMagmean, fBodyBodyGyroJerkMagstd, fBodyBodyGyroJerkMagmeanFreq


#### Variables that are not included from the raw data set

4. angle(tBodyAccMean,gravity), angle(tBodyAccJerkMean),gravityMean), angle(tBodyGyroMean,gravityMean), angle(tBodyGyroJerkMean,gravityMean), angle(X,gravityMean), angle(Y,gravityMean), angle(Z,gravityMean)

Rationale (for exclusion): Not directly related to a raw measurement.

***
***

### Transformations

The following transformations were performed on the raw data set:

1. Preparation of features
 - Remove all parentheses, both left '(' and right ')', from the features.
 - Remove all dashes '-' from the features.
 - Remove all commas ',' from the features.

2. Preparation of activity labels
 - The numeric codes from the activities are replaced with labels that are defined in the activity labels file.

3. The prepared features are used to name the variables of the tidy data set.

4. Unwanted variables are pruned from the tidy data set.  Varialbes that represent mean and standard deviation values are retained.

5. The the subjects, activity labels, and data are combined (in that order) to create a tidy data set from the (raw) data set.


***
***

###Sources
[1] CodeBook template from Joris Schut: https://gist.github.com/JorisSchut/dbc1fc0402f28cad9b41#file-gistfile1-rmd

[2] Human Activity Recognition Using Smartphones study: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones



