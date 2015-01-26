#Codebook.md

1716 variables are defined here in this data set.

##Context variables

- OriginalSet
  - indicates which original set the data comes from.
  - either 'train' or 'test'.
- Subject
  - number identifying the subject from whom data was collected.
  - integer from 1 to 30.
- Activity
  - activity performed by the subject.
  - values: WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING

##Measurement variables

These variables are defined according to the following elements:
- \<reference\>: Body or Gravity
- \<kind\>: AngularVelocity or LinearAcceleration
- \<domain\>: optional. Frequency or Time
- \<variant\>: optional. Jerk
- \<derivative\>: optional. Magnitude
- \<function>: can be:
  - Energy + \<axis\>
  - EnergyOfFrequencyInterval + interval + optional duplicate number (1 or 2)
    - 1.8, 9.16, 17.24, 25.32, 33.40, 41.48, 49.56 or 57.64
    - 1.16, 17.32, 33.48 or 49.64
    - 1.24, 25.48 or 49.64
  - Entropy + \<axis\>
  - IndexOfFrequencyComponentWithLargestMagnitude + \<axis\>
  - InterQuartileRange + \<axis\>
  - Kurtosis + \<axis\>
  - Maximum + \<axis\>
  - Mean + \<axis\>
  - MeanFrequency + \<axis\>
  - MedianAbsoluteDeviation + \<axis\>
  - Minimum + \<axis\>
  - SignalMagnitudeArea
  - Skewness + \<axis\>
  - StandardDeviation + \<axis\>
  - AutoRegressionCoefficients
  - Correlation
  - 

- <\axis\>: X or Y or Z


All measurements are normalized and unitless.

##Inertial Signals variables

These variables hold 3 types of data:
- TotalLinearAcceleration: The acceleration signal from the smartphone accelerometer in standard gravity units 'g'.
- BodyLinearAcceleration: The body acceleration signal obtained by subtracting the gravity from the total acceleration. Same units.
- BodyAngularVelocity: The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

For each type, there is a 128-element vector, along each of the three X, Y and Z axes.

Variables are therefore named according to the following scheme: \<type of data\>.\<axis\>.\<element number\>, where:
- \<type of data\> is BodyLinearAcceleration or BodyAngularVelocity or TotalLinearAcceleration according to the considered type of data.
- \<axis\> is X or Y or Z according to the considered axis.
- \<element number\> is an integer between 1 and 128.

Example: BodyAngularVelocity.X.108 for the acceleration signal minus the gravity, along X axis, sample number 108.
