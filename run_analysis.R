#
#
# Getting and Cleaning Data
# Course project
# jptanguay
# 2014-11-22
#
#

######################## 
## CONFIGURATION
######################## 

## SET this path to the working directory prior to running the script
setwd( "getting_data\\project")

## set the data_folder  
data_folder <- ".\\data\\UCI HAR Dataset"

######################## 
## END OF CONFIGURATION
######################## 





## define file names relative to paths defined in the configuration section above
labels_filename <- paste(data_folder, "activity_labels.txt", sep="\\")

features_filename <- paste(data_folder, "features.txt", sep="\\")

subject_train_filename <- paste(data_folder, "train", "subject_train.txt", sep="\\")
x_train_filename <- paste(data_folder, "train", "X_train.txt", sep="\\")
y_train_filename <- paste(data_folder, "train", "y_train.txt", sep="\\")

subject_test_filename <- paste(data_folder, "test", "subject_test.txt", sep="\\")
x_test_filename <- paste(data_folder, "test", "X_test.txt", sep="\\")
y_test_filename <- paste(data_folder, "test", "y_test.txt", sep="\\")

result_df_filename <- paste(data_folder, "result_df.txt", sep="\\")


## load raw data
activity_labels <- read.csv(labels_filename, header=FALSE, sep = " ")
features <- read.csv(features_filename, header=FALSE, sep = " ")

subject_train <- read.csv(subject_train_filename, header=FALSE, sep = " ")
x_train <- read.csv(x_train_filename, header=FALSE, sep = "")
y_train <- read.csv(y_train_filename, header=FALSE, sep = "")

subject_test <- read.csv(subject_test_filename, header=FALSE, sep = " ")
x_test <- read.csv(x_test_filename, header=FALSE, sep = "")
y_test <- read.csv(y_test_filename, header=FALSE, sep = "")


## rename columns 
colnames(activity_labels) <- c("activity_id", "activity_name")
colnames(features) <- c("feature_id", "feature_name")

colnames(subject_train) <- "subject_id"
colnames(y_train) <- "activity_id"

colnames(subject_test) <- "subject_id"
colnames(y_test) <- "activity_id"


## merge y_train values with activity_labels, so we have the activity label on each row later in the final dataset
## gives names to x_train columns
## prepend the subject_id to x_train, and append activity_id, activity_name to x_train to form the full train dataset
## rename the subject_id column for convenience, because the cbind made it longer (subject_train$subject_id)
y_train <- merge(y_train, activity_labels, by="activity_id")
colnames(x_train) <- features$feature_name
full_train_set <- cbind(subject_train$subject_id, x_train, y_train)
colnames(full_train_set)[1] <- "subject_id"

## do the same with the test dataset
y_test <- merge(y_test, activity_labels, by="activity_id")
colnames(x_test) <- features$feature_name
full_test_set <- cbind(subject_test$subject_id, x_test, y_test)
colnames(full_test_set)[1] <- "subject_id"


## row bind the training and test datasets 
## N.B. the instructions on the page "https://class.coursera.org/getdata-009/human_grading/view/courses/972587/assessments/3/submissions"
## says that the run_analysis.R script "Merges the training and the test sets to create one data set."
## but using the "merge" function would have no sense. What is needed is a "union", ie. the test dataset is
## appended to the end of the training set
full_set <- rbind(full_train_set, full_test_set)


## using grep, find the columns' names that contain "-mean()" of "-std()", 
## 		but not those that are a function of a Mean (like "angle(tBodyAccJerkMean),gravityMean)" )
## ... and prepare the array for the columns we want to extract
mean_std_cols <- grep(".*-mean.*|.*std.*", names(full_set))
columns_to_extract <- c("subject_id",  "activity_id", "activity_name", names(full_set)[mean_std_cols] )

## extract the wanted columns into temp_df
temp_df <- full_set[, columns_to_extract ]


## using a data.table, calculate the mean of every column by subject_id,, activity_id, activity_name
## (if it even make sense, to compute the means of means and std !!?!?
## The mean of the columns subject_id, activity_id, activity_name are not computed
library(data.table)
DT <- data.table(temp_df)
result_dt <- DT[,lapply(.SD, mean), by = list(subject_id, activity_id, activity_name)]

## reorder the result_df on the subject_id and write the table to a text file
result_df <- result_df[order(result_df$subject_id),]

write.table(file=result_df_filename, x=result_df, row.name=FALSE)




