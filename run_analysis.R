setwd("~/Desktop")
Data <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","./data/project.zip",method = "curl")
project <- unzip("./data/project.zip")
## read training set, labels and subjects
trset <- read.table("./UCI HAR Dataset/train/X_train.txt")
trlabels <- read.table("./UCI HAR Dataset/train/Y_train.txt")
trsubjects <- read.table("./UCI HAR Dataset/train/Subject_train.txt")
## read test set, labels and subjects
teset <- read.table("./UCI HAR Dataset/test/X_test.txt")
telabels <- read.table("./UCI HAR Dataset/test/Y_test.txt")
tesubjects <- read.table("./UCI HAR Dataset/test/Subject_test.txt")


## features
features <- read.table("./UCI HAR Dataset/features.txt")
colnames(features) <- c("index","featurenames")

## activities labels
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
## column names activity
colnames(activity) <- c("activity_id","activity_label")

## 1. merge test and train data
set <- rbind(trset,teset)
labels <- rbind(trlabels,telabels)
subjects <- rbind(trsubjects,tesubjects)

## 2.extract only the measurements of mean and standard deviation for each measurement
keepcolumn <- features[grep("(mean|std)\\(\\)",features[,2]),]
set <- set[,keepcolumn[,1]]

## 3.name the activities
colnames(labels) <- "activity"
labels[,1] <- activity[labels[,1],2]


## 4.Appropriately labels the data set with descriptive variable names
colnames(set) <- features[keepcolumn[,1],2]

## 5.tidy data
library(plyr)
colnames(subjects) <- "subject"
merge <- cbind(set,labels,subjects)
averages_data <- merge %>% group_by(activity, subject) %>% summarize_all(funs(mean))
write.table(averages_data, "tidy_data.txt", row.name=FALSE)
