# 1. Download and unzup the file, if it's not done already

fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (! file.exists("dataset.zip")) {
    download.file(fileUrl, "dataset.zip",mode = 'wb')    
    unzip("dataset.zip", exdir = ".")
}


# 2. Read all data
testDataActivity <- read.table("UCI HAR Dataset\\test\\y_test.txt", sep = "", header = F)
trainDataActivity <- read.table("UCI HAR Dataset\\train\\y_train.txt", sep = "", header = F)

testDataSubject <- read.table("UCI HAR Dataset\\test\\subject_test.txt", sep = "", header = F)
trainDataSubject <- read.table("UCI HAR Dataset\\train\\subject_train.txt", sep = "", header = F)

testDataFeatures <- read.table("UCI HAR Dataset\\test\\X_test.txt", sep = "", header = F)
trainDataFeatures <- read.table("UCI HAR Dataset\\train\\X_train.txt", sep = "", header = F)

# 3. Connect train and test
DataFeatures <- rbind(testDataFeatures, trainDataFeatures)
DataActivity <- rbind(testDataActivity, trainDataActivity)
DataSubject  <- rbind(testDataSubject, trainDataSubject)



# Clean some memory space
rm(testDataActivity)
rm(trainDataActivity)
rm(testDataSubject)
rm(trainDataSubject)
rm(testDataFeatures)
rm(trainDataFeatures)

# 4. Set names to columns
names(DataActivity) <- c("Activity")
names(DataSubject) <- c("Subject")

# for features, it's a little bit complicated
featuresColNames = read.csv("UCI HAR Dataset\\features.txt", sep = "", header = F)
names(DataFeatures) <- featuresColNames[,2]


# 5. Remove columns we dont need. The names will be find by finding the mean and std
neededColumnNames  <- featuresColNames$V2[grep("mean\\(\\)|std\\(\\)", featuresColNames$V2)]
NeededDataFeatures <- subset(DataFeatures, select = as.character(neededColumnNames))

# 6. Merge result data
SubjectAndActivityData <- cbind(DataSubject,DataActivity)
ResultData <- cbind(SubjectAndActivityData,NeededDataFeatures)

# Clean some memory space
rm(DataActivity)
rm(DataSubject)
rm(DataFeatures)
rm(featuresColNames)
rm(SubjectAndActivityData)
rm(NeededDataFeatures)
rm(fileUrl)
rm(neededColumnNames)

# 7. Descriptive activities names
ActivitiesNames <- read.csv("UCI HAR Dataset\\activity_labels.txt", sep = "", header = F)
ResultData[, 2] = ActivitiesNames[ResultData[, 2], 2]
rm(ActivitiesNames)


# 8. Change the column names
names(ResultData)<-gsub("Body", "", names(ResultData))
names(ResultData)<-gsub("\\()", "", names(ResultData))
names(ResultData)<-gsub("^t", "Time", names(ResultData))
names(ResultData)<-gsub("^f", "Frequency", names(ResultData))
names(ResultData)<-gsub("Acc", "Accelerometer", names(ResultData))
names(ResultData)<-gsub("Gyro", "Gyroscope", names(ResultData))
names(ResultData)<-gsub("Mag", "Magnitude", names(ResultData))

# 9. Calculate average for each data set
library(plyr);
TidyData<-aggregate(. ~Subject + Activity, ResultData, mean)

# 10. Write tidy data set
write.table(TidyData, file = "tidydata.txt",row.name=F, col.names = T)
