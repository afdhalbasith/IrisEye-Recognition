function [ circleiris, circlepupil, imagewithnoise] = zLingkaranIrisPupil(eyeimage)

addpath(genpath('C:\Users\TX300C\Documents\MATLAB\TA'))

% menentukan radius pupil & iris
lpupilradius = 28;
upupilradius = 75;
lirisradius = 80;
uirisradius = 150;

% scale untuk mempercepat Hough transform
scaling = 0.4;

% deteksi lingkaran iris ==> double
% Hough Transform
[row, col, r] = findcircle(eyeimage, lirisradius, uirisradius, scaling,...
    2, 0.20, 0.19, 1.00, 0.00);

circleiris = [row col r];

rowd = double(row);
cold = double(col);
rd = double(r);

% menentukan panjang&lebar ROI iris
irl = round(rowd-rd);
iru = round(rowd+rd);
icl = round(cold-rd);
icu = round(cold+rd);

if irl < 1 
    irl = 1;
end
if icl < 1
    icl = 1;
end
if iru > size(eyeimage,1)
    iru = size(eyeimage,1);
end
if icu > size(eyeimage,2)
    icu = size(eyeimage,2);
end

% mengambil ROI iris | mengcrop iris dr ujung ke ujung dr gambar asli
imagepupil = eyeimage( irl:iru,icl:icu);

% deteksi lingkaran pupil ==> double
[rowp, colp, r] = findcircle(imagepupil, lpupilradius, upupilradius ,...
    0.6,2,0.25,0.25,1.00,1.00);

rowp = double(rowp);
colp = double(colp);
r = double(r);

% penjumlahan rad dgn titik pusat untuk mendapatkan posisi yg tepat
% disesuaikan dengan gambar mata yg asli
row = double(irl) + rowp;
col = double(icl) + colp;

row = round(row);
col = round(col);

circlepupil = [row col r];


% -------- Remove Noise -----------%
imagewithnoise = double(eyeimage);

% membuat garis dgn bulu mata dgn Hough linear
topeyelid = imagepupil(1:(rowp-r),:);
lines = findline(topeyelid);

if size(lines,1) > 0
    [xl yl] = linecoords(lines, size(topeyelid));
    yl = double(yl) + irl-1;
    xl = double(xl) + icl-1;
    
    % pilih batas y yg max
    yla = max(yl);
    
    % menentukan garis batas kedua
    y2 = 1:yla;
    % ind3 = sub2ind(size(eyeimage),yl,xl);
    % imagewithnoise(ind3) = NaN;
    
    % nandai noise dgn NaN
    imagewithnoise(y2, xl) = NaN;
end

%find bottom eyelid
bottomeyelid = imagepupil((rowp+r):size(imagepupil,1),:);
lines = findline(bottomeyelid);

if size(lines,1) > 0
    
    [xl yl] = linecoords(lines, size(bottomeyelid));
    yl = double(yl)+ irl+rowp+r-2;
    xl = double(xl) + icl-1;
    
    yla = min(yl);
    
    y2 = yla:size(eyeimage,1);
    
    % ind4 = sub2ind(size(eyeimage),yl,xl);
    % imagewithnoise(ind4) = NaN;
    imagewithnoise(y2, xl) = NaN;
    
end

% menghilangkan bulu mata, thresholding
ref = eyeimage < 100;
coords = find(ref==1);
imagewithnoise(coords) = NaN;



end

