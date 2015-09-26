
#download the zip file and unzip to your work directory, you could skip the step if you have already downloaded the dataset
library(downloader)
download("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",dest='dataset.zip',mode="wb")
unzip("dataset.zip", exdir = "./")

#clarify the directory of test and train data sets
train_set_dir = './UCI HAR Dataset/train/X_train.txt'
test_set_dir = './UCI HAR Dataset/test/X_test.txt'
train_label_dir = './UCI HAR Dataset/train/y_train.txt'
test_label_dir = './UCI HAR Dataset/test/y_test.txt'
activity_labels_dir = './UCI HAR Dataset/activity_labels.txt'
train_subject_dir = './UCI HAR Dataset/train/subject_train.txt'
test_subject_dir = './UCI HAR Dataset/test/subject_test.txt'
feature_dir = './UCI HAR Dataset/features.txt'

#read activity labels
activity_labels = read.table(file = activity_labels_dir)
activity_labels <- data.frame(lapply(activity_labels, as.character), stringsAsFactors=FALSE)

#read subject
train_subject = read.table(file = train_subject_dir)
test_subject = read.table(file = test_subject_dir)

#read data set and merge the two data sets 
train_set = read.table(file = train_set_dir)
test_set = read.table(file = test_set_dir)

new_set = rbind(train_set, test_set)

#extract the mean and sd measurements
feature = read.table(file = feature_dir,stringsAsFactors = FALSE)
mean_variables_index = feature[grep("-mean()", feature[,2]),1]
std_variables_index = feature[grep("-std()", feature[,2]), 1]
final_variables_index = c(mean_variables_index, std_variables_index)
new_set = new_set[,final_variables_index]

#merge the two labels
train_label = read.table(file = train_label_dir) 
test_label = read.table(file = test_label_dir)
new_label = rbind(train_label, test_label)
new_label = as.vector(new_label)

for (i in 1:nrow(activity_labels)){
  temp1 = activity_labels[i,1]
  temp = activity_labels[i,2]
  new_label = replace(new_label, new_label==activity_labels[i,1], activity_labels[i,2])
}


#put activity,subject and data set together
new_subject = rbind(train_subject,test_subject)
final_data_set = cbind(new_label,new_subject,new_set)

#replace column names to feature names
colnames(final_data_set) = c("activity","subject",feature[final_variables_index,2])
#head(final_data_set)

#create a second data set which is the result data set required in step 5
library(plyr)
first_flag = FALSE

for (i in final_variables_index){
  variable_name = feature[i,2]
  atom_set = final_data_set[,c("subject","activity",variable_name)]
  colnames(atom_set)[3] = "obs"
  
  atom_set2 = ddply(atom_set,.(subject,activity), summarize, avg = mean(obs))
  
  if (!first_flag){
    second_data_set = atom_set2
    colnames(second_data_set)[ncol(second_data_set)] = variable_name
    } else{
      
    second_data_set = cbind(second_data_set,atom_set2[,3])
    colnames(second_data_set)[ncol(second_data_set)] = variable_name
    }
  first_flag = TRUE
}

#write the data frame into a txt file
write.table(second_data_set,"result_data_set.txt", row.names = FALSE)







