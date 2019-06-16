---
title: "gcd_assignment"
author: "DanKrasner"
date: "6/13/2019"
output: 
  html_document: 
    keep_md: yes
---



##Downloading and extracting data


```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
library(magrittr)
filename <- "activity.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists(filename)){
        download.file(url, filename)   
}
if(!file.exists("UCI HAR Dataset")){
        unzip(filename)
}
```

##Reading data and assigning the descriptive names to the variables


```r
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity")
```

##Merging train and test data


```r
subject <- rbind(subject_train, subject_test)
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
# extract descriptive activity factor value
get_activity <- function(code){
        activity <- activities[which(activities$code == code),2]
        return (activity)
}
y$activity %<>% sapply(get_activity) 
activity_df <- cbind(subject, y, x)
```

##Converting activity_code variable to descriptive activity factor variable


##Extracting the measurements on the mean and standard deviation for each measurment


```r
activity_df %<>% select(subject, activity, contains('.mean'), contains('.std'), -contains('meanFreq'))
names(activity_df)
```

```
##  [1] "subject"                     "activity"                   
##  [3] "tBodyAcc.mean...X"           "tBodyAcc.mean...Y"          
##  [5] "tBodyAcc.mean...Z"           "tGravityAcc.mean...X"       
##  [7] "tGravityAcc.mean...Y"        "tGravityAcc.mean...Z"       
##  [9] "tBodyAccJerk.mean...X"       "tBodyAccJerk.mean...Y"      
## [11] "tBodyAccJerk.mean...Z"       "tBodyGyro.mean...X"         
## [13] "tBodyGyro.mean...Y"          "tBodyGyro.mean...Z"         
## [15] "tBodyGyroJerk.mean...X"      "tBodyGyroJerk.mean...Y"     
## [17] "tBodyGyroJerk.mean...Z"      "tBodyAccMag.mean.."         
## [19] "tGravityAccMag.mean.."       "tBodyAccJerkMag.mean.."     
## [21] "tBodyGyroMag.mean.."         "tBodyGyroJerkMag.mean.."    
## [23] "fBodyAcc.mean...X"           "fBodyAcc.mean...Y"          
## [25] "fBodyAcc.mean...Z"           "fBodyAccJerk.mean...X"      
## [27] "fBodyAccJerk.mean...Y"       "fBodyAccJerk.mean...Z"      
## [29] "fBodyGyro.mean...X"          "fBodyGyro.mean...Y"         
## [31] "fBodyGyro.mean...Z"          "fBodyAccMag.mean.."         
## [33] "fBodyBodyAccJerkMag.mean.."  "fBodyBodyGyroMag.mean.."    
## [35] "fBodyBodyGyroJerkMag.mean.." "tBodyAcc.std...X"           
## [37] "tBodyAcc.std...Y"            "tBodyAcc.std...Z"           
## [39] "tGravityAcc.std...X"         "tGravityAcc.std...Y"        
## [41] "tGravityAcc.std...Z"         "tBodyAccJerk.std...X"       
## [43] "tBodyAccJerk.std...Y"        "tBodyAccJerk.std...Z"       
## [45] "tBodyGyro.std...X"           "tBodyGyro.std...Y"          
## [47] "tBodyGyro.std...Z"           "tBodyGyroJerk.std...X"      
## [49] "tBodyGyroJerk.std...Y"       "tBodyGyroJerk.std...Z"      
## [51] "tBodyAccMag.std.."           "tGravityAccMag.std.."       
## [53] "tBodyAccJerkMag.std.."       "tBodyGyroMag.std.."         
## [55] "tBodyGyroJerkMag.std.."      "fBodyAcc.std...X"           
## [57] "fBodyAcc.std...Y"            "fBodyAcc.std...Z"           
## [59] "fBodyAccJerk.std...X"        "fBodyAccJerk.std...Y"       
## [61] "fBodyAccJerk.std...Z"        "fBodyGyro.std...X"          
## [63] "fBodyGyro.std...Y"           "fBodyGyro.std...Z"          
## [65] "fBodyAccMag.std.."           "fBodyBodyAccJerkMag.std.."  
## [67] "fBodyBodyGyroMag.std.."      "fBodyBodyGyroJerkMag.std.."
```
##Creating descriptive variable names


```r
substitution_pairs <- list(
        c('Acc','accelerometer'),
        c('Gyro', 'gyroscope'),
        c('^t', 'time'),
        c('Body', 'body'),
        c('Gravity', 'gravity'),
        c('-XYZ', '3axial'),
        c('Jerk', 'jerk'), 
        c('^f', 'frequency'),
        c('Mag', 'magnitude'),
        c('std', 'standarddeviation'),
        c('\\.', ''),
        c('()', '')
)
for (pair in substitution_pairs){
        #print(pair)
        names(activity_df) <- gsub(pair[1], pair[2], names(activity_df))
}
names(activity_df)[1:10]
```

```
##  [1] "subject"                        "activity"                      
##  [3] "timebodyaccelerometermeanX"     "timebodyaccelerometermeanY"    
##  [5] "timebodyaccelerometermeanZ"     "timegravityaccelerometermeanX" 
##  [7] "timegravityaccelerometermeanY"  "timegravityaccelerometermeanZ" 
##  [9] "timebodyaccelerometerjerkmeanX" "timebodyaccelerometerjerkmeanY"
```


```r
tidy_df <- activity_df %>% group_by(subject, activity) %>% summarize_each(list(mean))
dim(tidy_df)
```

```
## [1] 180  68
```

#save tidy data set as a file

```r
write.table(tidy_df, "tidy_data.txt", sep = ',', row.names = FALSE)
```
