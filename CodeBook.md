---
title: "CodeBook"
date: "6/14/2019"
output: 
  html_document: 
    keep_md: yes
---

## Original Data Source
 - [data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
 - [description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
 
The description of original data is in 'UCI HAR Dataset/README.txt' and in 'UCI HAR Dataset/features_info.txt'. 

## Data Preprocessing
#### The original data were processed as the following:
 - relevant data were extracted and downloaded
 - train and test data were merged into one dataset
 - for each measurment were extracted the measurement of mean and standard deviation
 - for each obtained variable an original ambiguous name was replaced with descriptive variable name
 - for each object-activity combination was calculated the mean value of each variable and assigned as a value of the relevant variable for the relevant row.
 - obtained dataframe was saved as text file 'tidy_df.txt'
 
## Variable Description
#### Obtained data set 'tidy_df.txt' containes the following variables:
 * 'object', indicating one of 30 volunteers, participating in the research
 * 'activity', indicating one of the 6 activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
 * 66 variables, obtained as a result of the data processing, described earlier in **Data Preprocessing** section
