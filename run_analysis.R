## the UCI HAR dataset has been downloaded and unzipped

library(dplyr)
library(plyr)
library(data.table)
## Load dataset
test_x <- read.table("UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
train_x <- read.table("UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
activity <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

## Append test data to train data
x <- rbind(train_x,test_x)
y <- rbind(train_y,test_y)
subject <- rbind(train_subject,test_subject)

## Keep only mean and std measurements 
mean_std_position <- grep("-(mean|std)\\(\\)", features[,2])
x_mean_std <- x[,mean_std_position]

## Add activity code description to table y
y[,1] <- activity[y[,1],2]

## Combine all data (subject, y and x_mean_std)
data_for_study <- cbind(subject,y,x_mean_std)

## Add/Update variable names
names(data_for_study) <- c("subject", "actDesp",as.vector(features[mean_std_position,2]))

## Avg for each activity and each subject
avg_data <- ddply(data_for_study,.(subject,actDesp), colwise(mean))
## Output table
write.table(avg_data,"avg_data.txt",row.name=FALSE)
