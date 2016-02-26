## Describes the variables, the data, and work performed to get and to lean up the data 

1. Download and unzup the file, if it's not done already
2. Read all data in local variables (in memory)
3. Connect train and test data sets by row bind function (rbind)
4. Set names to new columns (Activity and Subject)
	For features, it's a little bit complicated because separate data set shoud be readed 
5. Remove columns we dont need. The names which we need will be found by finding the strings "mean" and "std"
6. Merge result data by column bind function (cbind)
7. Descriptive activities names - replacing integers by factors found in file activity_labels
8. Change the column names  - make it descriptive
9. Calculate average for each data set, using plyr library
10. Write tidy data in file named tidydata.txt

* In several lines in code, I delete the memory object that I don't need any more.

