% ekstraksi fitur Haar Wavelet
function [ Normalize ] = zEkstraksi( eyeImage )
% 64 x 512 (asli)
% 32 x 256 (lvl 1)
% 16 x 128 (lvl 2)
% 8 x 64   (lvl 3)
% 4 x 32   (lvl 4)
wname = 'haar';
sizeNormalize = [4 32];

normal = zNormalisasi(eyeImage);
[C,~] = wavedec2(normal,4,wname);

Normalize = C(1:(sizeNormalize(1)*sizeNormalize(2)));

% MatNorm = zeros(sizeNormalize(1) , sizeNormalize(2));
% [row ,col] = size(MatNorm);
% 
% for i = 1:row*col
%    MatNorm(i) = C(i);
% end
% 
% Normalize = [];
% for j =1:row*col
%    Normalize = horzcat(Normalize,MatNorm(j)); 
% end




end

% ( take 33s to running till here)


% for i = 1:3
%     [CA,CH,CV,CD] = dwt2(X,wname);
%     X = CA;
% end