# getting-and-cleaning-data
Repository for Coursera Getting and Cleaning Data course.

### To create the tidy data set

1. All code necessary to create a tidy data set from the (raw) data set *UCI HAR Dataset* is contained in the file **run_analysis.R**

To run:

* tidy_data <- run_analysis()

This function expects that the data from the project zip file "getdata_projectfiles_UCI HAR Dataset.zip" is extracted in its default location, that is, a folder named "UCI HAR Dataset", and that the raw data files exist within the folder in their  default location.

### To read back the tidy data set

2. This function writes a tidy data set as a Comma Separated File (CSV) as output.  The default name of the output CVS file (i.e. the tiday data set) is **tidy_data.txt**.

To read the tidy data set using R:

* tidy_data <- read.table("tidy_data.txt", header=TRUE, sep=",")

### Additional flexibility

This file provides a flexible mechanism in case the raw data files are not in their default location as described in (1).

A function called *do_run_analysis()* takes arguments such that the names and locations of the raw data files can be specified.

* From the documentation for the function do_run_analysis():

 -- This function directs the actual work of cleaning the data.  It is possible to call this function directly (from RStudio for example) if so desired.

See the function definition in **run_analysis.R** for more information.


