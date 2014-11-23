Getting_and_Cleaning_Data
=========================

Getting and Cleaning Data - project

The file "codebook.md" contains a description of the variables from the original datasets used in the analysis, along with the list of the variables presented in the final data table, as produced by the R script.

The file "run_analysis.R" is the R script created to process the original dataset. The script is fully documented, but all the steps involved are described below.

----

The following files has been loaded in different dataframes and Meaningful names has been given to coluns that represent ids:

  * activity_labels.txt
  * features.txt
  * subject_train.txt
  * X_train.txt
  * y_train.txt
  * subject_test.txt
  * X_test.txt
  * y_test.txt

Resulting dataframes:

  * activity_labels
  * features 
  * subject_train 
  * x_train
  * y_train
  * subject_test 
  * x_test
  * y_test

The following steps has been taken for both training and test sets in order to join them in a proper way:

  * merge y_train values with activity_labels, so that we have the activity label on each row later in the final dataset;
  * give names to x_train columns using the features dataset;
  * cbind x_train and y_train together, and prepend the subject_id in order to form the full train dataset;
  * rename the subject_id column for convenience, because the cbind made it longer (subject_train$subject_id);
  * do the same with the test dataset
   
The two sets (training and test) have been rbound together to form a big full dataframe.

Then, only the columns containing "-mean()" of "-std()" in their names have been extracted, along with the useful columns  "subject_id", "activity_id", "activity_name", in order the produce a temporary data frame.

Using a data.table, the mean of every column has been calculated grouped by subject_id, activity_id and activity_name.
And the resulting table, after being sorted on the subject_id, has been saved into a text file named "result_df.txt"

 
