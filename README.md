# How to execute the code?

The file run_analysis.R is an R file and should be placed in the same directory as UCI HAR DATASET.
It produces an output file smartphone_tidy.txt corresponding to a tidy version of the whole dataset.
The output file contains the average value of the mean and standard deviation of the mobilephone dataset.

# What does the code do?

The code follows the steps required for the projects:


STEP1: It merges the training and the test sets using rbind

STEP2: It extracts features, filters them keeping only mean and std index and extracts the corresponding measurements

STEP3: It extracts the activities and the subjects and binds them to the table and extracts the activity labels 

STEP4: It extracts the features and uses regular expression to make them more readable (see codebook)

STEP5: It creates a datasets by taking average of the values per activity and subjects, using an unique ID process

STEP6: It cleanes the data by ordering the columns and rows, and write the frame in a txt file



# Codebook - What is the meaning of the variables?

Subject number

	The subject identification number
	Value from 1 to 30

Activity

	Type of activity performed by the subject
	Possible values:
		WALKING
		WALKING_UPSTAIRS
		WALKING_DOWNSTAIRS
		SITTING
		STANDING
		LAYING 	

Other variables (from -1 to 1, normalized units)

	They are composed of different items:
		Item 1 : Frequential (FFT) or Time (TIME) domain
		Item 2 : Body and gravity movement
				BodyAcc
				GravityAcc
				BodyAccJerk
				BodyGyro-XYZ
				BodyGyroJerk
				BodyAccMag
				GravityAccMag
				BodyAccJerkMag
				BodyGyroMag
				BodyGyroJerkMag
				BodyAcc-XYZ
				BodyAccJerk
				BodyGyro
				BodyAccMag
				BodyAccJerkMag
				BodyGyroMag
				BodyGyroJerkMag
		Item 3 : Type of information (mean, meanfreq or std)
		Item 4 : Information about direction (X, Y or Z)

