
# @author: Corentin Vande Kerckhove
# Project for the course Getting and Cleaning Data

# Set directory corresponding to the location of the script
direct = "/Users/cvandekerckh/Dropbox/Doctorat/Formations/Cleaning/Project"
if (!file.exists(direct)){
	dir.create(direct)
}
setwd(direct)

# Read txt files
Xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
Xtrain <-read.table("UCI HAR Dataset/train/X_train.txt")


# Name of columns
name_subj <- "Subject number"
name_acti <- "Activity"
name_acti_idx <- "Activity index"
####################################
## STEP1 : Merges the training and the test sets to create one data set.
Xstep1 <- rbind(Xtest,Xtrain)

####################################

## STEP2: Extracts only the measurements on the mean and standard deviation for each measurement. 
# a) Extract features
features <- read.table("UCI HAR Dataset/features.txt")

# b) Extract mean and std index
idx <- grep("mean|std", features$V2)

# c) Extract corresponding measurements
Xstep2 <- Xstep1[idx]

####################################
## STEP3 :  Uses descriptive activity names to name the activities in the data set
# a) Extract the activities and the subjects 
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt") 
acti_test <- read.table("UCI HAR Dataset/test/y_test.txt") 
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt") 
acti_train <- read.table("UCI HAR Dataset/train/y_train.txt")

# b) Bind to the tables
subject_bind <- rbind(subject_test,subject_train)
acti_bind <- rbind(acti_test,acti_train)

colnames(acti_bind) <- name_acti_idx # Rename column name before binding
colnames(subject_bind) <- name_subj # Rename column name before binding
Xstep3 <- cbind(acti_bind,Xstep2) # Binding activities to data
Xstep3 <- cbind(subject_bind,Xstep3) # Binding subjects to data

# c) Extract activity names
acti_names <- read.table("UCI HAR Dataset/activity_labels.txt") 
colnames(acti_names) <- c(name_acti_idx,name_acti)

# d) Sort by subject number and by acti index
Xstep3 <- (Xstep3[order(Xstep3[,name_subj],Xstep3[,name_acti_idx]),])

####################################
## Step 4: Appropriately labels the data set with descriptive variable names

# a) Extract features' labels
new_labels <- features[idx,]
new_labels <- as.character(new_labels$V2)

# b) Transform names with reg exps and apply it to the dataframe
new_labels <- gsub("-"," ",new_labels)
new_labels <- gsub("[()]","",new_labels)
new_labels <- gsub("tB","Time B",new_labels)
new_labels <- gsub("tG","Time G",new_labels)
new_labels <- gsub("fB","FFT B",new_labels)
new_labels <- gsub("fG","FFT G",new_labels)

colnames(Xstep3) <- c(name_subj,name_acti_idx,new_labels) 

# c) Preparation for next step

ID = Xstep3[name_subj]*10 + Xstep3[name_acti_idx]
colnames(ID) = "ID"
Xstep4 <- cbind(ID,Xstep3)

####################################
# Step 5: Creates a second dataset with the average of each variable for each activity and subject

# a) Averaging considering the ID created

# For loop initialization - create tidy db Xstep5
offset <- 3 # The three information columns
N <- ncol(Xstep4) - offset
Xstep4_names <- names(Xstep4)
ID2 <- unique(ID)
Subjects <- ID2 %/% 10
Activity_index <- ID2 %% 10
Xstep5 = cbind(Subjects,Activities)

for (i in 1:N){
	V <- tapply(Xstep4[,i+offset],Xstep4$ID,mean)
	Xstep5 <- cbind(Xstep5,V)
}

colnames(Xstep5) = names(Xstep3) # Name conservation

####################################
# Step 6: Write table appropriately
# a) Replace Activity index by Activity labels
Xstep6 <- merge(Xstep5, acti_names, sort = TRUE)

# b) Choose column order
Xstep6 <- Xstep6[,c(name_subj,name_acti,name_acti_idx,new_labels)]

# c) Order by subjects and activity and suppress activity index
Xstep6 <- (Xstep6[order(Xstep6$"Subject number",Xstep6$"Activity index"),])
Xstep6 <- Xstep6[,c(name_subj,name_acti,new_labels)]

# d) Write table
write.table(Xstep6, "smartphone_tidy.txt", row.name = FALSE , sep = "\t")