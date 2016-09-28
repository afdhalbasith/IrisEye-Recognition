% Ekstraksi Gabor untuk Hamming
function [ template, mask ] = zEkstraksiGabor( eyeimage )

[polar_array,noise_array] = zNormalisasi(eyeimage);

%feature encoding parameters
minWaveLength=18;%40;%20;%18;
sigmaOnf=0.5;%.75;%.25;%0.5;

% konvulsi normalisasi citra dgn Gabor filters
[E0] = gaborconvolve(polar_array, minWaveLength,sigmaOnf);

% iris template & mask
template = zeros(size(polar_array)); %64x512
mask = zeros(size(template)); %64x512

% Kuantisasi nilai ke 0 atau 1
E0 = E0{1};
H1 = real(E0) > 0;
H2 = imag(E0) > 0;

% if amplitude is close to zero then
% phase data is not useful, so mark off
% in the noise mask
H3 = abs(E0) < 0.0001;

nrows = 1:size(polar_array,1);
length = size(polar_array,2);

for i=0:(length-2)                
    ja = double((i));
    % biometric template
    template(nrows,ja+(2)-1) = H1(nrows, i+1);
    template(nrows,ja+(2)) = H2(nrows,i+1);
% lll=0;
    % noise mask
    mask(nrows,ja+(2)-1) = noise_array(nrows, i+1) | H3(nrows, i+1);
    mask(nrows,ja+(2)) =   noise_array(nrows, i+1) | H3(nrows, i+1);   
    
end    
% lll=0;
end

function [EO, filter] = gaborconvolve(im, minWaveLength,sigmaOnf)

[rows ,cols] = size(im);		

ndata = cols;
logGabor  = zeros(1,ndata);
result = zeros(rows,ndata);

matTemp = [0:fix(ndata/2)];
radius =  matTemp/fix(ndata/2)/2;  % values 0 - 0.5
radius(1) = 1;

wavelength = minWaveLength;        % wavelength 18
    

% Construct the filter - first calculate the radial filter component.
fo = 1.0/wavelength;                  % Centre frequency of filter.

% corresponding to fo.
logGabor(1:size(radius,2)) = exp((-(log(radius/fo)).^2) / (2 * log(sigmaOnf)^2));  
logGabor(1) = 0;  

filter = logGabor;

% for each row of the input image, do the convolution, back transform
for r = 1:size(im,1)	% For each row
    signal = im(r,1:ndata);
    imagefft = fft( signal);
    result(r,:) = ifft(imagefft .* filter);
end

% save the ouput for each scale
EO = {result};

filter = fftshift(filter);

end