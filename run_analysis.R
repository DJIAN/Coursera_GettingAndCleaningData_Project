# Getting and Cleaning Data Project
# 14/01/2015 16:15
# F. DJIAN
# Execution instructions :
# 1 - On windows my usb storage G:\
# 2 - Working dir : G://Coursera_GettingAndCleaningData/Project
# 3 - Dezip the file UCI HAR Dataset in this dir ...
# 4 - run setwd("G://Coursera_GettingAndCleaningData/Project") command before launching source
# 5 - source("run_analysis.R", echo=T)


# Cleaning memory
rm(list=ls(all=TRUE))

# Loading "data.table" package :
library (data.table)


# Loading "data.table" package :
GeneralPath <- "G://Coursera_GettingAndCleaningData/Project/UCI HAR Dataset"
setwd(GeneralPath)

# Load activity_labels.txt file :
activity_labels <- read.table("activity_labels.txt")[,2]

# Load features.txt file :
features <- read.table("features.txt")[,2]

# Only mean and Standard deviation
extract_features <- grepl("mean|std", features)

# Tests data
X_test <- read.table("./test/X_test.txt")
Y_test <- read.table("./test/y_test.txt")

subject_test <- read.table("./test/subject_test.txt")

names(X_test) = features

# Mean and std dev 
X_test = X_test[,extract_features]

Y_test[,2] = activity_labels[Y_test[,1]]

names(Y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

test_data <- cbind(as.data.table(subject_test), Y_test, X_test)

setwd(GeneralPath)

# Idem with train data :
X_train <- read.table("./train/X_train.txt")
Y_train <- read.table("./train/y_train.txt")

subject_train <- read.table("./train/subject_train.txt")

names(X_train) = features

# Extract mean and std dev :
X_train = X_train[,extract_features]

# Load activity data
Y_train[,2] = activity_labels[Y_train[,1]]
names(Y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

train_data <- cbind(as.data.table(subject_train), Y_train, X_train)

# Merging data :
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Final dataset :
final_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

# Write the data 
write.table(final_data, file = "G://Coursera_GettingAndCleaningData/Project/final_data_with_names.txt" ,row.name=TRUE )
write.table(final_data, file = "G://Coursera_GettingAndCleaningData/Project/final_data_without_names.txt" , row.name=FALSE)

# Verify that the file is produced :

#if ( file.exists("final_data.txt") ) {
#  print ("File final_data.txt as been produced") }
#  else {
#  print ("File final_data.txt as been produced") 
#}



