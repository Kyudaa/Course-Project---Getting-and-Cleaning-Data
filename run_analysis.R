##Downloading and reading the Data:

dataURL<-"http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"

download.file(dataURL,destfile="C:/Users/Paul/Desktop/Courses on Data Analysis with R/R_Dateien/JHU_Getting and Cleaning Data/Course-Project---Getting-and-Cleaning-Data")

unzip("getdata_projectfiles_UCI HAR Dataset")
setwd("./UCI HAR Dataset")

##reading subjects
subject_train<-read.table("./train/subject_train.txt",header=FALSE)
subject_test<- read.table("./test/subject_test.txt", header = FALSE)

##reading necessary packages
library(data.table)

##Reading labels for activities
y_train <- read.table("./train/y_train.txt", header = FALSE)
y_test <- read.table("./test/y_test.txt", header = FALSE)

##Reading features
features<-read.table("features.txt")
X_train <- read.table("./train/X_train.txt", header = FALSE)
X_test <- read.table("./test/X_test.txt", header = FALSE)


##Preparing for merging, by matching column names

##1. For activity labels:
names(y_train) <- "ac_labels"
names(y_test) <- "ac_labels"
##2.For features:
names(X_train) <- features$V2
names(X_test) <- features$V2
##3. For subjects:
names(subject_train)<-"subject"
names(subject_test)<-"subject"

##Merging the two tables:

train_final <- cbind(subject_train, y_train, X_train)
test_final <- cbind(subject_test, y_test, X_test)
data<- rbind(train_final, test_final)


##Getting mean and std for each measurement:
col_mean<-data[,grep('mean()', names(data))]
col_std<-data[,grep('std()', names(data))]
col_key<-data[,(1:2)]
mean_std<-cbind(col_key,col_mean,col_std)

## Reading and adding labels for activities
labels<-read.table("activity_labels.txt")
data$ac_labels <- factor(data$ac_labels, labels=labels[2])

##Checking current names of columns:
names(data)

##Changing column names:

names(data)<-gsub("tBody","time_body ",names(data),fixed=TRUE)
names(data)<-gsub("tGravity","time_gravity ",names(data), fixed=TRUE)
names(data)<-gsub("fBody","frequency_body ",names(data), fixed=TRUE)
names(data)<-gsub("Acc","acceleration ",names(data), fixed=TRUE)
names(data)<-gsub("Gyro", "angular_velocity ",names(data), fixed=TRUE)
names(data)<-gsub("Jerk", "Jerk ",names(data), fixed=TRUE)
names(data)<-gsub("Mag","magnitude_signals ",names(data), fixed=TRUE)
names(data)<-gsub("-energy()","energy ",names(data), fixed=TRUE)
names(data)<-gsub("-entropy()","entropy ",names(data), fixed=TRUE)

names(data)<-gsub("-maxInds()", "index_of_frequency_component_with_largest_magnitude ",names(data), fixed=TRUE)
names(data)<-gsub("-meanFreq()","mean_frequency_weighed",names(data), fixed=TRUE)
names(data)<-gsub("-skewness()","skewness ",names(data), fixed=TRUE)
names(data)<-gsub("-kurtosis()","kurtosis ",names(data), fixed=TRUE)
names(data)<-gsub("-bandsEnergy()","energy_of_frequency_interval ",names(data), fixed=TRUE)

##coefficients
names(data)<-gsub("-arCoeff()","regression_coefficients ",names(data), fixed=TRUE)
names(data)<-gsub("-correlation()","correlation_coefficient ",names(data), fixed=TRUE)

##functions
names(data)<-gsub("-iqr()","interquartile_range ",names(data), fixed=TRUE)
names(data)<-gsub("-std()","standard_deviation ",names(data), fixed=TRUE)
names(data)<-gsub("-mad()","median_absolute_deviation ",names(data), fixed=TRUE)
names(data)<-gsub("-max()","maximum ",names(data), fixed=TRUE)
names(data)<-gsub("-min()","minimum ",names(data), fixed=TRUE)
names(data)<-gsub("-sma()","signal_magnitude_area ",names(data), fixed=TRUE)
names(data)<-gsub("-mean()","mean ",names(data), fixed=TRUE)



##finalizing data, creating tidy data set and taking average of each variable
data<-data.table(data)
tidy_data<-data[,lapply(.SD,mean),by="subject,ac_labels"]
write.table(tidy_data, file="tidydata.txt", row.names=FALSE, col.names=TRUE)

