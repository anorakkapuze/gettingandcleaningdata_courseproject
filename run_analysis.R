#############################
# read in and label the test data
##################################

# read in test data
testfile <- "./UCI HAR Dataset/test/X_test.txt"
testdata <- read.table(testfile, sep="", nrows = -1, skip = 0, blank.lines.skip = TRUE, strip.white = TRUE)

#read in column labels of test data
featuresfile <- "./UCI HAR Dataset/features.txt"
featstr <- readLines(con=featuresfile)
featurelist <- lapply(featstr, function(x){strsplit(x, " ")[[1]][2]})
names(testdata) <- featurelist

# remove all columns that do not contain mean() or std()
valid_columns <- grepl("mean()", featurelist) | grepl("std()", featurelist)
testdata <- testdata[,valid_columns]

# reading in labels of activities and setting to the right factors
ytestfile <- "./UCI HAR Dataset/test/y_test.txt"
testactivities <- read.table(ytestfile)
labels <- list("Walking", "Walking upstairs", "walking downstairs",
               "sitting", "standing", "laying")
testactivities[, 1] <- as.factor(testactivities[, 1])
nowlevels <- levels(testactivities[,1])
for(istr in nowlevels){
  levels(testactivities[,1])[levels(testactivities[,1]) == istr] <- labels[[as.integer(istr)]]
}
testdata["Activity"]<-testactivities

# reading in subject numbers
subtestfile <- "./UCI HAR Dataset/test/subject_test.txt"
testsubjects <- read.table(subtestfile)
testdata["SubjectNumber"]<-testsubjects


#############################
# read in and label the training data
##################################

# read in training data
trainingfile <- "./UCI HAR Dataset/train/X_train.txt"
trainingdata <- read.table(trainingfile, sep="", nrows = -1, skip = 0, blank.lines.skip = TRUE, strip.white = TRUE)

# use the same features as column labels as for the test data
names(trainingdata) <- featurelist

# remove all columns that do not contain mean() or std()
valid_columns <- grepl("mean()", featurelist) | grepl("std()", featurelist)
trainingdata <- trainingdata[,valid_columns]

# reading in labels of activities and setting to the right factors
ytrainingfile <- "./UCI HAR Dataset/train/y_train.txt"
trainingactivities <- read.table(ytrainingfile)
labels <- list("Walking", "Walking upstairs", "walking downstairs",
               "sitting", "standing", "laying")
trainingactivities[, 1] <- as.factor(trainingactivities[, 1])
nowlevels <- levels(trainingactivities[,1])
for(istr in nowlevels){
  levels(trainingactivities[,1])[levels(trainingactivities[,1]) == istr] <- labels[[as.integer(istr)]]
}
trainingdata["Activity"]<-trainingactivities

# reading in subject numbers
subtrainingfile <- "./UCI HAR Dataset/train/subject_train.txt"
trainingsubjects <- read.table(subtrainingfile)
trainingdata["SubjectNumber"]<-trainingsubjects


##########################################
# merge the training and test data
############################################
merged_data <- merge(trainingdata, testdata, all = TRUE)

##############################
# grouping and taking the mean
library(dplyr)
grouped_data <- group_by_(merged_data, .dots=c("Activity", "SubjectNumber"))
mean_data <- summarize_each(grouped_data, funs(mean))

#renaming the cols
all_names = names(mean_data)
new_names <- character()
for(n in all_names){
  if(!grepl("Activity", n) & !grepl("SubjectNumber", n)){
    if(grepl("mean()", n)){
      new_names <- c(new_names, paste0("mean(", n, ")"))
    }
    else{
      new_names <- c(new_names, paste0("mean(", n, ")"))
    }
  }
  else{
    new_names <- c(new_names, n)
  }
}
mean_data <- setNames(mean_data, new_names)

####################################################
#write out
write.table(mean_data, "final_data_set.txt", row.name = FALSE)




