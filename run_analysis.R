
#downloading and extracting data

library(dplyr)
library(magrittr)
filename <- "activity.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists(filename)){
        download.file(url, filename)   
}
if(!file.exists("UCI HAR Dataset")){
        unzip(filename)
}

#reading data and assigning the descriptive names to the variables

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity")

#merging train and test data

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

#extracting the measurements on the mean and standard deviation for each measurment

activity_df %<>% select(subject, activity, contains('.mean'), contains('.std'), -contains('meanFreq'))
names(activity_df)[1:10]

#creating descriptive variable names

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

#creating tidy data set with variable means for every object-activity pair
tidy_df <- activity_df %>% group_by(subject, activity) %>% summarize_each(list(mean))
dim(tidy_df)

#save tidy data set as a file
write.table(tidy_df, "tidy_data.txt", sep = ',', row.names = FALSE)
