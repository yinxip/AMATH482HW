# data-analysis-amath482
AMATH482: Computational Methods For Data Analysis
Exploratory and objective data analysis methods applied to the physical, 
engineering, and biological sciences. Brief review of statistical methods 
and their computational implementation for studying time series analysis, 
spectral analysis, filtering methods, principal component analysis, orthogonal 
mode decomposition, and image processing and compression.

This repository includes 5 projects from this course: de-nosing data, time-frequency
analysis, PCA analysis, music gener classfication and neural networks.

Project1:
This report describes methods to obtain the exact location of the marble inside a dog’s intestines from an ultrasound dataset that contains 20 distinct measurements. The main methods used are called averaging and ﬁltering which are based on the Fourier Transform. The frequency signature sent by the object is found by averaging the spectrum. The exact location of the object during each measurement is determined by ﬁlter out the data around the center frequency. The path of the marble is located by plotting the location of it in diﬀerent measurements.

Porject2:
The ﬁrst part analysis a music in MATLAB. Produce the spectrogram of the music by Gabor transform, Mexican Hat wavelet, and Shannon wavelet. Examine e!ect of the width of the Gabor ﬁlter on the music data. Explore the idea of oversampling and undersampling. The second part reproduces music scores of a song in two distinct versions. Filter the data by Gabor transform and plot them in spectrogram. Discover the di!erence between the two recordings.

Project3:
The report analysis 12 movies that ﬁlm the movement of a bucket with a ﬂashlight on top of it. The main method used is Principal Component Analysis(PCA). The location of the bucket is found by converting the ﬁlm into grayscale and then ﬁltering with the Shannon window. Singular Value Decomposition has been applied to the position data matrix. Various aspects of PCA are illustrated and comparisons between diﬀerent cases are presented.

Project4:

The report talks about how to perform music classiﬁcations in Matlab. The main method used is the Linear Discriminant Analysis. Perform classiﬁcation by sampling 5-second clips from a variety of music. The report classiﬁes three diﬀerent cases. The ﬁrst one is classifying songs from three diﬀerent bands in three diﬀerent genres. The second one is classifying three diﬀerent bands in the Seattle area. The last one is classifying three diﬀerent genres in general where the singer is diﬀerent from each song. The accuracy achieved in the ﬁrst test is 63.64% The accuracy achieved in the second test is 60.61% The accuracy achieved in the third test is 42.42%.

Project5:
The report talks about how to classify diﬀerent images by neural networks. The main method used is the deep learning neural network. The report classiﬁes 10 diﬀerent fashion images, each representing some fashion elements such as cloth, and shoes. The ﬁrst part uses the fully-connected neural network to classify the image and achieves an accuracy of 87%. The second part uses the convolutional neural network and achieves an accuracy of 88.9%.
