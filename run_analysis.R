# Getting and cleaning data - human assessment assignment

# 1- Merge the training and the test sets to create one data set.
# 2- Extract only the measurements on the mean and standard deviation for each measurement.
# 3- Use descriptive activity names to name the activities in the data set.
# 4- Appropriately label the data set with descriptive variable names.
# 5- From the data in previous step, create a second, independent tidy data set with the
#    average of each variable for each activity and each subject.

init <- function(e) {
	e$zipFileName <- "dataset.zip"
	e$datasetFolderName <- "dataset"
	e$mainFolderName <- "UCI HAR Dataset"
	e$dataVariants <- c("train","test")
	e$labelsFilePrefix <- "y_"
	e$setFilePrefix <- "X_"
	e$subjectsFilePrefix <- "subject_"
	e$signalsFolderName <- "Inertial Signals"
	e$signalPrefixes <- c("body_acc_","body_gyro_","total_acc_")
	e$signalAxisInfixes <- c("x_","y_","z_")
	e$dataFileSuffix <- ".txt"
	e$windowSize <- 128
	e$labelColName <- "Label"
	e$subjectColName <- "Subject"
	e$setColName <- "OriginalSet"
	e$activityColName <- "Activity"
	e$includeInertialSignals <- TRUE
}

removeFiles <- function() {
	if (file.exists(zipFileName)) file.remove(zipFileName)
	if (file.exists(datasetFolderName)) unlink(datasetFolderName, recursive=TRUE)
}

prepareFiles <- function() {
	if (!file.exists(datasetFolderName)) {
		if (!file.exists(zipFileName)) {
			download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",zipFile)
		}
		unzip(zipFileName, exdir=datasetFolderName)
	}
}

checkFile <- function(fileType, fileName) {
	if (!file.exists(fileName)) stop(sprintf("%s file \"%s\" not found.", fileType, fileName))
}

loadData <- function(fileType, fileName, colNames) {
	checkFile(fileType, fileName)
	data <- read.table(fileName, stringsAsFactors=FALSE)
	if (ncol(data) != length(colNames)) stop(sprintf("wrong number of columns %d in %s file \"%s\".", ncol(data), fileType, fileName))
	names(data)=colNames
	data
}

loadActivityLabels <- function() {
	print('Loading activity labels...')
	loadData("activity labels", "activity_labels.txt", c("code","label"))
}

cleanName <- function(s) {
	s <- gsub('[\\(\\)_\\,\\-]','_',s)
	s <- gsub('_+','_',s)
	s <- gsub('^_|_$','',s)
	s <- gsub('BodyBody','Body',s)
	s <- gsub('Gyro','AngularVelocity',s)
	s <- gsub('t(Body|Gravity)','Time_\\1',s)
	s <- gsub('f(Body|Gravity)','Frequency_\\1',s)
	s <- gsub('^angle','Angle',s)
	s <- gsub('arCoeff','AutoRegressionCoefficients',s)
	s <- gsub('Mag_','Magnitude_',s)
	s <- gsub('_acc|Acc','LinearAcceleration',s)
	s <- gsub('_bandsEnergy','_EnergyOfFrequencyInterval',s)
	s <- gsub('_correlation','_Correlation',s)
	s <- gsub('_energy','_Energy',s)
	s <- gsub('_entropy','_Entropy',s)
	s <- gsub('_gravity','_Gravity',s)
	s <- gsub('_iqr','_InterQuartileRange',s)
	s <- gsub('_kurtosis','_Kurtosis',s)
	s <- gsub('_mad','_MedianAbsoluteDeviation',s)
	s <- gsub('_maxInds','_IndexOfFrequencyComponentWithLargestMagnitude',s)
	s <- gsub('_max','_Maximum',s)
	s <- gsub('_meanFreq','_MeanFrequency',s)
	s <- gsub('_mean','_Mean',s)
	s <- gsub('_min','_Minimum',s)
	s <- gsub('_skewness','_Skewness',s)
	s <- gsub('_sma','_SignalMagnitudeArea',s)
	s <- gsub('_std','_StandardDeviation',s)
	s
}

cleanInertialSignalName <- function(s) {
	s <- gsub('^body','Body',s)
	s <- gsub('^total','Total',s)
	s <- gsub('_acc','LinearAcceleration',s)
	s <- gsub('_gyro','AngularVelocity',s)
	s <- gsub('_x','_X',s)
	s <- gsub('_y','_Y',s)
	s <- gsub('_z','_Z',s)
	s
}

loadFeatures <- function() {
	print('Loading features...')
	data <- loadData("features", "features.txt", c("code","feature"))
	data$feature <- lapply(data$feature, cleanName)
	data$feature <- make.names(data$feature, unique=TRUE, allow_=FALSE)
	data
}

loadVariant <- function(kind, prefix, variant, colNames) {
	print(sprintf('Loading %s %s (%s)...', kind, prefix, variant))
	fileName <- paste(prefix, variant, dataFileSuffix, sep="")
	loadData(sprintf("%s %s", variant, kind), fileName, colNames)
}

loadSet <- function(variant, features) {
	print(sprintf('Loading set (%s)...', variant))
	loadVariant("set", setFilePrefix, variant, features$feature)
}

loadLabels <- function(variant) {
	print(sprintf('Loading labels (%s)...', variant))
	loadVariant("labels", labelsFilePrefix, variant, labelColName)
}

loadSubjects <- function(variant) {
	print(sprintf('Loading subjects (%s)...', variant))
	loadVariant("subjects", subjectsFilePrefix, variant, subjectColName)
}

loadSignals <- function(variant) {
	print(sprintf('Loading signals (%s):', variant))
	baseDir <- getwd()
	setwd(signalsFolderName)
	data <- NULL
	for (prefix in signalPrefixes) {
		for (axis in signalAxisInfixes) {
			filePrefix <- paste(prefix, axis, sep="")
			colNames <- sapply(1:windowSize,function(v){sprintf("%s%03d",filePrefix, v)})
			colNames <- sapply(colNames, cleanInertialSignalName, USE.NAMES=FALSE)
			colNames <- make.names(colNames, unique=TRUE, allow_=FALSE)
			newData <-loadVariant(sprintf("%s%sdata", prefix, axis), filePrefix, variant, colNames)
			if (is.null(data))
				data <- newData
			else data <- cbind(data, newData)
		}
	}
	setwd(baseDir)
	data
}

loadVariantData <- function(variant, features) {
	print(sprintf('Loading data (%s):', variant))
	baseDir <- getwd()
	setwd(variant)
	dt_set <- loadSet(variant, features)
	dt_labels <- loadLabels(variant)
	dt_subjects <- loadSubjects(variant)
	if (includeInertialSignals) dt_signals <- loadSignals(variant)
	setwd(baseDir)
	if (includeInertialSignals)
		cbind(dt_subjects, dt_labels, dt_set, dt_signals)
	else cbind(dt_subjects, dt_labels, dt_set)
}

loadAll <- function() {
	init(parent.frame())
	dt_activityLabels <- loadActivityLabels()
	dt_features <- loadFeatures()
	dt_full <- NULL
	for (variant in dataVariants) {
		dt_variant <- loadVariantData(variant, dt_features)
		dt_variant[[setColName]] <- variant
		if (is.null(dt_full))
			dt_full <- dt_variant
		else dt_full <- rbind(dt_full, dt_variant)
	}
	dt_full[[activityColName]] <- dt_activityLabels[[labelColName]][dt_full[[activityColName]]]
	dt_full
}

main <- function() {
	prepareFiles()
	tidy <- loadAll()
}
