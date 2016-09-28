% mendapatkan HAMMING distance dari dua template citra
function [ hd ] = zHamming( template1, mask1, template2, mask2 )
addpath(genpath('C:\Users\TX300C\Documents\MATLAB\TA'));

% mengubah double->logic
template1 = logical(template1);
mask1 = logical(mask1);
template2 = logical(template2);
mask2 = logical(mask2);

hd = NaN;

% penggabungan noise mask
mask = mask1 | mask2;
% perbandingan hamming(fungsi xor) & penghilangan noise
C = xor(template1,template2);
C = C & ~mask;

% bits true pada temp & noise
bitsC = sum(sum(C==1));
bitsMask = sum(sum(mask== 1));
% hitung bits tanpa termasuk noise
[row ,col] = size(template1);
totalBits = (row*col) - bitsMask;

% menghitung rate hamming distance
if totalBits == 0
    hd = NaN;

else        
    hd1 = bitsC / totalBits;
    if  hd1 < hd || isnan(hd)
        hd = hd1;
    end
end

end









%{
function templatenew = shiftbits(template, noshifts,nscales)

templatenew = zeros(size(template));

width = size(template,2);
s = round(2*nscales*abs(noshifts));
p = round(width-s);

if noshifts == 0
    templatenew = template;
    
    % if noshifts is negatite then shift towards the left
elseif noshifts < 0
    
    x=1:p;
    
    templatenew(:,x) = template(:,s+x);
    
    x=(p + 1):width;
    
    templatenew(:,x) = template(:,x-p);
    
else
    
    x=(s+1):width;
    
    templatenew(:,x) = template(:,x-s);
    
    x=1:s;
    
    templatenew(:,x) = template(:,p+x);
    
end
end
%}

