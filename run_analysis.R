
# Instructions to the assignment are highlighted below:
  # 1. Merge training and test sets to create one data set
  # 2. Extract only the mean and standard deviation measurements
  # 3. Extract only the mean and standard deviation measurements
  # 4. Label data set with descriptive variable names
  # 5. From the outcome of 4, create an independent data saet with average of each variabe for each activity and subject

############################################################

# First dplyr packages needs to be installed, if not already & library needs to be called
install.packages("dplyr")
library(dplyr)

# Data needs to be downloaded from the website, and since zipped, needs to be unzipped
  # Contains various text files and folders with test and train data

# Read in data from the train data folder
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
Sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
Sub_train

# Read in data from the read test data folder
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
Sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
Sub_test

# Read in data description
variable_names <- read.table("./UCI HAR Dataset/features.txt")
variable_names

#Read activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_labels
##################################################################

# 1. Here the training and test datasets are merged into one data set.
X_total <- rbind(X_train, X_test)
Y_total <- rbind(Y_train, Y_test)
Sub_total <- rbind(Sub_train, Sub_test)
Sub_total

head(Sub_total)
str(Sub_total)

# 2. Here the mean and standard deviations are extracted for each measurement.
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
X_total <- X_total[,selected_var[,1]]
X_total
head(X_total)

# 3. Here descriptive  activity names to name the activities in the data set
colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]
activitylabel

# 4. Appropriately labels the data set with descriptive variable names.
colnames(X_total) <- variable_names[selected_var[,1],2]


# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(Sub_total) <- "subject"
total <- cbind(X_total, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)

