library(dplyr)

## Read in the test datasets
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

## Read in the table datasets
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Read activity labels
act_lab <- read.table("UCI HAR Dataset/activity_labels.txt")

##Read in features
features <- read.table("UCI HAR Dataset/features.txt")

##Merge data
x <- rbind(x_train,x_test)
y <- rbind(y_train,y_test)
sub <- rbind(sub_train,sub_test)

## Use to select mean and std
meas <- features[grep("mean|std",features[,2]),]

## Select just mean and std
x_ms <- x[,meas[,1]]

## Name y column
colnames(y) <- "activity"

## Add the activity name
y$act_lab <- factor(y$activity, labels = as.character(act_lab[,2]))

## Give x_ms column names
colnames(x_ms) <- features[meas[,1],2]

## Name sub column
colnames(sub) <- "subject"

##Combining into one
activity_label <- y[,-1]
data <- cbind(x_ms, activity_label, sub)

## Group data
data2 <- group_by(data, activity_label, subject)
tidydata <- summarise_each(data2, funs(mean))

## Write to file
write.table(tidydata, file = "UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
