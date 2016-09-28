% mengubah ROI Iris ke koordinat polar (64x512)
function [ polar_array , polar_noise] = zNormalisasi( eyeImage )

% [~, circleIris, circlePupil, noise, ~, ~] = Akuisisi(pathImage);
[circleIris, circlePupil, noise] = zLingkaranIrisPupil(eyeImage);

% setting r dan theta(absis dan cordinat pada citra polar
[theta,r] = meshgrid(linspace(0,2*pi,512),linspace(0,1,64));

circleIris = double(circleIris);
circlePupil = double(circlePupil);

PupilCenterX = circlePupil(2);
PupilCenterY = circlePupil(1);
PupilR = circlePupil(3);
IrisR = circleIris(3);

% batas lingkaran pada lingkaran dalam (pupil)
xp = PupilCenterX + PupilR*cos(theta);
yp = PupilCenterY + PupilR*sin(theta);
% batas lingkaran pada lingkaran luar (iris)
xi = PupilCenterX + IrisR*cos(theta);
yi = PupilCenterY + IrisR*sin(theta);

%map ke koordinat polar
x = (1-r).*xp + r.*xi;
y = (1-r).*yp + r.*yi;

% [x0,y0] = meshgrid(1:size(noise,2),1:size(noise,1));
% ambil koordinat polar pd citra mata dgn interpolasi polar
% noise = noise./255;
polar_array = interp2(double(noise),x,y);

% noise array ganti NaN -> 1 (untuk hamming)
polar_noise = zeros(size(polar_array));
coords = find(isnan(polar_array));
polar_noise(coords) = 1;

polar_array = double(polar_array)./255;

% ganti nilai NaN dgn rata2 nilai piksel citra
coords = find(isnan(polar_array));
polar_array2 = polar_array;
polar_array2(coords) = 0.5;
avg = sum(sum(polar_array2)) / (size(polar_array,1)*size(polar_array,2));
polar_array(coords) = avg;


end




%{

radpixels = 64;angulardiv=512;

radiuspixels = radpixels + 2;
angledivisions = angulardiv-1;

r = 0:(radiuspixels-1);

theta = 0:2*pi/angledivisions:2*pi;

x_iris = double(circleIris(2));
y_iris = double(circleIris(1));
r_iris = double(circleIris(3));

x_pupil = double(circlePupil(2));
y_pupil = double(circlePupil(1));
r_pupil = double(circlePupil(3));

% calculate displacement of pupil center from the iris center
ox = x_pupil - x_iris;
oy = y_pupil - y_iris;

if ox <= 0
    sgn = -1;
elseif ox > 0
    sgn = 1;
end

if ox==0 && oy > 0
    
    sgn = 1;
    
end

r = double(r);
theta = double(theta);

a = ones(1,angledivisions+1)* (ox^2 + oy^2);

% need to do something for ox = 0
if ox == 0
    phi = pi/2;
else
    phi = atan(oy/ox);
end

b = sgn.*cos(pi - phi - theta);

% calculate radius around the iris as a function of the angle
r = (sqrt(a).*b) + ( sqrt( a.*(b.^2) - (a - (r_iris^2))));

r = r - r_pupil;

rmat = ones(1,radiuspixels)'*r;

rmat = rmat.* (ones(angledivisions+1,1)*[0:1/(radiuspixels-1):1])';
rmat = rmat + r_pupil;


% exclude values at the boundary of the pupil iris border, and the iris scelra border
% as these may not correspond to areas in the iris region and will introduce noise.
%
% ie don't take the outside rings as iris data.
rmat  = rmat(2:(radiuspixels-1), :);

% calculate cartesian location of each data point around the circular iris
% region
xcosmat = ones(radiuspixels-2,1)*cos(theta);
xsinmat = ones(radiuspixels-2,1)*sin(theta);

xo = rmat.*xcosmat;    
yo = rmat.*xsinmat;

x = x_pupil+xo;
y = y_pupil-yo;

%}
