Getting_and_Cleaning_Data
=========================

Getting and Cleaning Data - project

Each files has been loaded in defferent dataframe before being joined together
  * activity_labels
  * features 
  * subject_train 
  * x_train
  * y_train
  * subject_test 
  * x_test
  * y_test

Meaningful names has been given to coluns that represent ids

The following steps has been taken for both training and test sets:

  * merge y_train values with activity_labels, so we have the activity label on each row later in the final dataset
  * give names to x_train columns
  * prepend the subject_id to x_train, and append activity_id, activity_name to x_train to form the full train dataset
  * rename the subject_id column for convenience, because the cbind made it longer (subject_train$subject_id)

The two sets (training and test) have been rbound together to form a big dataframe

Then, only the columns containing "-mean()" of "-std()" in their names have been extracted, 
along with the useful columns  "subject_id", "activity_id", "activity_name",
in order the produce a final dataframe

Using a data.table, the mean of every column has been calculated grouped by subject_id , and the resulting table
has been saved into a text file named "result_df.txt"
 
 
