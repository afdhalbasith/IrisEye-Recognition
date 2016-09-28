function [ edge_image ] = zDeteksiTepi( eyeImage )

addpath(genpath('C:\Users\TX300C\Documents\MATLAB\TA'))

sigma = 2;          hithres = 0.2;
scaling = 0.4;      lowthres = 0.19;
vert = 1;
horz = 0.0;

% deteksi tepi, pengaturan brightness citra, thresholding
[I2 , or] = canny(eyeImage, sigma, scaling, vert, horz);
I3 = adjgamma(I2, 1.9);
I4 = nonmaxsup(I3, or, 1.5);

edge_image = hysthresh(I4, hithres, lowthres);

end

